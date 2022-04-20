package com.ahau.pms.workbench.dao;


import com.ahau.pms.workbench.domain.Tran;
import com.ahau.pms.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    int getTotalByCondition(Map<String, Object> map);

    List<Tran> getTranListByCondition(Map<String, Object> map);

    Tran detail(String id);

    Tran edit(String id);

    int update(Tran t);

    int deleteList(String[] ids);

}
