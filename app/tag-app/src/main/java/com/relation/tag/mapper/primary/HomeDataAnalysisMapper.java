package com.relation.tag.mapper.primary;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.relation.tag.entity.HomeDataAnalysis;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author admin
 * @since 2023-03-21
 */
public interface HomeDataAnalysisMapper extends BaseMapper<HomeDataAnalysis> {
    String selectResult();
}
