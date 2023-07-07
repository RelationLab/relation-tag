package com.relation.tag.manager.impl;

import com.relation.tag.entity.DimRuleSqlContent;
import com.relation.tag.entity.FileEntity;
import com.relation.tag.manager.TagAddressManager;
import com.relation.tag.service.IAddressLabelGpService;
import com.relation.tag.service.IDimRuleSqlContentService;
import com.relation.tag.util.FileUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.util.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.List;
import java.util.concurrent.ForkJoinPool;

@Service
@Slf4j
public class TagAddressManagerImpl implements TagAddressManager {
    @Autowired
    @Qualifier("greenplumDimRuleSqlContentServiceImpl")
    private IDimRuleSqlContentService dimRuleSqlContentService;
    @Autowired
    @Qualifier("greenPlumAddressLabelGpServiceImpl")
    protected IAddressLabelGpService iAddressLabelService;

    @Value("${config.environment:stag}")
    protected String configEnvironment;
    protected static ForkJoinPool forkJoinPool = new ForkJoinPool(500);
    static String INIT_PATH = "initsql";

    public static String SCRIPTSPATH = "tagscripts";
    public static String DIM_PATH = "dim";

    private void tagByRuleSqlList(List<FileEntity> ruleSqlList, String batchDate) {
        try {
            forkJoinPool.execute(() -> {
                ruleSqlList.parallelStream().forEach(ruleSql -> {
                    execContentSql(ruleSql, batchDate);
                });
            });
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void execContentSql(FileEntity ruleSql, String batchDate) {
        try {
            String tableName = ruleSql.getFileName();
            String table = tableName.split("\\.")[0];
            if (checkResult(table, batchDate, 1, false)) {
                return;
            }
            iAddressLabelService.exceSql(ruleSql.getFileContent(), ruleSql.getFileName());
        } catch (Exception ex) {
            try {
                Thread.sleep(1 * 60 * 1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            execContentSql(ruleSql, batchDate);
        }

    }

    public boolean checkResult(String tableName, String batchDate, Integer result, boolean likeKey) {
        if (StringUtils.isEmpty(tableName)) {
            return false;
        }
        try {
            Integer tagInteger = checkResultData(tableName, batchDate, likeKey);
            log.info("tableName==={},tagList.size===={}", tableName, tagInteger);
            return tagInteger != null && tagInteger.intValue() >= result;
        } catch (Exception ex) {
            return false;
        }
    }

    private Integer checkResultData(String tableName, String batchDate, boolean likeKey) {
        String checkSql = "select count(1) from ".concat(" tag_result where 1=1 and ");
        if (likeKey) {
            checkSql = checkSql.concat(" table_name like '").concat(tableName).concat("%");
        } else {
            checkSql = checkSql.concat(" table_name='").concat(tableName);
        }
        checkSql = checkSql.concat("' and batch_date='").concat(batchDate).concat("'");
        return iAddressLabelService.exceSelectSql(checkSql);
    }

    public void check(String tableName, long sleepTime, String batchDate, int resultNum, boolean likeKey) {
        log.info("check tableName ===={} batchDate={} resultNum={} start.......", tableName,batchDate,resultNum);
        if (StringUtils.isEmpty(tableName)) {
            return;
        }
        while (true) {
            try {
                Integer tagInteger = checkResultData(tableName, batchDate, likeKey);
                if (tagInteger != null && tagInteger.intValue() >= resultNum) {
                    log.info("check table ===={} end.......tagList.size===={}", tableName, tagInteger);
                    break;
                }
            } catch (Exception ex) {
                try {
                    Thread.sleep(sleepTime);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
            try {
                Thread.sleep(sleepTime);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

    }

    @Override
    public void refreshAllLabel(String batchDate) throws Exception {
        String checkTable = "address_labels_json_gin_".concat(configEnvironment);
        if (!checkResult(checkTable, batchDate, 1, false)) {
            tag(batchDate);
        }
    }

    private void tag(String batchDate) throws Exception {
        /****
         * 如果正在打标签，等待.....
         */
        checkTagging(batchDate);
        if (!checkResult("address_label", batchDate, 62, true)) {
            createView(batchDate);
            check("create_view", 60 * 1000, batchDate, 1, false);
            innit(batchDate);
            check("total_volume_usd", 1 * 60 * 1000, batchDate, 1, false);
            List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.list();
            List<FileEntity> fileList = Lists.newArrayList();
            for (DimRuleSqlContent item : ruleSqlList) {
                String fileName = item.getRuleName().concat(".sql");
                fileList.add(FileEntity.builder().fileName(fileName)
                        .fileContent(FileUtils.readFile(SCRIPTSPATH.concat(File.separator)
                                .concat(fileName))).build());
            }
            tagByRuleSqlList(fileList, batchDate);
        }
        check("address_label", 60 * 1000, batchDate, 62, true);
        tagMerge(batchDate);
    }

    private void checkTagging(String batchDate) throws InterruptedException {
        while (true){
            boolean taggingFlag = checkResult("tagging", batchDate, 1, false);
            if (!taggingFlag){
                break;
            }
            Thread.sleep(10 * 60 * 1000);
        }
    }

    private void createView(String batchDate) {
        execSql(null, "drop_view.sql", batchDate, INIT_PATH, null);
        execSql("drop_view", "dms_syn_block.sql", batchDate, INIT_PATH, null);
        execSql("dms_syn_block", "snapshot_table.sql", batchDate, INIT_PATH, null);
        execSql("snapshot_table", "create_view.sql", batchDate, INIT_PATH, null);
        execSql("create_view", "token_platform.sql", batchDate, INIT_PATH, null);
        execSql("token_platform", "nft_platform.sql", batchDate, INIT_PATH, null);
        execSql("nft_platform", "dim_rule_sql_content.sql", batchDate, INIT_PATH, null);

        execSql("dim_rule_sql_content", "combination.sql", batchDate, DIM_PATH, null);
        execSql("combination", "dex_action_platform.sql", batchDate, DIM_PATH, null);
        execSql("dex_action_platform", "label.sql", batchDate, DIM_PATH, null);
        execSql("label", "level_def.sql", batchDate, DIM_PATH, null);
        execSql("level_def", "mp_nft_platform.sql", batchDate, DIM_PATH, null);
        execSql("mp_nft_platform", "nft_trade_type.sql", batchDate, DIM_PATH, null);
        execSql("nft_trade_type", "platform.sql", batchDate, DIM_PATH, null);
        execSql("platform", "platform_detail.sql", batchDate, DIM_PATH, null);
        execSql("platform_detail", "trade_type.sql", batchDate, DIM_PATH, null);
        execSql("trade_type", "web3_action.sql", batchDate, DIM_PATH, null);
        execSql("web3_action", "web3_action_platform.sql", batchDate, DIM_PATH, null);
        execSql("web3_action_platform", "web3_platform.sql", batchDate, DIM_PATH, null);

        execSql("web3_platform", "label_factor_seting.sql", batchDate, DIM_PATH, null);
        execSql("label_factor_seting", "dim_project_token_type.sql", batchDate, DIM_PATH, null);
        execSql("dim_project_token_type", "dim_project_type.sql", batchDate, DIM_PATH, null);
        execSql("dim_project_type", "dim_rule_content.sql", batchDate, DIM_PATH, null);



    }

    private void innit(String batchDate) throws Exception {
        String dir = INIT_PATH;
        execSql("dim_rule_content", "white_list_erc20.sql", batchDate, dir, null);
        execSql("white_list_erc20", "platform_nft_volume_usd.sql", batchDate, dir, null);
        execSql("platform_nft_volume_usd", "nft_transfer_holding.sql", batchDate, dir, null);
        execSql("nft_transfer_holding", "nft_volume_count.sql", batchDate, dir, null);
        execSql("nft_volume_count", "platform_nft_type_volume_count.sql", batchDate, dir, null);
        execSql("platform_nft_type_volume_count", "token_holding_uni_cal.sql", batchDate, dir, null);
        execSql("token_holding_uni_cal", "token_balance_volume_usd.sql", batchDate, dir, null);
        execSql("token_balance_volume_usd", "total_balance_volume_usd.sql", batchDate, dir, null);
        execSql("total_balance_volume_usd", "web3_transaction_record_summary.sql", batchDate, dir, null);
        execSql("web3_transaction_record_summary", "dex_tx_volume_count_summary_stake.sql", batchDate, dir, null);
        execSql("total_balance_volume_usd", "dex_tx_volume_count_summary_univ3.sql", batchDate, dir, null);
        execSql("dex_tx_volume_count_summary_univ3", "dex_tx_count_summary.sql", batchDate, dir, null);
        execSql("dex_tx_count_summary", "dex_tx_volume_count_summary.sql", batchDate, dir, null);
        Thread.sleep(3 * 60 * 1000);
        execSql("dex_tx_volume_count_summary", "erc20_tx_record_hash.sql", batchDate, dir, null);
        boolean token_holding_vol_countcheck = execSql("dex_tx_volume_count_summary", "eth_holding_vol_count.sql", batchDate, dir, null);
        if (!token_holding_vol_countcheck) {
            Thread.sleep(1 * 60 * 1000);
        }
        boolean dms_syn_blockcheck = execSql("erc20_tx_record_hash", "token_holding_vol_count.sql", batchDate, dir, null);
        if (!dms_syn_blockcheck) {
            Thread.sleep(1 * 60 * 1000);
        }
        boolean total_volume_usdcheck = execSql("token_holding_vol_count", "token_volume_usd.sql", batchDate, dir, null);
        if (!total_volume_usdcheck) {
            Thread.sleep(5 * 60 * 1000);
        }
        execSql("token_volume_usd", "total_volume_usd.sql", batchDate, dir, null);
    }

    private boolean execSql(String lastTableName, String sqlName, String batchDate, String dir, String tableSuffix) {
        String tableName = sqlName.split("\\.")[0];
        String finalTableName = tableName;
        forkJoinPool.execute(new Runnable() {
            @Override
            public void run() {
                execSynSql(lastTableName, sqlName, finalTableName, batchDate, dir, tableSuffix);
            }
        });
        return checkResult(finalTableName, batchDate, 1, false);
    }

    private void execSynSql(String lastTableName, String sqlName, String tableName, String batchDate, String dir, String tableSuffix) {
        check(lastTableName, 20 * 1000, batchDate, 1, false);
        try {
            if (checkResult(tableName, batchDate, 1, false)) {
                return;
            }
            String exceSql = FileUtils.readFile(dir.concat(File.separator).concat(sqlName));
            if (StringUtils.isNotEmpty(tableSuffix)) {
                exceSql = exceSql.replace("${tableSuffix}", tableSuffix);
            }
            iAddressLabelService.exceSql(exceSql, sqlName);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            try {
                Thread.sleep(1 * 60 * 1000);
            } catch (InterruptedException ex) {
                throw new RuntimeException(ex);
            }
            log.info("sqlName==={} try ......", sqlName);
            execSynSql(lastTableName, sqlName, tableName, batchDate, dir, tableSuffix);
        }
    }

    @Override
    public void tagMerge(String batchDate) throws Exception {
        execSql(null, "address_label_gp.sql", batchDate, INIT_PATH, configEnvironment);
    }


}
