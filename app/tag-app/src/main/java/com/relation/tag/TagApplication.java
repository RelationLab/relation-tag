package com.relation.tag;

import com.relation.tag.manager.TagAddressManager;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication(scanBasePackages = {"com.relation.tag",
        "org.springframework.boot.extension"})
public class TagApplication {

    public static void main(String[] args) throws Exception {
        ConfigurableApplicationContext ctx = SpringApplication.run(TagApplication.class, args);
        TagAddressManager tagAddressManager = ctx.getBean(TagAddressManager.class);
        tagAddressManager.refreshAllLabel();
    }
}
