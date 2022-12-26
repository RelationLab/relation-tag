package com.relation.tag.manager.impl;

import com.alibaba.druid.pool.DruidDataSource;
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
import org.springframework.util.CollectionUtils;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
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
    static String FILEPATH = "initsql";

    static String SCRIPTSPATH = "tagscripts";

    @Autowired
    @Qualifier("greenplumDataSource")
    DataSource dataSource;
    @PostConstruct
    private void initConstruct() throws Exception {
        log.info("initConstruct start.......");
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    refreshAllLabel();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();
        log.info("initConstruct end.......");
    }

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
        tagMerge();
    }

    private void check(String tableName, long sleepTime) {
        if (StringUtils.isEmpty(tableName)) {
            return;
        }
        List<Integer> tagList = null;
        try {
            tagList = iAddressLabelService.exceSelectSql("select 1 from ".concat(tableName).concat(" limit 1"));
            if (!CollectionUtils.isEmpty(tagList)) {
                return;
            }
        } catch (Exception ex) {
            tryAgain(tableName, sleepTime);
        }
        tryAgain(tableName, sleepTime);
    }

    private void tryAgain(String tableName, long sleepTime) {
        try {
            Thread.sleep(sleepTime);
            check(tableName, sleepTime);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
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
        check("web3_transaction_record_summary", 60 * 1000);
        tagByRuleSqlList(fileList, false);
    }

    private void innit() throws Exception {
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("create_tabel.sql")), "create_tabel.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_token_type.sql")), "dim_project_token_type.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_type.sql")), "dim_project_type.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_content.sql")), "dim_rule_content.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_sql_content.sql")), "dim_rule_sql_content.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rank_token.sql")), "dim_rank_token.sql");


        execSql("dim_rank_token", "platform_nft_volume_usd.sql");
        execSql("platform_nft_volume_usd", "nft_transfer_holding.sql");
        execSql("nft_transfer_holding", "nft_volume_count.sql");
        execSql("nft_volume_count", "platform_nft_type_volume_count.sql");
        execSql("platform_nft_type_volume_count", "dex_tx_volume_count_summary.sql");
        execSql("dex_tx_volume_count_summary", "dex_tx_volume_count_summary_univ3.sql");
        execSql("dex_tx_volume_count_summary", "token_balance_volume_usd.sql");
        execSql("token_balance_volume_usd", "total_balance_volume_usd.sql");
        execSql("total_balance_volume_usd", "web3_transaction_record_summary.sql");
    }

    private void execSql(String lastTableName, String sqlName) {
        forkJoinPool.execute(new Runnable() {
            @Override
            public void run() {
                check(lastTableName, 20 * 1000);
                try {
                    iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat(sqlName)), sqlName);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        });

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
            Thread.sleep(5 * 1000);
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
            Thread.sleep(50 * 60 * 1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        forkJoinPool.execute(() -> {
                    log.info("merge2Gin  start....");
                    check("address_label_gp", 1 * 60 * 1000);
                    merge2Gin();
                }
        );
        try {
            Thread.sleep(10 * 60 * 1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        check("address_labels_json_gin", 1 * 60 * 1000);
        log.info("tag end...........");
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
