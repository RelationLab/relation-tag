package com.relation.tag.manager.impl;

import com.relation.tag.entity.DimRuleSqlContent;
import com.relation.tag.manager.TagAddressManager;
import com.relation.tag.service.IAddressLabelGpService;
import com.relation.tag.service.IDimRuleSqlContentService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

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
                        log.info("sqlid={} sqlTable={} start......", ruleSql.getId(), ruleSql.getRuleName());
                        iAddressLabelService.exceSql(sql);
                        log.info("sqlid={} sqlTable={}  end..... time====={}", ruleSql.getId(), ruleSql.getRuleName(), System.currentTimeMillis() - startTime);
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
            summaryData();
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

        List<DimRuleSqlContent> ruleSqlList = dimRuleSqlContentService.list();
        tagByRuleSqlList(ruleSqlList, false);
    }

    public void summaryData() {
        log.info("summaryData start....");
        forkJoinPool.execute(() -> {
            String createTable = "create table address_label_gp_temp as select * from address_label_gp limit 1;";
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
        log.info("rename table start....");
        String renameSql = "drop table if exists address_label_old;" +
                "alter table address_label_gp rename to address_label_old;" +
                "alter table address_label_gp_temp rename to address_label_gp;";
        iAddressLabelService.exceSql(renameSql);
        log.info("rename table end....time===={}", System.currentTimeMillis() - summaryDataTime);

    }
}
