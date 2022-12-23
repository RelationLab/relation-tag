package com.relation.tag.manager.impl;

import com.relation.tag.entity.DimRuleSqlContent;
import com.relation.tag.entity.FileEntity;
import com.relation.tag.manager.TagAddressManager;
import com.relation.tag.service.IAddressLabelGpService;
import com.relation.tag.service.IDimRuleSqlContentService;
import com.relation.tag.util.FileUtils;
import lombok.extern.slf4j.Slf4j;
import org.assertj.core.util.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
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
    protected static ForkJoinPool forkJoinPool = new ForkJoinPool(100);
    protected static ForkJoinPool forkJoinCheckPool = new ForkJoinPool(100);

    static String FILEPATH = "initsql";

    static String SCRIPTSPATH = "tagscripts";

    private void tagByRuleSqlList(List<FileEntity> ruleSqlList, boolean partTag) {
        try {
            forkJoinPool.execute(() -> {
                ruleSqlList.parallelStream().forEach(ruleSql -> {
                    iAddressLabelService.exceSql(ruleSql.getFileContent(), ruleSql.getFileName());
                });
            });
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        try {
            Thread.sleep(1 * 60 * 1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
//        checkAndRepair(ruleSqlList);
        tagMerge();
    }

    private void checkAndRepair(List<FileEntity> fileList) {
        try {
            forkJoinCheckPool.submit(() -> {
                fileList.parallelStream().forEach(ruleSql -> {
                    checkAndRepair(ruleSql.getFileContent(), ruleSql.getFileName());
                });
            }).get();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void checkAndRepair(String ruleSql, String ruleName) {
        ruleName = ruleName.substring(0, ruleName.indexOf("."));
        Long tagCount = iAddressLabelService.exceSelectSql("select count(1)  from (select * from ".concat(ruleName).concat(" limit 1)  t"));
        if (tagCount.intValue() != 1) {
            try {
                Thread.sleep(1 * 60 * 1000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            checkAndRepair(ruleSql, ruleName);
            log.info("{}  exec failed......", ruleName);
        }
    }

    @Override
    public void refreshAllLabel() throws Exception {
        innit();
        List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.list();
        List<FileEntity> fileList = Lists.newArrayList();
        for (DimRuleSqlContent item : ruleSqlList) {
            String fileName = item.getRuleName().concat(".sql");
            fileList.add(FileEntity.builder().fileName(fileName)
                    .fileContent(FileUtils.readFile(SCRIPTSPATH.concat(File.separator)
                            .concat(fileName))).build());
        }
        tagByRuleSqlList(fileList, false);
    }

    private void innit() throws Exception {
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_token_type.sql")), "dim_project_token_type.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_type.sql")), "dim_project_type.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_content.sql")), "dim_rule_content.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("platform_nft_volume_usd.sql")), "platform_nft_volume_usd.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("nft_transfer_holding.sql")), "nft_transfer_holding.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("nft_volume_count.sql")), "nft_volume_count.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("platform_nft_type_volume_count.sql")), "platform_nft_type_volume_count.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rank_token.sql")), "dim_rank_token.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_sql_content.sql")), "dim_rule_sql_content.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("address_labels_json_gin.sql")), "address_labels_json_gin.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("create_address_label_table.sql")), "create_address_label_table.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dex_tx_volume_count_summary.sql")), "dex_tx_volume_count_summary.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dex_tx_volume_count_summary_univ3.sql")), "dex_tx_volume_count_summary_univ3.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("token_balance_volume_usd.sql")), "token_balance_volume_usd.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("total_balance_volume_usd.sql")), "total_balance_volume_usd.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("web3_transaction_record_summary.sql")), "web3_transaction_record_summary.sql");
    }


    @Override
    public void tagMerge() {
        log.info("createTable start....");
        String createTable = "DROP TABLE if EXISTS  address_label_gp_temp;create table address_label_gp_temp\n" +
                "(\n" +
                "    owner      varchar(256),\n" +
                "    address    varchar(512),\n" +
                "    label_type varchar(512),\n" +
                "    label_name varchar(1024),\n" +
                "    source     varchar(100),\n" +
                "    updated_at timestamp(6)\n" +
                ") distributed by (address);";
        iAddressLabelService.exceSql(createTable, "createTable");
        forkJoinPool.execute(() -> {
            try {
                log.info("summary start....");
                iAddressLabelService.exceSql(FileUtils.readFile(SCRIPTSPATH.concat(File.separator).concat("summary.sql")), "summary.sql");
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        try {
            Thread.sleep(60000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        forkJoinPool.execute(() -> {
                    log.info("rename table start....");
                    String renameSql = "drop table if exists address_label_old;" +
                            "alter table address_label_gp rename to address_label_old;" +
                            "alter table address_label_gp_temp rename to address_label_gp;";
                    iAddressLabelService.exceSql(renameSql, "renameSql");
                }
        );
        try {
            Thread.sleep(60000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        forkJoinPool.execute(() -> {
                    log.info("merge2Gin  start....");
                    merge2Gin();
                }
        );
    }

    @Override
    public void merge2Gin() {
        String exceSql = "truncate\n" +
                "    table public.address_labels_json_gin;insert\n" +
                "\tinto\n" +
                "\taddress_labels_json_gin(address,\n" +
                "\tlabels,\n" +
                "\tupdated_at)\n" +
                "   select\n" +
                "\taddress,\n" +
                "\tjson_object_agg(label_type, label_name order by label_type desc)::jsonb as labels,\n" +
                "\tCURRENT_TIMESTAMP as updated_at\n" +
                "from\n" +
                "\taddress_label_gp\n" +
                "group by\n" +
                "\taddress";
        iAddressLabelService.exceSql(exceSql, "merge2Gin");
    }
}
