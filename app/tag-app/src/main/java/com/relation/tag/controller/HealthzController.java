package com.relation.tag.controller;

import org.springframework.boot.extension.entity.response.ResponseWrapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthzController {

    @GetMapping("healthz")
    public ResponseWrapper healthz() {
        return ResponseWrapper.success();
    }
}