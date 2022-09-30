package com.relation.tag.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.relation.tag.entity.DimRuleSqlContent;

import java.util.List;

public interface IDimRuleSqlContentService extends IService<DimRuleSqlContent> {
    List<DimRuleSqlContent> listByTables(List<String> tables);
}
