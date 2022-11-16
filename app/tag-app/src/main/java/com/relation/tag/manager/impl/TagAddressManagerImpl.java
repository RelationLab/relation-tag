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
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
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
    protected static ForkJoinPool forkJoinPool = new ForkJoinPool(10);
    protected static ForkJoinPool forkJoinCheckPool = new ForkJoinPool(10);

    static String FILEPATH = "initsql";

    static String SCRIPTSPATH = "tagscripts";

    private void tagByRuleSqlList(List<FileEntity> ruleSqlList, boolean partTag) {
        try {
            forkJoinPool.execute(() -> {
                ruleSqlList.parallelStream().forEach(ruleSql -> {
                    log.info("sqlname={},sql===={}",ruleSql.getFileName(),ruleSql.getFileContent());
//                    iAddressLabelService.exceSql(ruleSql.getFileContent(), ruleSql.getFileName());
                });
            });
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        try {
            Thread.sleep(1 * 60 * 60 * 1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
//        checkAndRepair(ruleSqlList);
//        tagMerge();
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

    class MapKeyComparator implements Comparator<Integer> {
        @Override
        public int compare(Integer o1, Integer o2) {
            return o1 - o2;
        }
    }

    public Map<Integer, List<DimRuleSqlContent>> sortMapByKey(Map<Integer, List<DimRuleSqlContent>> map) {
        if (map == null || map.isEmpty()) {
            return null;
        }
        Map<Integer, List<DimRuleSqlContent>> sortMap = new TreeMap<>(new MapKeyComparator());
        sortMap.putAll(map);
        return sortMap;
    }

    @Override
    public void refreshAllLabel() throws Exception {
//        innit();
        List<FileEntity> fileList = Lists.newArrayList();
        FileUtils.readFileTree(SCRIPTSPATH, fileList);
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
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("token_balance_volume_usd.sql")), "token_balance_volume_usd.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("total_balance_volume_usd.sql")), "total_balance_volume_usd.sql");
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("web3_transaction_record_summary.sql")), "web3_transaction_record_summary.sql");

    }


    @Override
    public void tagMerge() {
        log.info("summaryData start....");
        forkJoinPool.execute(() -> {
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
        });
        forkJoinPool.execute(() -> {
            try {
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
        long summaryDataTime = System.currentTimeMillis();
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
        merge2Gin();
        log.info("rename table end....time===={}", System.currentTimeMillis() - summaryDataTime);
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
