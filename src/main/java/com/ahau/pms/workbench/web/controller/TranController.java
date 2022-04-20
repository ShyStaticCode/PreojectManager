package com.ahau.pms.workbench.web.controller;


import com.ahau.pms.settings.domain.User;
import com.ahau.pms.settings.service.UserService;
import com.ahau.pms.settings.service.impl.UserServiceImpl;
import com.ahau.pms.utils.DateTimeUtil;
import com.ahau.pms.utils.PrintJson;
import com.ahau.pms.utils.ServiceFactory;
import com.ahau.pms.utils.UUIDUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.*;
import com.ahau.pms.workbench.service.ContactsService;
import com.ahau.pms.workbench.service.CustomerService;
import com.ahau.pms.workbench.service.ProjectService;
import com.ahau.pms.workbench.service.TranService;
import com.ahau.pms.workbench.service.impl.ContactsServiceImpl;
import com.ahau.pms.workbench.service.impl.CustomerServiceImpl;
import com.ahau.pms.workbench.service.impl.ProjectServiceImpl;
import com.ahau.pms.workbench.service.impl.TranServiceImpl;

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
public class TranController extends HttpServlet {
    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易控制器");
        String path = request.getServletPath();

        if("/workbench/tran/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/tran/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/tran/getTransactionHistoryListById.do".equals(path)){
            getTransactionHistoryListById(request,response);
        }else if ("/workbench/tran/getUserContactsCustomerProject.do".equals(path)){
            getUserContactsCustomerProject(request,response);
        }else if ("/workbench/tran/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/tran/edit.do".equals(path)){
            edit(request,response);
        }else if ("/workbench/tran/renew.do".equals(path)){
            renew(request,response);
        }else if ("/workbench/tran/deleteList.do".equals(path)){
            deleteList(request,response);
        }

    }

    private void deleteList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行交易删除操作");
        String ids[] = request.getParameterValues("id");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean success = ts.deleteList(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void renew(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行交易的更新操作");
        String owner = request.getParameter("owner");
        String id = request.getParameter("id");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerId = request.getParameter("customerId");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String projectId = request.getParameter("projectId");
        String contactsId = request.getParameter("contactsId");
        String description  = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();

        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setType(type);
        t.setStage(stage);
        t.setSource(source);
        t.setProjectId(projectId);
        t.setNextContactTime(nextContactTime);
        t.setName(name);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setDescription(description);
        t.setEditBy(editBy);
        t.setEditTime(editTime);
        t.setCustomerId(customerId);
        t.setContactSummary(contactSummary);
        t.setContactsId(contactsId);
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean success = ts.update(t);
        PrintJson.printJsonFlag(response,success);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("传统请求，返回指定id的交易信息对象");
        String id = request.getParameter("id");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = ts.edit(id);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/edit.jsp").forward(request,response);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到交易保存操作");
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerId = request.getParameter("customerId");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String projectId = request.getParameter("projectId");
        String contactsId = request.getParameter("contactsId");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String id = UUIDUtil.getUUID();
        //创建交易对象
        Tran t = new Tran();
        t.setId(id);
        t.setOwner(owner);
        t.setType(type);
        t.setStage(stage);
        t.setSource(source);
        t.setProjectId(projectId);
        t.setNextContactTime(nextContactTime);
        t.setName(name);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setDescription(description);
        t.setCreateTime(createTime);
        t.setCreateBy(createBy);
        t.setCustomerId(customerId);
        t.setContactSummary(contactSummary);
        t.setContactsId(contactsId);
        //创建交易历史对象
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(id);
        th.setCreateBy(createBy);
        th.setStage(stage);
        th.setMoney(money);
        th.setExpectedDate(expectedDate);
        th.setCreateTime(createTime);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        boolean success = ts.save(t,th);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserContactsCustomerProject(HttpServletRequest request, HttpServletResponse response) {
        //[用户信息列表userList，客户信息列表customerList，项目信息表projectList，联系人信息表contactsList]
        System.out.println("交易模块，取得用户信息列表，客户信列表，联系人信息，项目信息列表提供选择");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Customer> cList = cs.getCustomerList();
        ContactsService contactsService = (ContactsService)ServiceFactory.getService(new ContactsServiceImpl());
        List<Contacts> contactsList = contactsService.getContactsList();
        ProjectService  projectService = ( ProjectService)ServiceFactory.getService(new ProjectServiceImpl());
        List<Project>  projectList =  projectService.getProjectList();
        Map<String,Object> map = new HashMap<>();
        map.put("userList",uList);
        map.put("customerList",cList);
        map.put("contactsList",contactsList);
        map.put("projectList",projectList);

        PrintJson.printJsonObj(response,map);
    }

    private void getTransactionHistoryListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据交易的Id查询交易历史列表并返回");
        String tranId = request.getParameter("tranId");
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> tranHistoryList = ts.getTransactionHistoryListById(tranId);
        PrintJson.printJsonObj(response,tranHistoryList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易详情页");
        String id = request.getParameter("id");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = ts.detail(id);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("分页查询，刷新列表");

        String owner = request.getParameter("owner");
        String state = request.getParameter("stage");
        String transactionname = request.getParameter("transactionname");
        String customername = request.getParameter("customername");
        String transactionType = request.getParameter("transactionType");
        String contactsfullname = request.getParameter("contactsfullname");

        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("owner",owner);
        map.put("stage",state);
        map.put("transactionname",transactionname);
        map.put("customername",customername);
        map.put("transactionType",transactionType);
        map.put("contactsfullname",contactsfullname);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        PaginationVO<Tran> vo = ts.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}
