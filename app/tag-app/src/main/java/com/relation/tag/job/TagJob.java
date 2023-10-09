package com.relation.tag.job;

import com.relation.tag.manager.TagAddressManager;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.client.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Calendar;
import java.util.Date;

@Component
@Slf4j
public class TagJob {

    @Value("${config.environment}")
    private String configEnvironment;
    @Value("${config.tag.flag}")
    private String tagFlag;

    @Autowired
    private TagAddressManager tagAddressManager;

    /**
     * 打测试环境
     *
     * @throws Exception
     */
//    @Scheduled(cron = "0 0 19 * * ?")
    public void execTagForStag() throws Exception {
        if (!StringUtils.equals(configEnvironment, "stag")) {
            return;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.HOUR, calendar.get(Calendar.HOUR) + 8);
        String batchDate = DateUtils.formatDate(calendar.getTime(), "YYYY-MM-dd");
        tag(batchDate);
    }

    /**
     * 打生产环境
     *
     * @throws Exception
     */
//    @Scheduled(cron = "0 0 1 * * ?")
    public void execTagForProd() throws Exception {
        if (!StringUtils.equals(configEnvironment, "prod")) {
            return;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.HOUR, calendar.get(Calendar.HOUR) + 8);
        // 将日期减一天
        calendar.add(Calendar.DAY_OF_MONTH, -1);
        String batchDate = DateUtils.formatDate(calendar.getTime(), "YYYY-MM-dd");
        tag(batchDate);
    }

    private void tag(String batchDate) throws Exception {
        if (!StringUtils.equals(tagFlag, "tag")) {
            return;
        }
        log.info("configEnvironment====={}", configEnvironment);
        configEnvironment = StringUtils.isEmpty(configEnvironment) ? "stag" : configEnvironment;

        String checkTable = "rename_table_".concat(configEnvironment);
        if (tagAddressManager.checkResult(checkTable, batchDate, 1, false)) {
            log.info("checkResult tag end...........");
            return;
//            System.exit(0);
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
        Thread.sleep(60 * 60 * 1000);
        log.info("check address_labels_json_gin start...........");
        tagAddressManager.check(checkTable, 1 * 60 * 1000, batchDate, 1, false);
        log.info("tag end...........");
    }

    /**
     * 打测试环境
     *
     * @throws Exception
     */
    @Scheduled(cron = "0 */5 * * * ?")
    public void checkTagFinish() throws Exception {
        if (StringUtils.equals(tagFlag, "dev")) {
            return;
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.set(Calendar.HOUR, calendar.get(Calendar.HOUR) + 8);
        // 将日期减一天
        calendar.add(Calendar.DAY_OF_MONTH, -1);
        String batchDate = DateUtils.formatDate(calendar.getTime(), "YYYY-MM-dd");
        tagAddressManager.checkTagFinish(batchDate);
    }
}
