package com.relation.tag.manager.impl;

import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.google.common.collect.Maps;
import com.relation.tag.entity.HomeDataAnalysis;
import com.relation.tag.entity.SuggestAddressBatch;
import com.relation.tag.entity.UgcLabelDataAnalysis;
import com.relation.tag.entity.UgcLabelDataAnalysisRecord;
import com.relation.tag.enums.DataAnalysisStatusEnum;
import com.relation.tag.enums.DataAnalysisTypeEnum;
import com.relation.tag.manager.StaticManager;
import com.relation.tag.service.IAddressLabelGpService;
import com.relation.tag.service.IHomeDataAnalysisService;
import com.relation.tag.service.IUgcLabelDataAnalysisRecordService;
import com.relation.tag.service.IUgcLabelDataAnalysisService;
import com.relation.tag.util.FileUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.assertj.core.util.Lists;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ForkJoinPool;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Slf4j
public class StaticManagerImpl implements StaticManager {
    @Autowired
    @Qualifier("greenPlumAddressLabelGpServiceImpl")
    protected IAddressLabelGpService iAddressLabelService;

    @Autowired
    @Qualifier("ugcLabelDataAnalysisServiceImpl")
    protected IUgcLabelDataAnalysisService ugcLabelDataAnalysisService;

    @Autowired
    @Qualifier("ugcLabelDataAnalysisRecordServiceImpl")
    private IUgcLabelDataAnalysisRecordService ugcLabelDataAnalysisRecordService;

    @Autowired
    @Qualifier("homeDataAnalysisServiceImpl")
    private IHomeDataAnalysisService homeDataAnalysisService;
    @Autowired
    private ApplicationContext applicationContext;

    protected static ForkJoinPool forkJoinPool = new ForkJoinPool(50);
    static String STATIC_SCRIPTS_PATH = "static_scripts";

    public static String STATICDATA_PATH = "static_home";

    @Value("${config.environment:stag}")
    protected String configEnvironment;

    @Override
    public boolean checkResult(String tableName, Integer result, String tableSuffix, String batchDate) {
        if (StringUtils.isEmpty(tableName)) {
            return false;
        }
        try {
            Integer tagInteger = checkResultData(tableName, tableSuffix, batchDate);
            log.info("tableName==={},tagList.size===={}", tableName, tagInteger);
            return tagInteger != null && tagInteger.intValue() >= result;
        } catch (Exception ex) {
            return false;
        }
    }

