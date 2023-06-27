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
@TableName("ugc_label_data_analysis_record")
@ApiModel(value="UgcLabelDataAnalysisRecord对象", description="")
public class UgcLabelDataAnalysisRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;

    private Long uldaId;

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

    private String downloadStatus;

    private String downloadPath;


}
