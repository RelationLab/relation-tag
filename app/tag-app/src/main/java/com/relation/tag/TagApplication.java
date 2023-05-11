package com.relation.tag;

import com.relation.tag.manager.TagAddressManager;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.client.utils.DateUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

import java.util.Date;

@SpringBootApplication(scanBasePackages = {"com.relation.tag",
        "org.springframework.boot.extension"})
@Slf4j
public class TagApplication {

    public static void main(String[] args) throws Exception {
        ConfigurableApplicationContext ctx = SpringApplication.run(TagApplication.class, args);
        String configEnvironment = ctx.getEnvironment().getProperty("config.environment");
        log.info("configEnvironment====={}",configEnvironment);
        configEnvironment = StringUtils.isEmpty(configEnvironment)?"stag":configEnvironment;
        TagAddressManager tagAddressManager = ctx.getBean(TagAddressManager.class);
        String batchDate = DateUtils.formatDate(new Date(), "YYYY-MM-dd");
        String checkTable = "address_labels_json_gin_".concat(configEnvironment);
        if (tagAddressManager.checkResult(checkTable, batchDate, 1, false)){
            log.info("checkResult tag end...........");
            System.exit(0);
        }
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    tagAddressManager.refreshAllLabel(batchDate);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();
        Thread.sleep(60*60*1000);
        log.info("check address_labels_json_gin start...........");
        tagAddressManager.check(checkTable, 1 * 60 * 1000, batchDate, 1, false);
        log.info("tag end...........");
        System.exit(0);
    }
}
