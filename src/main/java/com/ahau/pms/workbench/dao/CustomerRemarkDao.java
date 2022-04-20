package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkDao {

    int save(CustomerRemark customerRemark);

    List<CustomerRemark> getRemarkListById(String customerId);

    int updateRemark(CustomerRemark cr);

    int saveRemark(CustomerRemark cr);

    int deleteRemark(String id);

    int getCountByids(String[] ids);

    int deleteByids(String[] ids);

}
