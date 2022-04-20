package com.ahau.pms.workbench.service;

import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Tran;
import com.ahau.pms.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface TranService {

    PaginationVO<Tran> pageList(Map<String, Object> map);

    Tran detail(String id);

    List<TranHistory> getTransactionHistoryListById(String tranId);

    boolean save(Tran t,TranHistory th);

    Tran edit(String id);

    boolean update(Tran t);

    boolean deleteList(String[] ids);

}
