package com.relation.tag.manager;

public interface TagAddressManager {
    void refreshAllLabel() throws Exception;

    void tagMerge() throws Exception;
    void check(String tableName, long sleepTime) throws Exception;
     boolean checkResult(String tableName);
}
