package com.relation.tag;

import com.relation.tag.manager.TagAddressManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(2) // 通过order值的大小来决定启动的顺序
@Slf4j
public class InitSpringBoot implements CommandLineRunner {


    @Autowired
    private TagAddressManager tagAddressManager ;



    @Override
    public void run(String... args) throws Exception {
        try {
            Thread.sleep(10*1000);
            tagAddressManager.refreshAllLabel();
            log.info("springboot初始化完成");
        } catch (Exception e) {
            log.error("springboot初始化异常", e);
        }
    }
}
