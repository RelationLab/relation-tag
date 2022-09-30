package com.relation.tag.manager;

import java.util.List;

public interface TagAddressManager {
    void refreshTagByTable(List<String> tables) throws Exception;

    void refreshAllLabel() throws Exception;
}
