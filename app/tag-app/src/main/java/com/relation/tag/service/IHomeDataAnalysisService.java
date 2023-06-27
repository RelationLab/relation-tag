package com.relation.tag.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.relation.tag.entity.HomeDataAnalysis;

/**
 * <p>
 * 服务类
 * </p>
 *
 * @author admin
 * @since 2023-03-21
 */
public interface IHomeDataAnalysisService extends IService<HomeDataAnalysis> {
    String selectResult();
}
