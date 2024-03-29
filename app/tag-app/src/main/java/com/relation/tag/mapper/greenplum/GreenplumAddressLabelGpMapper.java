package com.relation.tag.mapper.greenplum;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.relation.tag.entity.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.boot.extension.mapper.PostgresPageMapper;

import java.util.List;

public interface GreenplumAddressLabelGpMapper extends BaseMapper<AddressLabelGp>, PostgresPageMapper<AddressLabelGp> {
    void exceSql(String sqlStr);

    Integer exceSelectSql(String exceSelectSql);


    void updateBatch(List<UgcLabelDataAnalysis> list, String configEnvironment);

    List<UgcLabelDataAnalysis> selectDataAnalysis(String configEnvironment);

    void insertBatch(List<UgcLabelDataAnalysis> list, String configEnvironment);


    String selectTagResult(@Param("resultTableName") String resultTableName);

    HomeDataAnalysis selectHomeDataAnalysis(@Param("configEnvironment") String configEnvironment);

    void updateDataAnalysisFail(@Param("id") Long id, @Param("configEnvironment") String configEnvironment);

    String selectBatchId(Long ugcLabelDataAnalysisId, String configEnvironment);

    List<SuggestAddressBatch> selectSuggestAddressBatch(String configEnvironment);

    void setSuggestAddressBatchStatus(List<SuggestAddressBatch> list);

    List<RecentTime> selectRecentTimeList();

//    Long selectSynCount();
}
