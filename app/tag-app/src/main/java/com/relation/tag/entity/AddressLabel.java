package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 * address label table
 * </p>
 *
 * @author admin
 * @since 2022-04-18
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("address_label")
@ApiModel(value="AddressLabel对象", description="address label table")
public class AddressLabel implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "unique id")
    private Long id;

    @ApiModelProperty(value = "upload label address")
    private String owner;

    private String address;

    @ApiModelProperty(value = "label type like：TOTAL_ASSET_ALL_ALL_BALANCE（Total Balance L1）")
    private String labelType;

    @ApiModelProperty(value = "label name， like：TOTAL_ASSET_ALL_ALL_BALANCE_L1")
    private String labelName;

    @ApiModelProperty(value = "label content, like：Total Balance L1")
    private String content;

    @ApiModelProperty(value = "label source like: SYSTEM USER")
    private String source;

    @ApiModelProperty(value = "record create time")
    private LocalDateTime createdAt;

    @ApiModelProperty(value = "record update time")
    private LocalDateTime updatedAt;

    @ApiModelProperty(value = "record delete")
    private Boolean removed;

    private String operateType;


}
