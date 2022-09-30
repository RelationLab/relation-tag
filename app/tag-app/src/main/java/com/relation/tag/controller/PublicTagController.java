package com.relation.tag.controller;

import com.relation.tag.manager.TagAddressManager;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.extension.annotation.MethodDesc;
import org.springframework.boot.extension.entity.response.ResponseWrapper;
import org.springframework.util.CollectionUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/${server.base-url}/public/v1")
@Validated
@Api("label相关API")
public class PublicTagController {

    @Autowired
    private TagAddressManager tagAddressManager;

    @PostMapping("tag/lable-type")
    @ApiOperation("按标签类型打标签")
    @MethodDesc("按标签类型打标签")
    public ResponseWrapper tagByLabeltype(@RequestBody List<String> tables) {
        if (CollectionUtils.isEmpty(tables)) {
            return ResponseWrapper.error(1, "请检查参数");
        }
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    tagAddressManager.refreshTagByTable(tables);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();
        return ResponseWrapper.success();
    }

    @PostMapping("tag/refresh-all-label")
    @ApiOperation("初始化打标签")
    @MethodDesc("初始化打标签")
    public ResponseWrapper refreshAllLabel() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    tagAddressManager.refreshAllLabel();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();
        return ResponseWrapper.success();
    }

}
