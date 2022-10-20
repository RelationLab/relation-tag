package com.relation.tag.manager;

import java.util.List;

public interface TagAddressManager {
    void refreshTagByTable(List<String> tables) throws Exception;

    void refreshAllLabel() throws Exception;

    void tagMerge();

    void refreshTag2pgByTable(List<String> tables);

    void merge2Gin();
}
