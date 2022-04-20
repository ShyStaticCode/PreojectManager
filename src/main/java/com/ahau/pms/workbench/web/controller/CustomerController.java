package com.ahau.pms.workbench.web.controller;

import com.ahau.pms.settings.domain.User;
import com.ahau.pms.settings.service.UserService;
import com.ahau.pms.settings.service.impl.UserServiceImpl;
import com.ahau.pms.utils.DateTimeUtil;
import com.ahau.pms.utils.PrintJson;
import com.ahau.pms.utils.ServiceFactory;
import com.ahau.pms.utils.UUIDUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Customer;
import com.ahau.pms.workbench.domain.CustomerRemark;
import com.ahau.pms.workbench.domain.ProjectRemark;
import com.ahau.pms.workbench.service.CustomerService;
import com.ahau.pms.workbench.service.ProjectService;
import com.ahau.pms.workbench.service.impl.CustomerServiceImpl;
import com.ahau.pms.workbench.service.impl.ProjectServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public class CustomerController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到客户控制器");
        String path = request.getServletPath();

        if("/workbench/customer/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/customer/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/customer/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if ("/workbench/customer/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/customer/getUserCustomer.do".equals(path)){
            getUserCustomer(request,response);
        }else if ("/workbench/customer/renewCustomer.do".equals(path)){
            renewCustomer(request,response);
        }else if ("/workbench/customer/deleteList.do".equals(path)){
            deleteCustomer(request,response);
        }else if ("/workbench/customer/getRemarkListById.do".equals(path)){
            getRemarkListById(request,response);
        }else if ("/workbench/customer/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if ("/workbench/customer/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/customer/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }

    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除项目备注的操作");
        String id = request.getParameter("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success =  cs.deleteRemark(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行添加备注的操作");
        String noteContent = request.getParameter("noteContent");
        String customerId = request.getParameter("customerId");
        String id = UUIDUtil.getUUID();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String editFlag = "0";
        CustomerRemark cr = new CustomerRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setCustomerId(customerId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = cs.saveRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行客户备注更新操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        //修改时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        CustomerRemark cr = new CustomerRemark();
        cr.setEditFlag(editFlag);
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setEditTime(editTime);
        cr.setEditBy(editBy);
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        boolean success = cs.updateRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询客户备注信息列表");
        String customerId = request.getParameter("customerId");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<CustomerRemark> customerRemarkList = cs.getRemarkListById(customerId);
        PrintJson.printJsonObj(response,customerRemarkList);


    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除客户记录操作");
        String ids[] = request.getParameterValues("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Boolean success = cs.deleteCustomer(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void renewCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("保存修改的内容，客户信息");
        String owner = request.getParameter("edit-owner");
        String name = request.getParameter("edit-name");
        String id = request.getParameter("edit-id");
        String phone = request.getParameter("edit-phone");
        String website = request.getParameter("edit-website");
        String description = request.getParameter("edit-description");
        String contactSummary = request.getParameter("edit-contactSummary");
        String nextContactTime = request.getParameter("edit-nextContactTime");
        String address = request.getParameter("edit-address");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        Customer c = new Customer();
        c.setId(id);
        c.setOwner(owner);
        c.setName(name);
        c.setPhone(phone);
        c.setWebsite(website);
        c.setDescription(description);
        c.setAddress(address);
        c.setNextContactTime(nextContactTime);
        c.setContactSummary(contactSummary);
        c.setEditBy(editBy);
        c.setEditTime(editTime);
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Boolean success = cs.renewCustomer(c);
        PrintJson.printJsonFlag(response,success);

    }

    private void getUserCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行修改客户信息的操作");
        String id = request.getParameter("id");
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        //前端需要userList  和    customer对象
        Map<String,Object> map = cs.getUserCustomer(id);
        PrintJson.printJsonObj(response,map);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行保存客户信息的操作");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String website = request.getParameter("website");
        String phone = request.getParameter("phone");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String description = request.getParameter("description");
        String address = request.getParameter("address");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        Customer c = new Customer();
        c.setId(id);
        c.setOwner(owner);
        c.setName(name);
        c.setPhone(phone);
        c.setWebsite(website);
        c.setCreateBy(createBy);
        c.setDescription(description);
        c.setCreateTime(createTime);
        c.setAddress(address);
        c.setNextContactTime(nextContactTime);
        c.setContactSummary(contactSummary);
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Boolean success = cs.save(c);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行所有者查询列表");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        PrintJson.printJsonObj(response,uList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到客户详情信息界面");
        String id = request.getParameter("id");

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        Customer customer = cs.detail(id);
        request.setAttribute("customer",customer);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("客户界面刷新");
        String name  = request.getParameter("name");
        String phone = request.getParameter("phone");
        String owner = request.getParameter("owner");

        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        PaginationVO<Customer> vo = cs.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}
