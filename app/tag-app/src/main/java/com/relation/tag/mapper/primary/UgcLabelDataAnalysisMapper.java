package com.relation.tag.mapper.primary;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.relation.tag.entity.SuggestAddressBatch;
import com.relation.tag.entity.UgcLabelDataAnalysis;
import org.apache.ibatis.annotations.Param;
import org.springframework.boot.extension.mapper.PostgresPageMapper;

import java.util.Date;
import java.util.List;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author admin
 * @since 2023-04-03
 */
public interface UgcLabelDataAnalysisMapper extends BaseMapper<UgcLabelDataAnalysis>, PostgresPageMapper<UgcLabelDataAnalysis> {
    Integer selectPendingCountByAddress(String address);

    Integer selectPendingCount();

    Integer cancelDataAnalysis(@Param("param") UgcLabelDataAnalysis dataAnalysis);

    List<UgcLabelDataAnalysis> selectHandleEntity(@Param("status") String status, Date updatedAt);

    void updateDoingDataAnalysis(List<UgcLabelDataAnalysis> list);

    void updateResult(@Param("param") UgcLabelDataAnalysis result, String configEnvironment);

    void resetRecord2TODO(@Param("updatedAt") Date updatedAt);

    List<UgcLabelDataAnalysis> selectTimeoutRecord(@Param("timeoutHour") Integer timeoutHour);

    void insertBatchData(List<SuggestAddressBatch> list);
}
