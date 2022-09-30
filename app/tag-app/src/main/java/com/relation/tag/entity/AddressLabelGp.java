package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("address_label_gp")
@ApiModel(value = "AddressLabelGp对象", description = "address label gp table")
public class AddressLabelGp implements Serializable {
    private static final long serialVersionUID = 1L;
    private String address;

    @ApiModelProperty(value = "label type like：TOTAL_ASSET_ALL_ALL_BALANCE（Total Balance L1）")
    private String labelType;

    @ApiModelProperty(value = "label name， like：TOTAL_ASSET_ALL_ALL_BALANCE_L1")
    private String labelName;

    @ApiModelProperty(value = "label source like: SYSTEM USER")
    private String source;

    @ApiModelProperty(value = "record create time")
    private LocalDateTime createdAt;

    @ApiModelProperty(value = "record update time")
    private LocalDateTime updatedAt;

    @ApiModelProperty(value = "record delete")
    private Boolean removed;
}
