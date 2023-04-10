package com.relation.tag.mapper.greenplum;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.relation.tag.entity.AddressLabelGp;
import org.springframework.boot.extension.mapper.PostgresPageMapper;

import java.util.List;

public interface GreenplumAddressLabelGpMapper extends BaseMapper<AddressLabelGp>, PostgresPageMapper<AddressLabelGp> {
    void exceSql(String sqlStr);

    List<Integer> exceSelectSql(String exceSelectSql);

}
