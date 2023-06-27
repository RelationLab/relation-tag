package com.relation.tag.mapper.primary;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.relation.tag.entity.UgcLabelDataAnalysisRecord;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 * Mapper 接口
 * </p>
 *
 * @author admin
 * @since 2023-04-03
 */
public interface UgcLabelDataAnalysisRecordMapper extends BaseMapper<UgcLabelDataAnalysisRecord> {


    int updateDownloadPath(@Param("uldaId") Long uldaId, @Param("downloadPath") String downloadPath);
}
