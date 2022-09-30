package com.relation.tag.service.greenplum;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.relation.tag.entity.DimRuleSqlContent;
import com.relation.tag.mapper.greenplum.GreenplumDimRuleSqlContentMapper;
import com.relation.tag.service.IDimRuleSqlContentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("greenplumDimRuleSqlContentServiceImpl")
@Slf4j
public class GreenplumDimRuleSqlContentServiceImpl extends ServiceImpl<GreenplumDimRuleSqlContentMapper, DimRuleSqlContent> implements IDimRuleSqlContentService {

    @Override
    public List<DimRuleSqlContent> listByTables(List<String> tables) {
        return baseMapper.listByTables(tables);
    }
}
