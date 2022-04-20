package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {


    int save(TranHistory tranHistory);

    List<TranHistory> getTransactionHistoryListById(String tranId);



}
