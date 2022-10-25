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
    public boolean exceSql(String sqlStr) {
        try{
            this.baseMapper.exceSql(sqlStr);
        }catch (Exception ex){
            log.error("exceSql try.........{}",sqlStr);
            try {
                Thread.sleep(10000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            this.exceSql(sqlStr);
        }
        return true;
    }
}
