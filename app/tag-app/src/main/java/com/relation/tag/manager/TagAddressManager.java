package com.relation.tag.manager;

public interface TagAddressManager {
    void refreshAllLabel(String batchDate) throws Exception;

    void tagMerge(String batchDate) throws Exception;
    void check(String tableName, long sleepTime, String batchDate, int resultNum) throws Exception;
     boolean checkResult(String tableName, String batchDate, Integer result);

}
