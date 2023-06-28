package com.relation.tag.manager;

import com.relation.tag.entity.UgcLabelDataAnalysis;

public interface StaticManager {
    void check(String tableName, long sleepTime, Integer resultNum, String tableSuffix, String batchDate) throws Exception;

    boolean checkResult(String tableName, Integer result, String tableSuffix, String batchDate);

    void staticData(UgcLabelDataAnalysis entity, String configEnvironment) throws Exception;

    void staticLabelDataAnalysis();

    void synLabelDataAnalysis();

    void staticHomePageData();

    void synHomePageData();




}
