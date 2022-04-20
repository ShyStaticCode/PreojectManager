package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);

    List<ClueRemark> getClueRemarkListById(String clueId);

    int saveRemark(ClueRemark cr);

    int deleteRemark(String id);

    int updateRemark(ClueRemark cr);

    List<ClueRemark> getListByClueId(String clueId);
//在线索转换的时候删除备注的方法
    int delete(ClueRemark clueRemark);
}
