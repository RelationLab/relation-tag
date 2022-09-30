package com.relation.tag.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.relation.tag.entity.AddressLabelGp;
import com.relation.tag.entity.Label;
import com.relation.tag.vo.AddressLabelVO;

import java.util.List;

public interface IAddressLabelGpService extends IService<AddressLabelGp> {
    List<AddressLabelVO> findLabelsAddress(List<Label> list, Long pageNo, Integer limit);

    Long findLabelsAddressCount(List<Label> labels);

    List<AddressLabelVO> findLabelsByAddress(List<String> addressList);

    boolean exceSql(String sqlStr);
}
