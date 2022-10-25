package com.relation.tag.manager.impl;

import com.relation.tag.entity.DimRuleSqlContent;
import com.relation.tag.manager.TagAddressManager;
import com.relation.tag.service.IAddressLabelGpService;
import com.relation.tag.service.IDimRuleSqlContentService;
import com.relation.tag.util.FileUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.concurrent.ForkJoinPool;
import java.util.stream.Collectors;

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

    static String FILEPATH = "initsql";

    @Override
    public void refreshTagByTable(List<String> tables) {
        List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.listByTables(tables);
        tagByRuleSqlList(ruleSqlList, true);

    }

    private void tagByRuleSqlList(List<DimRuleSqlContent> ruleSqlList, boolean partTag) {
        ruleSqlList = ruleSqlList.stream().filter(item -> {
            return !StringUtils.equals(item.getRuleName(), "summary");
        }).collect(Collectors.toList());
        //根据ruleOrder字段进行分组
        Map<Integer, List<DimRuleSqlContent>> ruleSqlMap = ruleSqlList.stream().collect(
                Collectors.groupingBy(
                        ruleSql -> ruleSql.getRuleOrder()
                ));
        sortMapByKey(ruleSqlMap).forEach((key, value) -> {
            log.info("runOrder==={}  start..... ", key);
            try {
                forkJoinPool.execute(() -> {
                    value.parallelStream().forEach(ruleSql -> {
                        String sql = ruleSql.getRuleSql();
                        long startTime = System.currentTimeMillis();
                        log.info("sqlid={} sqlTable={} start......", ruleSql.getRuleName(), ruleSql.getRuleName());
                        iAddressLabelService.exceSql(sql);
                        log.info("sqlid={} sqlTable={}  end..... time====={}", ruleSql.getRuleName(), ruleSql.getRuleName(), System.currentTimeMillis() - startTime);
                    });
                });
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            log.info("runOrder==={}   end..... ", key);
            long timeSleep = partTag ? 120000 : 1200000;
            try {
                Thread.sleep(timeSleep);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            tagMerge();
        });
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
        innit();
        List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.list();
        tagByRuleSqlList(ruleSqlList, false);
    }

    private void innit() throws Exception {
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_token_type.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_project_type.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_content.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("nft_volume_count.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("platform_nft_type_volume_count.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rank_token.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("dim_rule_sql_content.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("address_labels_json_gin.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("create_address_label_table.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("token_balance_volume_usd.sql")));
        iAddressLabelService.exceSql(FileUtils.readFile(FILEPATH.concat(File.separator).concat("total_balance_volume_usd.sql")));
    }


    @Override
    public void tagMerge() {
        log.info("summaryData start....");
        forkJoinPool.execute(() -> {
            String createTable = "-- auto-generated definition\n" +
                    "create table address_label_gp_temp\n" +
                    "(\n" +
                    "    owner      varchar(256),\n" +
                    "    address    varchar(512),\n" +
                    "    label_type varchar(512),\n" +
                    "    label_name varchar(1024),\n" +
                    "    source     varchar(100),\n" +
                    "    updated_at timestamp(6)\n" +
                    ")\n" +
                    "    distributed by (address);\n" +
                    "\n" +
                    "alter table address_label_gp_temp\n" +
                    "    owner to gpadmin;\n" +
                    "\n";
            iAddressLabelService.exceSql(createTable);
            List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.list();
            ruleSqlList = ruleSqlList.stream().filter(item -> {
                return StringUtils.equals(item.getRuleName(), "summary");
            }).collect(Collectors.toList());
            String sql = ruleSqlList.get(0).getRuleSql();
            iAddressLabelService.exceSql(sql);
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
                    iAddressLabelService.exceSql(renameSql);
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
                "\tjson_object_agg(label_type, label_name order by label_type desc) as labels,\n" +
                "\tCURRENT_TIMESTAMP as updated_at\n" +
                "from\n" +
                "\taddress_label_gp\n" +
                "group by\n" +
                "\taddress";
        iAddressLabelService.exceSql(exceSql);
    }
}