    @Override
    public void check(String tableName, long sleepTime, Integer resultNum, String tableSuffix, String batchDate) {
        if (StringUtils.isEmpty(tableName)) {
            return;
        }
        while (true) {
            try {
                Integer tagInteger = checkResultData(tableName, tableSuffix, batchDate);
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




    private boolean execSql(String lastTableName, String sqlName, Map<String, String> paramsMap, Integer result, String batchDate, String dir, int tryCount) {
        String tableName = sqlName.split("\\.")[0];
        tableName = tableName.concat(buildTableSuffix(paramsMap.get("id"), configEnvironment));
        String finalTableName = tableName;
        String tableSuffix = paramsMap.get("tableSuffix");
        forkJoinPool.execute(new Runnable() {
            @Override
            public void run() {
                execSynSql(lastTableName, sqlName, finalTableName, paramsMap, result, dir, tableSuffix, batchDate, tryCount);
            }
        });
        return checkResult(finalTableName, result, tableSuffix, batchDate);
    }

    private void execSynSql(String lastTableName, String sqlName, String tableName, Map<String, String> paramsMap, Integer result, String dir, String tableSuffix, String batchDate, int tryCount) {
        check(lastTableName, 20 * 1000, result, tableSuffix, batchDate);
        tryCount++;
        try {
            if (checkResult(tableName, result, tableSuffix, batchDate)) {
                return;
            }
            String exceSql = FileUtils.readFileByStringInput(dir.concat(File.separator).concat(sqlName));
            exceSql = replaceSql(exceSql, paramsMap, batchDate);
            iAddressLabelService.exceSql(exceSql, sqlName);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
            try {
                Thread.sleep(1 * 60 * 1000);
            } catch (InterruptedException ex) {
                throw new RuntimeException(ex);
            }
            log.info("sqlName==={} try ......tryCount={}", sqlName, tryCount);

            if (tryCount == 5) {
                saveFailRecord(paramsMap);
                return;
            }
            execSynSql(lastTableName, sqlName, tableName, paramsMap, result, dir, tableSuffix, batchDate, tryCount);
        }
    }

    private void saveFailRecord(Map<String, String> paramsMap) {
        String id = paramsMap.get("id");
        String configEnvironment = paramsMap.get("configEnvironment");
        if (StringUtils.isBlank(id)) {
            return;
        }
        iAddressLabelService.updateDataAnalysisFail(id, configEnvironment);
        String tableSuffix = paramsMap.get("tableSuffix");
        String tableName = "tag_result".concat(tableSuffix);
        String table_name = "static_ugc_label_data_analysis".concat(tableSuffix);
        String resultSql = "INSERT INTO ".concat(tableName).concat("(table_name,batch_date) select ('")
                .concat(table_name).concat("') as table_name,to_char(current_date ,'YYYY-MM-DD')  as batch_date");
        iAddressLabelService.exceSql(resultSql, "resultSql");
    }

    private String replaceSql(String exceSql, Map<String, String> paramsMap, String batchDate) {
        if (paramsMap == null || paramsMap.isEmpty()) {
            return exceSql;
        }
        if (StringUtils.isNotEmpty(batchDate)) {
            exceSql = exceSql.replace("${tagBatch}", batchDate);
        }
        if (!StringUtils.isBlank(paramsMap.get("tableSuffix"))) {
            exceSql = exceSql.replace("${tableSuffix}", paramsMap.get("tableSuffix"));
        }
        if (!StringUtils.isBlank(paramsMap.get("id"))) {
            exceSql = exceSql.replace("${id}", paramsMap.get("id"));
        }
        if (!StringUtils.isBlank(paramsMap.get("conditionData"))) {
            exceSql = exceSql.replace("${conditionData}", paramsMap.get("conditionData"));
        }
        if (!StringUtils.isBlank(paramsMap.get("configEnvironment"))) {
            exceSql = exceSql.replace("${configEnvironment}", paramsMap.get("configEnvironment"));
        }
        return exceSql;
    }

    @Override
    public void synLabelDataAnalysis() {
        log.info("synData start........");
        List<UgcLabelDataAnalysis> list = iAddressLabelService.selectDataAnalysis(configEnvironment);
        if (CollectionUtils.isEmpty(list)) {
            log.info("UgcLabelDataAnalysis list isEmpty....");
            return;
        }
        log.info("UgcLabelDataAnalysis list===={}", CollectionUtils.isEmpty(list) ? 0 : list.size());
        // 查询出pg里的数据，因为name有可能被更新了
        List<UgcLabelDataAnalysis> pgDataList = ugcLabelDataAnalysisService.list(Wrappers.lambdaQuery(UgcLabelDataAnalysis.class)
                .in(UgcLabelDataAnalysis::getId, list.stream().map(obj -> obj.getId()).collect(Collectors.toList())));
        if (CollectionUtils.isEmpty(pgDataList)) {
            log.info("UgcLabelDataAnalysis pgDataList isEmpty....");
            return;
        }
        Map<Long, UgcLabelDataAnalysis> pgDataMap = pgDataList.stream().collect(Collectors.toMap(UgcLabelDataAnalysis::getId, Function.identity(), (key1, key2) -> key2));

        List<UgcLabelDataAnalysisRecord> listResultRecord = Lists.newArrayList();
        for (UgcLabelDataAnalysis result : list) {
            UgcLabelDataAnalysis pgData = pgDataMap.get(result.getId());
            result.setName(pgData.getName());
            result.setRemoved(pgData.getRemoved());
            result.setUpdatedAt(pgData.getUpdatedAt());
            UgcLabelDataAnalysisRecord target = new UgcLabelDataAnalysisRecord();
            BeanUtils.copyProperties(result, target);
            target.setId(null);
            target.setUldaId(result.getId());
            if (!StringUtils.equals(result.getStatus(), DataAnalysisStatusEnum.FAIL.name())) {
                result.setRedo(false);
                listResultRecord.add(target);
            }
            String tableSuffix = buildTableSuffix(result.getId().toString(), configEnvironment);
            Map paramsMap = Maps.newHashMap();
            paramsMap.put("tableSuffix", tableSuffix);
            dropTable(paramsMap);
        }
        this.applicationContext.getBean(this.getClass()).updateAnalysisData(list, listResultRecord);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateAnalysisData(List<UgcLabelDataAnalysis> list, List<UgcLabelDataAnalysisRecord> listResultRecord) {
        ugcLabelDataAnalysisService.saveOrUpdateBatch(list);
        ugcLabelDataAnalysisRecordService.saveBatch(listResultRecord);
        iAddressLabelService.updateBatch(list, configEnvironment);
    }

    private void dropTable(Map paramsMap) {
        String sqlName = "static_drop.sql";
        String exceSql = null;
        try {
            exceSql = FileUtils.readFileByStringInput(STATIC_SCRIPTS_PATH.concat(File.separator).concat(sqlName));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        exceSql = replaceSql(exceSql, paramsMap, null);
        iAddressLabelService.exceSql(exceSql, sqlName);
    }

    @Override
    public void synHomePageData() {
        log.info("synHomePageData start........");
        String tableSuffix = buildTableSuffix(null, configEnvironment);
        /***********获取打标签的批次号**********/
        String tagBatch = iAddressLabelService.selectTagResult("address_labels_json_gin".concat(tableSuffix));
        /***********检查该批次号是否计算完首页数据，未计算完退出**********/
        if (!checkResult("static_home_data_analysis".concat(tableSuffix), 1, null, tagBatch)) {
            return;
        }
        /***********检查该批次号首页数据是否同步完，同步完退出**********/
        String synTableName = "HomeDataAnalysisSyn".concat(tableSuffix);
        if (checkResult(synTableName, 1, null, tagBatch)) {
            return;
        }
        synHomeDataAnalysis(synTableName,tagBatch);
    }

//    @Override
//    @Transactional(rollbackFor = Exception.class)
//    public void scanSuggestAddress() {
//        List<SuggestAddressBatch> list = iAddressLabelService.selectSuggestAddressBatch(configEnvironment);
//        if (CollectionUtils.isEmpty(list)){
//            return;
//        }
//        ugcLabelDataAnalysisService.insertBatchData(list);
//        log.warn("scanSuggestAddress.list======{}",list);
//        iAddressLabelService.setSuggestAddressBatchStatus(list);
//    }

    private void synHomeDataAnalysis(String synTableName, String tagBatch) {
        HomeDataAnalysis entity = iAddressLabelService.selectHomeDataAnalysis(configEnvironment);
        if (Objects.isNull(entity)) {
            log.info("HomeDataAnalysis entity isEmpty....");
            return;
        }
        homeDataAnalysisService.save(entity);
        iAddressLabelService.exceSql("insert into tag_result(table_name,batch_date) " +
                " SELECT '".concat(synTableName)
                        .concat("' as table_name,'")
                        .concat(tagBatch).concat("' as batch_date;"), "HomeDataAnalysis syn finished");
    }

    /***
     * 修复因为升级停机引起的未执行完的任务
     */
//    @PostConstruct
    public void repairStaticLabelDataAnalysis() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(20 * 1000);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
                log.info("repairStaticLabelDataAnalysis start........");
                ugcLabelDataAnalysisService.resetRecord2TODO(new Date());
            }
        }).start();
    }

    @Override
    public void staticLabelDataAnalysis() {
        log.info("staticLabelDataAnalysis start........");
        /****
         * 如果正在打标签，直接先退出
         */
        if (checkResult("tagging", 1, null, null)) {
            return;
        }
        /***
         * 查出统计的数据
         */
        List<UgcLabelDataAnalysis> entityList = ugcLabelDataAnalysisService.selectHandleEntity(DataAnalysisStatusEnum.TODO.name(), null);
        staticLabelDataAnalysis(entityList);

    }

    private void staticLabelDataAnalysis(List<UgcLabelDataAnalysis> entityList) {
        if (CollectionUtils.isEmpty(entityList)) {
            return;
        }
        iAddressLabelService.insertBatch(entityList, configEnvironment);
        ugcLabelDataAnalysisService.updateDoingDataAnalysis(entityList);
        forkJoinPool.execute(() -> {
            entityList.parallelStream().forEach(entity -> {
                try {
                    staticData(entity, configEnvironment);
                } catch (Exception e) {
                    entity.setRestoreVipUsage(true);
                    entity.setStatus(DataAnalysisStatusEnum.FAIL.name());
                    ugcLabelDataAnalysisService.updateResult(entity, configEnvironment);
                    log.error("staticLabelDataAnalysis failed, param: {}", JSON.toJSONString(entity), e);
                }
            });
        });
    }

    @Override
    public void staticData(UgcLabelDataAnalysis entity, String configEnvironment) {
        String tableSuffix = buildTableSuffix(entity.getId().toString(), configEnvironment);
        Map<String, String> paramsMap = buildParamsMap(entity, tableSuffix, configEnvironment);
        String dir = STATIC_SCRIPTS_PATH;
        dropTable(paramsMap);
        execSql(null, "address_init.sql", paramsMap, 1, null, dir, 0);
        execSql("address_init".concat(tableSuffix), "static_top_ten_token.sql", paramsMap, 1, null, dir, 0);
        execSql("address_init".concat(tableSuffix), "static_crowd_data.sql", paramsMap, 1, null, dir, 0);
        execSql("address_init".concat(tableSuffix), "static_wired_type_address.sql", paramsMap, 1, null, dir, 0);
        execSql("static_top_ten_token".concat(tableSuffix), "static_top_ten_platform.sql", paramsMap, 1, null, dir, 0);
        execSql("static_top_ten_platform".concat(tableSuffix), "static_top_ten_action.sql", paramsMap, 1, null, dir, 0);
        execSql("static_top_ten_action".concat(tableSuffix), "static_asset_level_data.sql", paramsMap, 1, null, dir, 0);
        execSql("static_asset_level_data".concat(tableSuffix), "static_total_data.sql", paramsMap, 1, null, dir, 0);
        execSql("static_total_data".concat(tableSuffix), "static_ugc_label_data_analysis.sql", paramsMap, 1, null, dir, 0);
    }

    @Override
    public void staticHomePageData() {
        log.info("staticHomePageData start........");
        String tableSuffix = buildTableSuffix(null, configEnvironment);
        String tagBatch = iAddressLabelService.selectTagResult("address_labels_json_gin".concat(tableSuffix));
        if (StringUtils.isBlank(tagBatch)){
            return;
        }
        String syningTableName = "HomeDataAnalysisSyning".concat(tableSuffix);
        boolean syningFlag = checkResult(syningTableName, 1, null, tagBatch);
        if (syningFlag) {
            return;
        }
        boolean staticFlag = checkResult("static_home_data_analysis".concat(tableSuffix), 1, null, tagBatch);
        if (staticFlag) {
            return;
        }
        iAddressLabelService.exceSql("insert into tag_result(table_name,batch_date) " +
                " SELECT '".concat(syningTableName)
                        .concat("' as table_name,'")
                        .concat(tagBatch).concat("' as batch_date;"), "HomeDataAnalysis syn doing");
        Map<String, String> paramsMap = buildParamsMap(null, tableSuffix, configEnvironment);
        String dir = STATICDATA_PATH;
        execSql(null, "address_init.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("address_init".concat(tableSuffix), "static_crowd_data.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("address_init".concat(tableSuffix), "static_wired_type_address.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("address_init".concat(tableSuffix), "static_top_ten_token.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("static_top_ten_token".concat(tableSuffix), "static_top_ten_platform.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("static_top_ten_platform".concat(tableSuffix), "static_top_ten_action.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("static_top_ten_action".concat(tableSuffix), "static_asset_level_data.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("static_asset_level_data".concat(tableSuffix), "static_total_data.sql", paramsMap, 1, tagBatch, dir, 0);
        execSql("static_total_data".concat(tableSuffix), "static_home_data_analysis.sql", paramsMap, 1, tagBatch, dir, 0);
    }

    private String  buildTableSuffix(String id, String configEnvironment) {
        return ("_").concat(configEnvironment.concat((id == null ? "" : ("_").concat(id))));
    }

    private Map<String, String> buildParamsMap(UgcLabelDataAnalysis entity, String tableSuffix, String configEnvironment) {
        Map<String, String> map = Maps.newHashMap();
        map.put("configEnvironment", configEnvironment);
        map.put("tableSuffix", tableSuffix);
        log.info("entity====={}",entity);
        if (entity == null) {
            return map;
        }
        String conditionData = buildConditionData(entity);
        map.put("conditionData", conditionData);
        map.put("id", entity.getId().toString());
        return map;
    }

    private String buildConditionData(UgcLabelDataAnalysis entity) {
        if (StringUtils.isNotBlank(entity.getType())&&StringUtils.equals(entity.getType(), DataAnalysisTypeEnum.SQL.name())){
            return entity.getSql();
        }
        if (StringUtils.isNotBlank(entity.getType())&&StringUtils.equals(entity.getType(), DataAnalysisTypeEnum.RECOMMEND.name())){
           return buildConditionDataBySuggest( entity);
        }
        String labels = entity.getLabels();
        return StringUtils.isBlank(labels) ? "" : buildConditionDataByLabel(labels, entity);
    }

    private String buildConditionDataBySuggest(UgcLabelDataAnalysis entity) {
//        String batchId = iAddressLabelService.selectBatchId(entity.getId(),configEnvironment);
        return  "select distinct address as address from recommend_address where batch_id=".concat(entity.getId().toString());
    }

    private String buildConditionDataByLabel(String labels, UgcLabelDataAnalysis entity) {
        String tatolStartSql = "select distinct address as address from (";
        String outSql = "select address from (";
        String selectStartSql = " select address from address_label_gp_" + configEnvironment +
                " where label_name ='";
        String selectEndSql = "' ";
        String fuzzyKey = " UNION ";
        String precisionKey = " INTERSECT ";
        String orAndRelation = StringUtils.equals("FUZZY", entity.getMode()) ? fuzzyKey : precisionKey;
        String[] labelNames = labels.split(",");
        StringBuffer stringBuffer = new StringBuffer();
        int size = labelNames.length;
        for (int i = 0; i < size; i++) {
            String itemLabelName = labelNames[i];
            stringBuffer.append(selectStartSql).append(itemLabelName).append(selectEndSql);
            if (i != size - 1) {
                stringBuffer.append(orAndRelation);
            }
        }
        String addressLabelGpStr = outSql.concat(stringBuffer.toString()).concat(") total_in ");
        String addressLabelUgcStr = addressLabelGpStr.replace("address_label_gp", "address_label_ugc");
        String tatolEndSql = ") total_out";
        String execSql = tatolStartSql.concat(addressLabelGpStr).concat(fuzzyKey)
                .concat(addressLabelUgcStr).concat(tatolEndSql);
        return execSql;
    }

    private Integer checkResultData(String tableName, String tableSuffix, String batchDate) {
        String execSql = "select count(1) from ".concat("tag_result")
                .concat(StringUtils.isBlank(tableSuffix) ? "" : tableSuffix)
                .concat(" where table_name='").concat(tableName)
                .concat("' ").concat(StringUtils.isBlank(batchDate) ? "" : ("and batch_date='".concat(batchDate).concat("' ")));
        return iAddressLabelService.exceSelectSql(execSql);
    }


}
