package com.relation.tag.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.relation.tag.entity.AddressLabelGp;
import com.relation.tag.vo.AddressLabelVO;

import java.util.List;

public interface IAddressLabelGpService extends IService<AddressLabelGp> {
    boolean exceSql(String sqlStr);
}
