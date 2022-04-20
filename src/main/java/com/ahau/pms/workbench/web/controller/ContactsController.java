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
import com.ahau.pms.workbench.service.ClueService;
import com.ahau.pms.workbench.service.ContactsService;
import com.ahau.pms.workbench.service.CustomerService;
import com.ahau.pms.workbench.service.ProjectService;
import com.ahau.pms.workbench.service.impl.ClueServiceImpl;
import com.ahau.pms.workbench.service.impl.ContactsServiceImpl;
import com.ahau.pms.workbench.service.impl.CustomerServiceImpl;
import com.ahau.pms.workbench.service.impl.ProjectServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
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
public class ContactsController extends HttpServlet {

    @Override
    public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到联系人控制器");
        String path = request.getServletPath();

        if("/workbench/contacts/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/contacts/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/contacts/getUserAndCustomerList.do".equals(path)){
            getUserAndCustomerList(request,response);
        }else if("/workbench/contacts/save.do".equals(path)){
            save(request,response);
        }else if("/workbench/contacts/getUserContacts.do".equals(path)){
            getUserCustomerContacts(request,response);
        }else if("/workbench/contacts/renew.do".equals(path)){
            renewContacts(request,response);
        }else if("/workbench/contacts/deleteList.do".equals(path)){
            deleteList(request,response);
        }else if("/workbench/contacts/getContactsRemarkListById.do".equals(path)){
            getContactsRemarkListById(request,response);
        }else if("/workbench/contacts/getProjectListByContactsId.do".equals(path)){
            getProjectListByContactsId(request,response);
        }else if("/workbench/contacts/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if("/workbench/contacts/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if("/workbench/contacts/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if("/workbench/contacts/getProjectListAndNotByContactsId.do".equals(path)){
            getProjectListAndNotByContactsId(request,response);
        }else if("/workbench/contacts/bund.do".equals(path)){
            bund(request,response);
        }else if("/workbench/contacts/unbund.do".equals(path)){
            unbund(request,response);
        }

    }

    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行解除联系人和项目信息关联关系的操作");
        String id = request.getParameter("id");
        ContactsService contactsService = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = contactsService.unbund(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行联系人关联项目信息的操作");
        String cid = request.getParameter("cid");
        String pids[] = request.getParameterValues("pid");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = cs.bund(cid,pids);
        PrintJson.printJsonFlag(response,success);
    }

