package com.ahau.pms.workbench.service;

import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Clue;
import com.ahau.pms.workbench.domain.ClueRemark;
import com.ahau.pms.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface ClueService {

    boolean save(Clue clue);

    PaginationVO<Clue> pageList(Map<String, Object> map);

    Clue detail(String id);

    Map<String, Object> getUserClue(String id);

    boolean renewClue(Clue clue);

    boolean deleteList(String[] ids);

    List<ClueRemark> getClueRemarkListById(String clueId);

    boolean saveRemark(ClueRemark cr);

    boolean deleteRemark(String id);

    boolean updateRemark(ClueRemark cr);

    boolean bund(String cid, String[] pids);

    boolean unbund(String id);

    boolean convert(String clueId, Tran t, String createBy);

}
