package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * <p>
 *
 * </p>
 *
 * @author admin
 * @since 2023-03-22
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("home_data_analysis")
@ApiModel(value = "HomeDataAnalysis对象", description = "")
public class HomeDataAnalysis implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long analysisDate;

    private String analysisResult;


}
