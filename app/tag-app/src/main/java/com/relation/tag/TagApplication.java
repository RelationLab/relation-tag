package com.relation.tag;

import com.relation.tag.manager.TagAddressManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication(scanBasePackages = {"com.relation.tag",
        "org.springframework.boot.extension"})
@Slf4j
public class TagApplication {

    public static void main(String[] args) throws Exception {
        ConfigurableApplicationContext ctx = SpringApplication.run(TagApplication.class, args);
        TagAddressManager tagAddressManager = ctx.getBean(TagAddressManager.class);
        if (tagAddressManager.checkResult("address_labels_json_gin")){
            log.info("checkResult tag end...........");
            System.exit(0);
        }
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
        Thread.sleep(240*60*1000);
        log.info("check address_labels_json_gin start...........");
        tagAddressManager.check("address_labels_json_gin", 1 * 60 * 1000);
        log.info("tag end...........");
        System.exit(0);
    }
}
