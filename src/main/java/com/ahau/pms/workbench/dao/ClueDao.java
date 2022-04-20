package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {

    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    Clue detail(String id);

    Clue getById(String id);

    int renewClue(Clue clue);

    int delete(String[] ids);
    //在线索转换的时候删除的方法
    int deleteByClueId(String clueId);

}
