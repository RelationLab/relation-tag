package com.relation.tag.vo;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * <p>
 * address label table
 * </p>
 *
 * @author admin
 * @since 2022-04-18
 */
@Data
public class AddressLabelVO implements Serializable {
    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "unique id")
    private Long id;

    private String address;

    @ApiModelProperty(value = "label name， like：TOTAL_ASSET_ALL_ALL_BALANCE_L1")
    private String labels;

    @ApiModelProperty(value = "label content, like：Total Balance L1")
    private String contents;

}
