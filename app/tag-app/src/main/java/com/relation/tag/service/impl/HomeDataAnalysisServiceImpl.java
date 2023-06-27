package com.relation.tag.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.relation.tag.entity.HomeDataAnalysis;
import com.relation.tag.mapper.primary.HomeDataAnalysisMapper;
import com.relation.tag.service.IHomeDataAnalysisService;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author admin
 * @since 2023-03-21
 */
@Service
public class HomeDataAnalysisServiceImpl extends ServiceImpl<HomeDataAnalysisMapper, HomeDataAnalysis> implements IHomeDataAnalysisService {

    @Override
//    @DataCache(key = "IHomeDataAnalysisService.selectResult", expire = "1", timeUnit = TimeUnit.DAYS)
    public String selectResult() {
        return this.baseMapper.selectResult();
    }
}
