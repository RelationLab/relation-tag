package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 * 
 * </p>
 *
 * @author admin
 * @since 2022-08-30
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("label")
@ApiModel(value="Label对象", description="")
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Label implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;

    private String owner;

    private String type;

    private String name;

    private String source;

    private String visibleType;

    private String strategy;

    private String content;

    private String rule;

    private String defaultRule;

    private String ruleType;

    private String ruleGroup;

    private String valueType;

    private String description;

    private Integer runOrder;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private Boolean removed;

    @ApiModelProperty(value = "SUCCESS PENDING")
    private String status;

    private String errorMsg;

    private Long refreshTime;

    @ApiModelProperty(value = "mark type")
    private String markType;

    private String arTxHash;

    private String arStatus;

    private String arErrorMsg;

    private Integer arErrorCount;


}
