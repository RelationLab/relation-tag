package com.relation.tag.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@TableName("suggest_address_batch")
@ApiModel(value="SuggestAddressBatch对象", description="")
public class SuggestAddressBatch implements Serializable {
    private Long batchId;
    private Long ugcLabelDataAnalysisId;
    private String name;
    private String  status;
    private String  configEnvironment;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
