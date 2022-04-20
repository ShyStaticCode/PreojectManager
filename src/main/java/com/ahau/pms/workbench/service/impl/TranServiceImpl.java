package com.ahau.pms.workbench.service.impl;

import com.ahau.pms.utils.SqlSessionUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.dao.TranDao;
import com.ahau.pms.workbench.dao.TranHistoryDao;
import com.ahau.pms.workbench.domain.Tran;
import com.ahau.pms.workbench.domain.TranHistory;
import com.ahau.pms.workbench.service.TranService;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public class TranServiceImpl implements TranService {
    //交易相关的表
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

    @Override
    public boolean save(Tran t,TranHistory th) {
        boolean success = true;
        int count1 = tranDao.save(t);
        if (count1 != 1) {
            success = false;
        }
        int count2 = tranHistoryDao.save(th);
        if (count2 != 1) {
            success = false;
        }
        return success;
    }

    @Override
    public boolean deleteList(String[] ids) {
        boolean success = true;
        int count3 = tranDao.deleteList(ids);
        if (count3 != ids.length) {
            success = false;
        }
        return success;
    }

    @Override
    public boolean update(Tran t) {
        boolean success = true;
        int count = tranDao.update(t);
        if (count != 1) {
            success=false;
        }
        return success;
    }

    @Override
    public Tran edit(String id) {
        Tran tran = tranDao.edit(id);
        return tran;
    }

    @Override
    public List<TranHistory> getTransactionHistoryListById(String tranId) {
        List<TranHistory> tranHistoryList = tranHistoryDao.getTransactionHistoryListById(tranId);//查询线索列表集合

        return tranHistoryList;
    }

    @Override
    public PaginationVO<Tran> pageList(Map<String, Object> map) {
        //拿到total，拿到datalist，分装到vo中，并返回
        int total = tranDao.getTotalByCondition(map);//根据查询条件得到总条数
        List<Tran> dataList = tranDao.getTranListByCondition(map);//查询线索列表集合

        PaginationVO<Tran> vo = new PaginationVO<Tran>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public Tran detail(String id) {
        Tran tran = tranDao.detail(id);
        return tran;
    }
}
