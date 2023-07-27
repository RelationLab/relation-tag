package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import lombok.*;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("recent_time")
@ApiModel(value = "RecentTime对象", description = "")
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RecentTime {
    private String recentTimeCode;
    private String recentTimeName;
    private String recentTimeContent;
    private Long blockHeight;
    private Integer days;
}
