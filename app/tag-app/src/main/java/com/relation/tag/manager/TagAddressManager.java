package com.relation.tag.manager;

public interface TagAddressManager {
    void refreshAllLabel() throws Exception;

    void tagMerge();

    void merge2Gin();

    void check(String tableName, long sleepTime) throws Exception;
}
