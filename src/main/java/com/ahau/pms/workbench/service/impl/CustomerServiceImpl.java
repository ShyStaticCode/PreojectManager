package com.ahau.pms.workbench.service.impl;

import com.ahau.pms.settings.dao.UserDao;
import com.ahau.pms.settings.domain.User;
import com.ahau.pms.utils.SqlSessionUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.dao.CustomerDao;
import com.ahau.pms.workbench.dao.CustomerRemarkDao;
import com.ahau.pms.workbench.domain.Customer;
import com.ahau.pms.workbench.domain.CustomerRemark;
import com.ahau.pms.workbench.service.CustomerService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public class CustomerServiceImpl implements CustomerService {
    //客户相关表
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    //用户表相关
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public Boolean deleteCustomer(String[] ids) {
        Boolean success = true;

        //查询应该删除的备注的数量
        int count1 = customerRemarkDao.getCountByids(ids);
        //与 返回的收到影响的条数  作比较
        int count2 = customerRemarkDao.deleteByids(ids);
        if(count1 != count2){
            success = false;
        }
        int count3 = customerDao.deleteCustomer(ids);
        if(count3 != ids.length ){
            success = false;
        }
        return success;
    }

    @Override
    public List<CustomerRemark> getRemarkListById(String customerId) {
        List<CustomerRemark> customerRemarkList = customerRemarkDao.getRemarkListById(customerId);
        return customerRemarkList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean success = false;
        int count = customerRemarkDao.deleteRemark(id);
        if(count == 1){
            success = true;
        }
        return success;
    }

    @Override
    public List<Customer> getCustomerList() {
        List<Customer> cList = customerDao.getCustomerList();
        return cList;
    }

    @Override
    public boolean saveRemark(CustomerRemark cr) {
        boolean success = false;
        int count = customerRemarkDao.saveRemark(cr);
        if(count == 1){
            success = true;
        }
        return success;
    }

    @Override
    public boolean updateRemark(CustomerRemark cr) {
        boolean success = false;
        int count = customerRemarkDao.updateRemark(cr);
        if(count==1){
            success=true;
        }
        return success;
    }

    @Override
    public Boolean renewCustomer(Customer c) {
        boolean success = true;
        int count = customerDao.renewCustomer(c);
        if(count !=1 ){
            success = false;
        }
        return success;
    }

    @Override
    public Map<String, Object> getUserCustomer(String id) {
        List<User> uList = userDao.getUserList();
        Customer c = customerDao.getCustomerById(id);
        Map<String,Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("c",c);
        return  map;
    }

    @Override
    public Boolean save(Customer c) {
        Boolean success = true;
        int count = customerDao.save(c);
        if (count != 1 ) {
            success = false;
        }
        return success;
    }

    @Override
    public Customer detail(String id) {
        Customer customer = customerDao.detail(id);
        return customer;
    }

    @Override
    public PaginationVO<Customer> pageList(Map<String, Object> map) {
        //拿到total，拿到datalist，分装到vo中，并返回
        int total = customerDao.getTotalByCondition(map);//根据查询条件得到总条数
        List<Customer> dataList = customerDao.getCustomerListByCondition(map);//查询线索列表集合

        PaginationVO<Customer> vo = new PaginationVO<Customer>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }
}
