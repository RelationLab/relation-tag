package com.relation.tag.job;

import com.relation.tag.manager.StaticManager;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@Slf4j
public class StaticAnalysisDataJob {
    @Autowired
    private StaticManager staticManager;

    @Scheduled(cron = "0/30 * * * * ?")
//    @XxlJob("staticAsynData")
    public void staticLabelDataAnalysis() {
        staticManager.staticLabelDataAnalysis();
    }

//    @MethodDesc("Scheduled task: ugcDataAnalysisDownloadTimeout")
//    @Scheduled(cron = "0/30 * * * * ?")
////    @XxlJob("ugcDataAnalysisDownloadTimeout")
//    public void ugcDataAnalysisDownloadTimeout() {
//        staticManager.ugcDataAnalysisDownloadTimeout();
//    }


    @Scheduled(cron = "0/30 * * * * ?")
//    @XxlJob("synAnalysisData2Pg")
    public void synAnalysisData2Pg() {
        staticManager.synLabelDataAnalysis();
    }

    @Scheduled(cron = "0/30 * * * * ?")
//    @XxlJob("staticHomePageData")
    public void staticHomePageData() {
        staticManager.staticHomePageData();
    }

    @Scheduled(cron = "0/30 * * * * ?")
//    @XxlJob("synHomePageData")
    public void synHomePageData() {
        staticManager.synHomePageData();
    }

}
