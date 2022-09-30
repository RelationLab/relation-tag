package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import lombok.*;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("dim_rule_sql_content")
@ApiModel(value="DimRuleSqlContent对象", description="")
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class DimRuleSqlContent {
    private String ruleName;
    private String ruleSql;
    private Integer ruleOrder;
    private Integer id;
}
