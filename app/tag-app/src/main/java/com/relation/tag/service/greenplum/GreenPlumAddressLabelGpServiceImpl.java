package com.relation.tag.service.greenplum;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.relation.tag.entity.AddressLabelGp;
import com.relation.tag.entity.HomeDataAnalysis;
import com.relation.tag.entity.SuggestAddressBatch;
import com.relation.tag.entity.UgcLabelDataAnalysis;
import com.relation.tag.mapper.greenplum.GreenplumAddressLabelGpMapper;
import com.relation.tag.service.IAddressLabelGpService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("greenPlumAddressLabelGpServiceImpl")
@Slf4j
public class GreenPlumAddressLabelGpServiceImpl extends ServiceImpl<GreenplumAddressLabelGpMapper, AddressLabelGp> implements IAddressLabelGpService {

    @Override
    public boolean exceSql(String sqlStr, String name) {
        try {
            log.info(" sqlTable={}  start..... ", name);
            long startTime = System.currentTimeMillis();
            baseMapper.exceSql(sqlStr);
            log.info(" sqlTable={}  end..... time====={}", name, System.currentTimeMillis() - startTime);
        } catch (Exception ex) {
            log.info("err......name={}", name);
            throw ex;
        }
        return true;
    }

    @Override
    public Integer exceSelectSql(String exceSelectSql) {
        return baseMapper.exceSelectSql(exceSelectSql);
    }


    @Override
    public List<UgcLabelDataAnalysis> selectDataAnalysis(String configEnvironment) {
        return baseMapper.selectDataAnalysis(configEnvironment);
    }

    @Override
    public void updateBatch(List<UgcLabelDataAnalysis> list, String configEnvironment) {
        baseMapper.updateBatch(list,configEnvironment);
    }

    @Override
    public void insertBatch(List<UgcLabelDataAnalysis> entityList, String configEnvironment) {
        baseMapper.insertBatch(entityList,configEnvironment);
    }


    @Override
    public String selectTagResult(String resultTableName) {
        return baseMapper.selectTagResult(resultTableName);
    }

    @Override
    public HomeDataAnalysis selectHomeDataAnalysis(String configEnvironment) {
        return baseMapper.selectHomeDataAnalysis(configEnvironment);
    }

    @Override
    public void updateDataAnalysisFail(String id, String configEnvironment) {
        baseMapper.updateDataAnalysisFail(Long.parseLong(id),configEnvironment);
    }

    @Override
    public String selectBatchId(Long ugcLabelDataAnalysisId, String configEnvironment) {
        return baseMapper.selectBatchId(ugcLabelDataAnalysisId,configEnvironment);
    }

    @Override
    public List<SuggestAddressBatch> selectSuggestAddressBatch(String configEnvironment) {
        return baseMapper.selectSuggestAddressBatch(configEnvironment);
    }

    @Override
    public void setSuggestAddressBatchStatus(List<SuggestAddressBatch> list) {
        baseMapper.setSuggestAddressBatchStatus(list);
    }


}
