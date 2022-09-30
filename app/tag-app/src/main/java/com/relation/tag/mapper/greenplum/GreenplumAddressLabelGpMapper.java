package com.relation.tag.mapper.greenplum;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.relation.tag.entity.AddressLabelGp;
import com.relation.tag.entity.Label;
import com.relation.tag.vo.AddressLabelVO;
import org.springframework.boot.extension.mapper.PostgresPageMapper;

import java.util.List;

public interface GreenplumAddressLabelGpMapper extends BaseMapper<AddressLabelGp>, PostgresPageMapper<AddressLabelGp> {

    List<AddressLabelVO> findLabelsAddress(List<Label> list, Integer limit, Long offSet);

    Long findLabelsAddressCount(List<Label> list);

    List<AddressLabelVO> findLabelsByAddress(List<String> addressList);

    void exceSql(String sqlStr);
}
