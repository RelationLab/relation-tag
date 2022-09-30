package com.relation.tag.mapper.greenplum;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.relation.tag.entity.DimRuleSqlContent;
import org.springframework.boot.extension.mapper.PostgresPageMapper;

import java.util.List;

public interface GreenplumDimRuleSqlContentMapper extends BaseMapper<DimRuleSqlContent>, PostgresPageMapper<DimRuleSqlContent> {
    List<DimRuleSqlContent> listByTables(List<String> list);
}
