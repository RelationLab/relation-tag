package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * <p>
 * 
 * </p>
 *
 * @author admin
 * @since 2023-05-16
 */
@Data
@EqualsAndHashCode(callSuper = false)
@TableName("ugc_label_data_analysis")
@ApiModel(value="UgcLabelDataAnalysis对象", description="")
public class UgcLabelDataAnalysis implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;

    private String name;

    private String address;

    private String apiLevel;

    private String mode;

    private String labels;

    private String status;

    private String analysisResult;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private Boolean removed;

    private LocalDateTime analysisAt;

    private Long analysisAddressNum;

    private String addressImageText;

    private Boolean redo;
    private Boolean restoreVipUsage;

    private String type;

    private String sql;

}
