package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByName(String company);

    int save(Customer customer);

    int getTotalByCondition(Map<String, Object> map);

    List<Customer> getCustomerListByCondition(Map<String, Object> map);

    Customer detail(String id);

    Customer getCustomerById(String id);

    int renewCustomer(Customer c);

    int deleteCustomer(String[] ids);

    List<Customer> getCustomerList();

}
