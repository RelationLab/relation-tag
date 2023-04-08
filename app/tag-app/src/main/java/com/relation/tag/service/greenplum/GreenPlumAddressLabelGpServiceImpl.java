package com.relation.tag.service.greenplum;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.relation.tag.entity.AddressLabelGp;
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
    public List<Integer> exceSelectSql(String exceSelectSql) {
        return baseMapper.exceSelectSql(exceSelectSql);
    }
}