    private void getProjectListAndNotByContactsId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据项目的名称检索没有被该联系人关联的项目信息，返回项目信息列表");
        String pname = request.getParameter("pname");
        String contactsId = request.getParameter("contatcsId");
        Map<String,String> map = new HashMap<String,String>();
        map.put("pname",pname);
        map.put("contactsId",contactsId);
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        List<Project> pList = ps.getProjectListAndNotByContactsId(map);
        PrintJson.printJsonObj(response,pList);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行添加保存联系人的备注信息");
        String noteContent = request.getParameter("noteContent");
        String contactsId = request.getParameter("contactsId");
        String id = UUIDUtil.getUUID();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String editFlag = "0";
        ContactsRemark cr = new ContactsRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setContactsId(contactsId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = cs.saveRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行联系人备注的更新操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        //修改时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        //修改标志
        String editFlag = "1";
        ContactsRemark cr = new ContactsRemark();
        cr.setEditFlag(editFlag);
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setEditTime(editTime);
        cr.setEditBy(editBy);
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = cs.updateRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除备注的操作");
        String id = request.getParameter("id");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = cs.deleteRemarkById(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void getProjectListByContactsId(HttpServletRequest request, HttpServletResponse response) {
        //操作联系人项目关联关系表
        System.out.println("刷新联系人关联的项目信息");
        String contactsId = request.getParameter("contactsId");
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        List<Project> pList = ps.getProjectListByContactsId(contactsId);
        PrintJson.printJsonObj(response,pList);
    }

    private void getContactsRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据联系人contactsId查询联系人备注列表");
        String contactsId = request.getParameter("contactsId");
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        List<ContactsRemark> crList = cs.getContactsRemarkListById(contactsId);
        PrintJson.printJsonObj(response,crList);
    }

    private void deleteList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除联系人删除的操作");
        String ids[] = request.getParameterValues("id");

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = cs.deleteList(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void renewContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行联系人信息的更新操作");
        String owner = request.getParameter("edit-contactsOwner");
        String id = request.getParameter("edit-id");
        String customerId = request.getParameter("edit-customer");
        String appellation = request.getParameter("edit-appellation");
        String fullname = request.getParameter("edit-fullname");
        String job = request.getParameter("edit-job");
        String email = request.getParameter("edit-email");
        String mphone = request.getParameter("edit-mphone");
        String source = request.getParameter("edit-source");
        String description = request.getParameter("edit-describe");
        String contactSummary = request.getParameter("edit-contactSummary");
        String nextContactTime = request.getParameter("edit-nextContactTime");
        String address = request.getParameter("edit-address");
        String birth = request.getParameter("edit-birth");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();

        Contacts c = new Contacts();
        c.setId(id);
        c.setFullname(fullname);
        c.setAppellation(appellation);
        c.setOwner(owner);
        c.setJob(job);
        c.setEmail(email);
        c.setMphone(mphone);
        c.setAddress(address);
        c.setSource(source);
        c.setEditBy(editBy);
        c.setCustomerId(customerId);
        c.setBirth(birth);
        c.setEditTime(editTime);
        c.setContactSummary(contactSummary);
        c.setDescription(description);
        c.setNextContactTime(nextContactTime);
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = cs.renewContacts(c);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserCustomerContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行修改操作，检索信息填充文本框");
        String id = request.getParameter("id");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Customer> custList = cs.getCustomerList();
        ContactsService cons = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Contacts contacts = cons.getContactsById(id);
        Map<String,Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("custList",custList);
        map.put("c",contacts);
        PrintJson.printJsonObj(response,map);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行联系人的保存操作");
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String owner = request.getParameter("owner");
        String source = request.getParameter("source");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String job = request.getParameter("job");
        String mphone = request.getParameter("mphone");
        String email = request.getParameter("email");
        String birth = request.getParameter("birth");
        String description  = request.getParameter("description");
        String customerId = request.getParameter("customerId");
        String contactSummary = request.getParameter("contactsSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        Contacts contacts = new Contacts();
        contacts.setId(id);
        contacts.setFullname(fullname);
        contacts.setAppellation(appellation);
        contacts.setOwner(owner);
        contacts.setJob(job);
        contacts.setEmail(email);
        contacts.setMphone(mphone);
        contacts.setAddress(address);
        contacts.setSource(source);
        contacts.setCreateBy(createBy);
        contacts.setCreateTime(createTime);
        contacts.setContactSummary(contactSummary);
        contacts.setDescription(description);
        contacts.setBirth(birth);
        contacts.setCustomerId(customerId);
        contacts.setNextContactTime(nextContactTime);

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        boolean success = cs.save(contacts);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserAndCustomerList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("联系人模块，取得用户信息列表进行信息填充，取得客户信列表提供选择");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());
        List<Customer> cList = cs.getCustomerList();
        Map<String,Object> map = new HashMap<>();
        map.put("uList",uList);
        map.put("cList",cList);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行联系人列表刷新的操作,pageList");
        String fullname  = request.getParameter("fullname");
        String source = request.getParameter("source");
        String owner = request.getParameter("owner");
        String customerName = request.getParameter("customerName");
        String birth = request.getParameter("birth");

        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("birth",birth);
        map.put("customerName",customerName);
        map.put("source", source);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());

        PaginationVO<Contacts> vo = cs.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void detail(ServletRequest request, ServletResponse response) throws ServletException, IOException {
        System.out.println("进入到联系人详情页");
        String id = request.getParameter("id");

        ContactsService cs = (ContactsService) ServiceFactory.getService(new ContactsServiceImpl());
        Contacts contacts = cs.detail(id);
        request.setAttribute("contacts",contacts);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);
    }

}
