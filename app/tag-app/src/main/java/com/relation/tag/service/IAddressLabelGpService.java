package com.relation.tag.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.relation.tag.entity.*;

import java.util.List;

public interface IAddressLabelGpService extends IService<AddressLabelGp> {
    boolean exceSql(String sqlStr, String name);
    Integer exceSelectSql(String exceSelectSql);


    List<UgcLabelDataAnalysis> selectDataAnalysis(String configEnvironment);

    void updateBatch(List<UgcLabelDataAnalysis> list, String configEnvironment);

    void insertBatch(List<UgcLabelDataAnalysis> entityList, String configEnvironment);

    String selectTagResult(String resultTableName);

    HomeDataAnalysis selectHomeDataAnalysis(String configEnvironment);

    void updateDataAnalysisFail(String id, String configEnvironment);

    String selectBatchId(Long batchId, String configEnvironment);

    List<SuggestAddressBatch> selectSuggestAddressBatch(String configEnvironment);

    void setSuggestAddressBatchStatus(List<SuggestAddressBatch> list);

    List<RecentTime> selectRecentTimeList();

//    Long selectSynCount();
}
