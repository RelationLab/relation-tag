package com.relation.tag.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.relation.tag.entity.UgcLabelDataAnalysis;

import java.util.Date;
import java.util.List;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author admin
 * @since 2023-04-03
 */
public interface IUgcLabelDataAnalysisService extends IService<UgcLabelDataAnalysis> {
    Integer getPendingCountByAddress(String address);

    Integer selectPendingCount();


    boolean cancelDataAnalysis(UgcLabelDataAnalysis dataAnalysis);

    List<UgcLabelDataAnalysis> selectHandleEntity(String status, Date updatedAt);

    void updateDoingDataAnalysis(List<UgcLabelDataAnalysis> entityList);

    void updateResult(UgcLabelDataAnalysis result, String configEnvironment);


    void resetRecord2TODO(Date updatedAt);

    List<UgcLabelDataAnalysis> selectTimeoutRecord(Integer timeoutHour);

}
