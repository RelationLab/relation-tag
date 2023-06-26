//package com.relation.tag.service.greenplum;
//
//import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
//import com.relation.ugc.common.entity.db.UgcLabelDataAnalysis;
//import com.relation.ugc.common.entity.request.GetUgcDataAnalysisesRequest;
//import com.relation.ugc.mapper.primary.UgcLabelDataAnalysisMapper;
//import com.relation.ugc.service.IUgcLabelDataAnalysisService;
//import org.apache.ibatis.session.SqlSessionFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.extension.entity.response.PageResponse;
//import org.springframework.boot.extension.util.SqlUtil;
//import org.springframework.stereotype.Service;
//
//import java.util.Date;
//import java.util.List;
//
///**
// * <p>
// *  服务实现类
// * </p>
// *
// * @author admin
// * @since 2023-04-03
// */
//@Service
//public class UgcLabelDataAnalysisServiceImpl extends ServiceImpl<UgcLabelDataAnalysisMapper, UgcLabelDataAnalysis> implements IUgcLabelDataAnalysisService {
//
//    @Autowired
//    private SqlSessionFactory sqlSessionFactory;
//
//    @Override
//    public Integer getPendingCountByAddress(String address) {
//        return this.baseMapper.selectPendingCountByAddress(address);
//    }
//
//    @Override
//    public Integer selectPendingCount() {
//        return this.baseMapper.selectPendingCount();
//    }
//
//
//    @Override
//    public PageResponse<UgcLabelDataAnalysis> selectsByAddress(GetUgcDataAnalysisesRequest getUgcDataAnalysisesRequest) {
//        return SqlUtil.execute(sqlSessionFactory, getUgcDataAnalysisesRequest, this.baseMapper);
//    }
//
//    @Override
//    public boolean cancelDataAnalysis(UgcLabelDataAnalysis dataAnalysis) {
//        return this.baseMapper.cancelDataAnalysis(dataAnalysis)==1;
//    }
//
//    @Override
//    public List<UgcLabelDataAnalysis> selectHandleEntity(String status, Date updatedAt) {
//        return this.baseMapper.selectHandleEntity(status, updatedAt);
//    }
//
//    @Override
//    public void updateDoingDataAnalysis(List<UgcLabelDataAnalysis> entityList) {
//        this.baseMapper.updateDoingDataAnalysis(entityList);
//    }
//
//    @Override
//    public void updateResult(UgcLabelDataAnalysis result, String configEnvironment) {
//        this.baseMapper.updateResult(result,configEnvironment);
//    }
//
//    @Override
//    public void updateDownload(Long id, String downloadPath) {
//        this.baseMapper.updateDownload(id, downloadPath);
//    }
//
//    @Override
//    public void resetRecord2TODO(Date updatedAt) {
//        this.baseMapper.resetRecord2TODO(updatedAt);
//    }
//
//    @Override
//    public List<UgcLabelDataAnalysis> selectTimeoutRecord(Integer timeoutHour) {
//        return this.baseMapper.selectTimeoutRecord(timeoutHour);
//    }
//
//}
