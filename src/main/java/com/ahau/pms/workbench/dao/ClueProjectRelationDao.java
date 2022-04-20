package com.ahau.pms.workbench.dao;


import com.ahau.pms.workbench.domain.ClueProjectRelation;

import java.util.List;

public interface ClueProjectRelationDao {

    //线索主动删除
    int getCountByCids(String[] ids);

    int deleteClueByCids(String[] ids);
    //项目主动删除
    int getCountBypids(String[] ids);

    int deleteProjectBypids(String[] ids);

    int bund(ClueProjectRelation cpr);

    int unbund(String id);

    List<ClueProjectRelation> getListByClueId(String clueId);

    int delete(ClueProjectRelation clueProjectRelation);

}
