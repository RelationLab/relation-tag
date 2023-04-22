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

    public static String SNAPSHOTPATH = "snapshot";

    public static String STATICDATA_PATH = "staticdata";

    public static String STAG = "stag";


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
            if (checkResult(table, batchDate, 1)) {
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

    public boolean checkResult(String tableName, String batchDate, Integer result) {
        if (StringUtils.isEmpty(tableName)) {
            return false;
        }
        try {
            Integer tagInteger = checkResultData(tableName, batchDate);
            log.info("tableName==={},tagList.size===={}", tableName, tagInteger);
            return tagInteger != null && tagInteger.intValue() >= result;
        } catch (Exception ex) {
            return false;
        }
    }

    private Integer checkResultData(String tableName, String batchDate) {
        return iAddressLabelService.exceSelectSql("select count(1) from ".concat("tag_result where 1=1 and table_name='").concat(tableName)
                .concat("' and batch_date='").concat(batchDate).concat("'"));
    }

    public void check(String tableName, long sleepTime, String batchDate, int resultNum) {
        if (StringUtils.isEmpty(tableName)) {
            return;
        }
        while (true) {
            try {
                Integer tagInteger = checkResultData(tableName, batchDate);
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
        if (!checkResult("address_labels_json_gin", batchDate, 1)) {
            tag(batchDate);
        }
    }

    private void tag(String batchDate) throws Exception {
        if(StringUtils.equals(STAG,configEnvironment)){
            snapshot(batchDate);
            innit(batchDate);
            Thread.sleep(10 * 60 * 1000);
            check("total_volume_usd", 1 * 60 * 1000, batchDate, 1);
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
        tagMerge(batchDate);
        Thread.sleep(2 * 60 * 1000);
        staticData(batchDate);
    }

    private void snapshot(String batchDate) {
        if (checkResult("snapshot_table", batchDate, 1)) {
            return;
        }
        String dir = SNAPSHOTPATH;
//        execSql(null, "snapshot_address_info.sql", batchDate, dir, null);
//        execSql(null, "snapshot_block_timestamp.sql", batchDate, dir, null);
//        execSql(null, "snapshot_dex_tx_volume_count_record.sql", batchDate, dir, null);
//        execSql(null, "snapshot_erc20_tx_record.sql", batchDate, dir, null);
//        execSql(null, "snapshot_eth_holding.sql", batchDate, dir, null);
//        execSql(null, "snapshot_eth_holding_time.sql", batchDate, dir, null);
//        execSql(null, "snapshot_eth_tx_record.sql", batchDate, dir, null);
//        execSql(null, "snapshot_nft_buy_sell_holding.sql", batchDate, dir, null);
//        execSql(null, "snapshot_nft_holding.sql", batchDate, dir, null);
//        execSql(null, "snapshot_nft_holding_time.sql", batchDate, dir, null);
//        execSql(null, "snapshot_platform_nft_holding.sql", batchDate, dir, null);
//        execSql(null, "snapshot_token_holding.sql", batchDate, dir, null);
//        execSql(null, "snapshot_token_holding_time.sql", batchDate, dir, null);
//        execSql(null, "snapshot_token_holding_uni.sql", batchDate, dir, null);
//        execSql(null, "snapshot_web3_transaction_record.sql", batchDate, dir, null);
        execSql(null, "snapshot_dms_syn_block.sql", batchDate, dir, null);
        check("snapshot_table", 60 * 1000, batchDate, 1);
    }

    private void innit(String batchDate) throws Exception {
        String dir = INIT_PATH;
        execSql(null, "dim_rule_sql_content.sql", batchDate, dir, null);
        execSql("dim_rule_sql_content", "dim_project_token_type.sql", batchDate, dir, null);
        execSql("dim_project_token_type", "dim_project_type.sql", batchDate, dir, null);
        execSql("dim_project_type", "dim_rule_content.sql", batchDate, dir, null);
        execSql("dim_rule_content", "white_list_erc20.sql", batchDate, dir, null);
        execSql("white_list_erc20", "platform_nft_volume_usd.sql", batchDate, dir, null);
        execSql("platform_nft_volume_usd", "nft_transfer_holding.sql", batchDate, dir, null);
        execSql("nft_transfer_holding", "nft_volume_count.sql", batchDate, dir, null);
        execSql("nft_volume_count", "platform_nft_type_volume_count.sql", batchDate, dir, null);
        execSql("platform_nft_type_volume_count", "token_holding_uni_cal.sql", batchDate, dir, null);
        execSql("token_holding_uni_cal", "token_balance_volume_usd.sql", batchDate, dir, null);
        execSql("token_balance_volume_usd", "total_balance_volume_usd.sql", batchDate, dir, null);
        execSql("total_balance_volume_usd", "web3_transaction_record_summary.sql", batchDate, dir, null);
        execSql("token_holding_uni_cal", "dex_tx_volume_count_summary.sql", batchDate, dir, null);
        Thread.sleep(3 * 60 * 1000);
        log.info("eth_holding_vol_count Thread start.....");
        boolean token_holding_vol_countcheck = execSql("dex_tx_volume_count_summary", "snapshot_eth_tx_record.sql", batchDate, dir, null);
        log.info("eth_holding_vol_count Thread end .....");
        if (!token_holding_vol_countcheck) {
            Thread.sleep(1 * 60 * 1000);
        }
        log.info("token_holding_vol_count Thread start .....");
        boolean dms_syn_blockcheck = execSql("dex_tx_volume_count_summary", "token_holding_vol_count.sql", batchDate, dir, null);
        log.info("token_holding_vol_count Thread end .....");
        if (!dms_syn_blockcheck) {
            Thread.sleep(1 * 60 * 1000);
        }
        log.info("token_volume_usd Thread start .....");
        execSql("token_holding_vol_count", "dms_syn_block.sql", batchDate, dir, null);
        boolean total_volume_usdcheck = execSql("token_holding_vol_count", "token_volume_usd.sql", batchDate, dir, null);
        log.info("token_volume_usd Thread end .....");
        if (!total_volume_usdcheck) {
            Thread.sleep(5 * 60 * 1000);
        }
        log.info("total_volume_usd Thread start .....");
        execSql("token_volume_usd", "total_volume_usd.sql", batchDate, dir, null);
        log.info("total_volume_usd Thread end .....");
    }

    private boolean execSql(String lastTableName, String sqlName, String batchDate, String dir, String tableSuffix) {
        String tableName = sqlName.split("\\.")[0];
        if (StringUtils.equalsAny(tableName, "token_holding_vol_count", "eth_holding_vol_count")) {
            tableName = tableName.concat("_tmp");
        }
        String finalTableName = tableName;
        forkJoinPool.execute(new Runnable() {
            @Override
            public void run() {
                execSynSql(lastTableName, sqlName, finalTableName, batchDate, dir, tableSuffix);
            }
        });
        return checkResult(finalTableName, batchDate, 1);
    }

    private void execSynSql(String lastTableName, String sqlName, String tableName, String batchDate, String dir, String tableSuffix) {
        check(lastTableName, 20 * 1000, batchDate, 1);
        try {
            if (checkResult(tableName, batchDate, 1)) {
                return;
            }
            String exceSql = FileUtils.readFile(dir.concat(File.separator).concat(sqlName));
            if (StringUtils.isNotEmpty(tableSuffix)){
                exceSql = exceSql.replace("${tableSuffix}",tableSuffix);
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
        try {
            Thread.sleep(40 * 60 * 1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        execSql(null, "address_label_gp.sql", batchDate, INIT_PATH, configEnvironment);
    }

    @Override
    public void staticData(String batchDate) {
        String dir = STATICDATA_PATH;
        execSql("address_labels_json_gin", "static_top_ten_token.sql", batchDate, dir, null);
        execSql("static_top_ten_token", "static_crowd_data.sql", batchDate, dir, null);
        execSql("static_top_ten_token", "static_asset_level_data.sql", batchDate, dir, null);
        execSql("static_top_ten_token", "static_wired_type_address.sql", batchDate, dir, null);
        execSql("static_type_json", "static_total_data.sql", batchDate, dir, null);
        execSql("static_total_data", "static_home_data_analysis.sql", batchDate, dir, null);
    }
}
