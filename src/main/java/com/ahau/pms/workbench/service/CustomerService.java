package com.ahau.pms.workbench.service;

import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Customer;
import com.ahau.pms.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface CustomerService {
    PaginationVO<Customer> pageList(Map<String, Object> map);

    Customer detail(String id);

    Boolean save(Customer c);

    Map<String, Object> getUserCustomer(String id);

    Boolean renewCustomer(Customer c);

    Boolean deleteCustomer(String[] ids);

    List<CustomerRemark> getRemarkListById(String customerId);

    boolean updateRemark(CustomerRemark cr);

    boolean saveRemark(CustomerRemark cr);

    boolean deleteRemark(String id);

    List<Customer> getCustomerList();

}
