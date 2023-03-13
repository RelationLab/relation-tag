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
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

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
    protected static ForkJoinPool forkJoinPool = new ForkJoinPool(500);
    static String FILEPATH = "initsql";

    static String SCRIPTSPATH = "tagscripts";

    private void tagByRuleSqlList(List<FileEntity> ruleSqlList) {
        try {
            forkJoinPool.execute(() -> {
                ruleSqlList.parallelStream().forEach(ruleSql -> {
                    execContentSql(ruleSql);
                });
            });
            tagMerge();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void execContentSql(FileEntity ruleSql) {
        try{
            String tableName = ruleSql.getFileName();
            String table = tableName.split("\\.")[0];
            if (checkResult(table)) {
                return;
            }
            iAddressLabelService.exceSql(ruleSql.getFileContent(), ruleSql.getFileName());
        }catch (Exception ex){
            try {
                Thread.sleep(1*60*1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            execContentSql( ruleSql);
        }

    }

    public boolean checkResult(String tableName) {
        if (StringUtils.isEmpty(tableName)) {
            return false;
        }
        try {
            List<Integer> tagList = iAddressLabelService.exceSelectSql("select 1 from ".concat(tableName).concat(" limit 1"));
            log.info("tableName==={},tagList.size===={}", tableName, CollectionUtils.isEmpty(tagList) ? 0 : tagList.size());
            return !CollectionUtils.isEmpty(tagList);
        } catch (Exception ex) {
            return false;
        }
    }

    public void check(String tableName, long sleepTime) {
        if (StringUtils.isEmpty(tableName)) {
            return;
        }
        while (true) {
            try {
                List<Integer> tagList = iAddressLabelService.exceSelectSql("select 1 from ".concat(tableName).concat(" limit 1"));
                if (tagList != null && !CollectionUtils.isEmpty(tagList)) {
                    log.info("check table ===={} end.......tagList.size===={}", tableName, tagList.size());
                    break;
                }
            } catch (Exception ex) {
//                log.error(ex.getMessage(),ex);
            }
            try {
                Thread.sleep(sleepTime);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

    }

    @Override
    public void refreshAllLabel() throws Exception {
        if (!checkResult("address_labels_json_gin")) {
            tag();
        }
    }

    private void tag() throws Exception {
        innit();
        Thread.sleep(2 * 60 * 1000);
        check("total_volume_usd", 1 * 60 * 1000);
        List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.list();
        List<FileEntity> fileList = Lists.newArrayList();
        for (DimRuleSqlContent item : ruleSqlList) {
            String fileName = item.getRuleName().concat(".sql");
            fileList.add(FileEntity.builder().fileName(fileName)
                    .fileContent(FileUtils.readFile(SCRIPTSPATH.concat(File.separator)
                            .concat(fileName))).build());
        }
        tagByRuleSqlList(fileList);
    }

    private void innit() throws Exception {
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("create_tabel.sql")), "create_tabel.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_token_type.sql")), "dim_project_token_type.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_type.sql")), "dim_project_type.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_content.sql")), "dim_rule_content.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_sql_content.sql")), "dim_rule_sql_content.sql");

        execSql("dim_rank_token", "white_list_erc20.sql");
        execSql("dim_rank_token", "platform_nft_volume_usd.sql");
        execSql("platform_nft_volume_usd", "nft_transfer_holding.sql");
        execSql("nft_transfer_holding", "nft_volume_count.sql");
        execSql("nft_volume_count", "platform_nft_type_volume_count.sql");
        execSql("platform_nft_type_volume_count", "token_holding_uni_cal.sql");
        execSql("token_holding_uni_cal", "token_balance_volume_usd.sql");
        execSql("token_balance_volume_usd", "total_balance_volume_usd.sql");
        execSql("total_balance_volume_usd", "web3_transaction_record_summary.sql");
        execSql("token_holding_uni_cal", "dex_tx_volume_count_summary.sql");

        Thread.sleep(1 * 60 * 1000);
        log.info("eth_holding_vol_count Thread start.....");
        boolean token_holding_vol_countcheck = execSql("dex_tx_volume_count_summary", "eth_holding_vol_count.sql");
        log.info("eth_holding_vol_count Thread end .....");
        if (!token_holding_vol_countcheck) {
            Thread.sleep(1 * 60 * 1000);
        }
        log.info("token_holding_vol_count Thread start .....");
        boolean dms_syn_blockcheck = execSql("dex_tx_volume_count_summary", "token_holding_vol_count.sql");
        log.info("token_holding_vol_count Thread end .....");
        if (!dms_syn_blockcheck) {
            Thread.sleep(1 * 60 * 1000);
        }
        log.info("token_volume_usd Thread start .....");
        execSql("token_holding_vol_count", "dms_syn_block.sql");
        boolean total_volume_usdcheck = execSql("token_holding_vol_count", "token_volume_usd.sql");
        log.info("token_volume_usd Thread end .....");
        if (!total_volume_usdcheck) {
            Thread.sleep(5 * 60 * 1000);
        }
        log.info("total_volume_usd Thread start .....");
        execSql("token_volume_usd", "total_volume_usd.sql");
        log.info("total_volume_usd Thread end .....");
    }

    private boolean execSql(String lastTableName, String sqlName) {
        String tableName = sqlName.split("\\.")[0];
        if (StringUtils.equalsAny(tableName, "token_holding_vol_count", "eth_holding_vol_count")) {
            tableName = tableName.concat("_tmp");
        }
        String finalTableName = tableName;
        forkJoinPool.execute(new Runnable() {
            @Override
            public void run() {
                execSynSql(lastTableName, sqlName, finalTableName);
            }
        });
        return checkResult(finalTableName);
    }

    private void execSynSql(String lastTableName, String sqlName, String tableName) {
//        check(lastTableName, 20 * 1000);
        try {
            if (checkResult(tableName)) {
                return;
            }
            iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat(sqlName)), sqlName);
        } catch (Exception e) {
            try {
                Thread.sleep(1 * 60 * 1000);
            } catch (InterruptedException ex) {
                throw new RuntimeException(ex);
            }
            log.info("sqlName==={} try ......", sqlName);
            execSynSql(lastTableName, sqlName, tableName);
        }
    }


    @Override
    public void tagMerge() throws Exception {
        try {
            Thread.sleep(40 * 60 * 1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        execSql(null,"address_label_gp.sql");
    }
}
