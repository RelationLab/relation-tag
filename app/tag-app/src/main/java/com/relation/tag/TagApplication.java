package com.relation.tag;

import com.relation.tag.manager.TagAddressManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.scheduling.annotation.EnableScheduling;

import javax.annotation.PostConstruct;

@SpringBootApplication(scanBasePackages = {"com.relation.tag",
        "org.springframework.boot.extension"})
@EnableScheduling
public class TagApplication {
    @Autowired
    private TagAddressManager tagAddressManager;
    public static void main(String[] args)  {
        ConfigurableApplicationContext ctx =  SpringApplication.run(TagApplication.class, args);
    }
    @PostConstruct
    public void postConstruct() throws Exception {
        System.out.println("执行Springboot正式启动前的代码 start.........");
        System.out.println("执行Springboot正式启动前的代码 end.........");
    }
}
