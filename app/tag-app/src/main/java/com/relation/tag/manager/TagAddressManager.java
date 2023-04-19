package com.relation.tag.manager;

public interface TagAddressManager {
    void refreshAllLabel(String batchDate) throws Exception;

    void tagMerge(String batchDate) throws Exception;
    void check(String tableName, long sleepTime, String batchDate) throws Exception;
     boolean checkResult(String tableName, String batchDate);
    void staticData(String batchDate) throws Exception;

}
