package com.relation.tag.service.greenplum;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.relation.tag.entity.AddressLabelGp;
import com.relation.tag.mapper.greenplum.GreenplumAddressLabelGpMapper;
import com.relation.tag.service.IAddressLabelGpService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service("greenPlumAddressLabelGpServiceImpl")
@Slf4j
public class GreenPlumAddressLabelGpServiceImpl extends ServiceImpl<GreenplumAddressLabelGpMapper, AddressLabelGp> implements IAddressLabelGpService {

    @Override
    public boolean exceSql(String sqlStr, String name) {
        try {
            long startTime = System.currentTimeMillis();
            this.baseMapper.exceSql(sqlStr);
            log.info(" sqlTable={}  end..... time====={}", name, System.currentTimeMillis() - startTime);

        } catch (Exception ex) {
            log.info("err......name={}", name);
            log.error(ex.getMessage(),ex);
        }
        return true;
    }
}
