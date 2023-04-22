package com.relation.tag;

import com.relation.tag.manager.TagAddressManager;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.client.utils.DateUtils;
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
        TagAddressManager tagAddressManager = ctx.getBean(TagAddressManager.class);
        String batchDate = DateUtils.formatDate(new Date(), "YYYY-MM-dd");
        if (tagAddressManager.checkResult("tag_result", batchDate, 1)){
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
        Thread.sleep(120*60*1000);
        log.info("check address_labels_json_gin start...........");
        tagAddressManager.check("tag_result", 1 * 60 * 1000, batchDate, 1);
        log.info("tag end...........");
        System.exit(0);
    }
}
