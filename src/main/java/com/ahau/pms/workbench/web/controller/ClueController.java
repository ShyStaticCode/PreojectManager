package com.ahau.pms.workbench.web.controller;

import com.ahau.pms.settings.domain.User;
import com.ahau.pms.settings.service.UserService;
import com.ahau.pms.settings.service.impl.UserServiceImpl;
import com.ahau.pms.utils.*;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Clue;
import com.ahau.pms.workbench.domain.ClueRemark;
import com.ahau.pms.workbench.domain.Project;
import com.ahau.pms.workbench.domain.Tran;
import com.ahau.pms.workbench.service.ClueService;
import com.ahau.pms.workbench.service.ProjectService;
import com.ahau.pms.workbench.service.impl.ClueServiceImpl;
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
public class ClueController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到线索控制器");
        String path = request.getServletPath();

        if ("/workbench/clue/getUserList.do".equals(path)) {
            getUserList(request,response);
        }else if("/workbench/clue/save.do".equals(path)){
            save(request,response);
        }else if("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/clue/getUserClue.do".equals(path)){
            getUserClue(request,response);
        }else if("/workbench/clue/renew.do".equals(path)){
            renewClue(request,response);
        }else if("/workbench/clue/deleteList.do".equals(path)){
            deleteList(request,response);
        }else if("/workbench/clue/getClueRemarkListById.do".equals(path)){
            getClueRemarkListById(request,response);
        }else if("/workbench/clue/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if("/workbench/clue/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if("/workbench/clue/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if("/workbench/clue/getProjectListByClueId.do".equals(path)){
            getProjectListByClueId(request,response);
        }else if("/workbench/clue/getProjectListAndNotByClueId.do".equals(path)){
            getProjectListAndNotByClueId(request,response);
        }else if("/workbench/clue/bund.do".equals(path)){
            bund(request,response);
        }else if("/workbench/clue/unbund.do".equals(path)){
            unbund(request,response);
        }else if("/workbench/clue/getProjectListByName.do".equals(path)){
            getProjectListByName(request,response);
        }else if("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }

    }
    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("执行项目线索转换操作");
        String clueId = request.getParameter("clueId");
        //接受是否要创建交易的标记
        String flag = request.getParameter("flag");
        Tran t = null;
        String createBy = "";
        //如果创建了交易，就创建交易信息表
        if("YES".equals(flag)){
            //接受form表单，创建交易
            t = new Tran();
            String money = request.getParameter("money");
            String name = request.getParameter("name");
            String expectedDate = request.getParameter("expectedDate");
            String stage = request.getParameter("stage");
            String projectId = request.getParameter("projectId");
            String id = UUIDUtil.getUUID();
            createBy = ((User)request.getSession().getAttribute("user")).getName();
            String createTime = DateTimeUtil.getSysTime();
            t.setProjectId(projectId);
            t.setCreateBy(createBy);
            t.setCreateTime(createTime);
            t.setExpectedDate(expectedDate);
            t.setMoney(money);
            t.setName(name);
            t.setId(id);
            t.setStage(stage);
        }
        //把tran传递过去到业务层，在业务层判断t是否为空
        //给业务层传递的参数有 clueId 和 交易(t)的对象
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.convert(clueId,t,createBy);
        if (success) {
            //如果success是true,表示转换成功，重定向界面到列表中首页
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }

    }

    private void getProjectListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行查询项目信息列表，在线索转换的窗口");
        String pname = request.getParameter("pname");
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        List<Project> pList = ps.getProjectListByName(pname);
        PrintJson.printJsonObj(response,pList);
    }

    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行解除项目关联操作");
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.unbund(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行关联项目信息的操作");
        String cid = request.getParameter("cid");
        String pids[] = request.getParameterValues("pid");
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.bund(cid,pids);
        PrintJson.printJsonFlag(response,success);
    }

    private void getProjectListAndNotByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据项目的名称检索没有被该线索关联的项目信息，返回项目信息列表");
        String pname = request.getParameter("pname");
        String clueId = request.getParameter("clueId");
        Map<String,String> map = new HashMap<String,String>();
        map.put("pname",pname);
        map.put("clueId",clueId);
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        List<Project> pList = ps.getProjectListAndNotByClueId(map);
        PrintJson.printJsonObj(response,pList);
    }

    private void getProjectListByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据线索id查询关联的市场活动列表");
        String clueId = request.getParameter("clueId");
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        List<Project> pList = ps.getProjectListByClueId(clueId);
        PrintJson.printJsonObj(response,pList);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行线索备注的更新操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        //修改时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        //修改标志
        String editFlag = "1";
        ClueRemark cr = new ClueRemark();
        cr.setEditFlag(editFlag);
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setEditTime(editTime);
        cr.setEditBy(editBy);
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.updateRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除备注的操作");
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.deleteRemark(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行添加备注的操作");
        String noteContent = request.getParameter("noteContent");
        String clueId = request.getParameter("clueId");
        String id = UUIDUtil.getUUID();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String editFlag = "0";
        ClueRemark cr = new ClueRemark();
        cr.setId(id);
        cr.setNoteContent(noteContent);
        cr.setClueId(clueId);
        cr.setCreateTime(createTime);
        cr.setCreateBy(createBy);
        cr.setEditFlag(editFlag);
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.saveRemark(cr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("cr",cr);
        PrintJson.printJsonObj(response,map);
    }

    private void getClueRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据项目线索信息id查询线索备注列表");
        String clueId = request.getParameter("clueId");
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<ClueRemark> crList = cs.getClueRemarkListById(clueId);
        PrintJson.printJsonObj(response,crList);
    }

    private void deleteList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除线索信息删除的操作");
        String ids[] = request.getParameterValues("id");

        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.deleteList(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void renewClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行更新项目线索操作");
        String id = request.getParameter("edit-id");
        String owner = request.getParameter("edit-clueOwner");
        String company = request.getParameter("edit-company");
        String appellation = request.getParameter("edit-call");
        String fullname = request.getParameter("edit-surname");
        String job = request.getParameter("edit-job");
        String email = request.getParameter("edit-email");
        String phone = request.getParameter("edit-phone");
        String mphone = request.getParameter("edit-mphone");
        String website = request.getParameter("edit-website");
        String state = request.getParameter("edit-status");
        String source = request.getParameter("edit-source");
        String description = request.getParameter("edit-describe");
        String contactSummary = request.getParameter("edit-contactSummary");
        String nextContactTime = request.getParameter("edit-nextContactTime");
        String address = request.getParameter("edit-address");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setMphone(mphone);
        clue.setAddress(address);
        clue.setWebsite(website);
        clue.setState(state);
        clue.setSource(source);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        clue.setContactSummary(contactSummary);
        clue.setDescription(description);
        clue.setPhone(phone);
        clue.setNextContactTime(nextContactTime);

        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.renewClue(clue);
        PrintJson.printJsonFlag(response,success);


    }

    private void getUserClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行线索修改操作，获取线索信息填充");
        String id = request.getParameter("id");
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        //前端需要userList  和    clue对象
        Map<String,Object> map = cs.getUserClue(id);
        PrintJson.printJsonObj(response,map);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到线索详情页");
        String id = request.getParameter("id");

        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = cs.detail(id);
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行列表刷新的操作,pageList");
        String name  = request.getParameter("name");
        String company = request.getParameter("company");
        String phone = request.getParameter("phone");
        String mphone = request.getParameter("mphone");
        String source = request.getParameter("source");
        String owner = "";
        String state = request.getParameter("state");


        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("source", source);
        map.put("state",state);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());

        PaginationVO<Clue> vo = cs.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行项目线索的保存操作");
        String id = UUIDUtil.getUUID();
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company  = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setMphone(mphone);
        clue.setAddress(address);
        clue.setWebsite(website);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setContactSummary(contactSummary);
        clue.setDescription(description);
        clue.setPhone(phone);
        clue.setNextContactTime(nextContactTime);

        ClueService cs = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        boolean success = cs.save(clue);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("线索模块，取的用户信息列表进行信息填充");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        PrintJson.printJsonObj(response,uList);
    }
}