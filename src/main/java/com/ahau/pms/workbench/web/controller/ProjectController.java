package com.ahau.pms.workbench.web.controller;

import com.ahau.pms.settings.domain.User;
import com.ahau.pms.settings.service.UserService;
import com.ahau.pms.settings.service.impl.UserServiceImpl;
import com.ahau.pms.utils.DateTimeUtil;
import com.ahau.pms.utils.PrintJson;
import com.ahau.pms.utils.ServiceFactory;
import com.ahau.pms.utils.UUIDUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Project;
import com.ahau.pms.workbench.domain.ProjectRemark;
import com.ahau.pms.workbench.service.ProjectService;
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
public class ProjectController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到项目管理控制器");
        String path = request.getServletPath();
        if ("/workbench/project/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if ("/workbench/project/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/project/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/project/getUserProject.do".equals(path)){
            getUserProject(request,response);
        }else if ("/workbench/project/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/project/deleteList.do".equals(path)){
            deleteList(request,response);
        }else if ("/workbench/project/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/project/getRemarkListById.do".equals(path)){
            getRemarkListById(request,response);
        }else if ("/workbench/project/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if ("/workbench/project/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if ("/workbench/project/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }

    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除项目备注的操作");
        String id = request.getParameter("id");
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        boolean success =  ps.deleteRemark(id);
        PrintJson.printJsonFlag(response,success);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行项目备注更新操作");
        String id = request.getParameter("id");
        String noteContent = request.getParameter("noteContent");
        //修改时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editFlag = "1";
        ProjectRemark pr = new ProjectRemark();
        pr.setEditFlag(editFlag);
        pr.setId(id);
        pr.setNoteContent(noteContent);
        pr.setEditTime(editTime);
        pr.setEditBy(editBy);
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        boolean success = ps.updateRemark(pr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("ar",pr);
        PrintJson.printJsonObj(response,map);
    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("保存项目的备注信息");
        System.out.println("执行添加备注的操作");
        String noteContent = request.getParameter("noteContent");
        String projectId = request.getParameter("projectId");
        String id = UUIDUtil.getUUID();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String editFlag = "0";
        ProjectRemark pr = new ProjectRemark();
        pr.setId(id);
        pr.setNoteContent(noteContent);
        pr.setProjectId(projectId);
        pr.setCreateTime(createTime);
        pr.setCreateBy(createBy);
        pr.setEditFlag(editFlag);
        ProjectService ps = (ProjectService)ServiceFactory.getService(new ProjectServiceImpl());
        boolean success = ps.saveRemark(pr);
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("ar",pr);
        PrintJson.printJsonObj(response,map);
    }

    private void getRemarkListById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据项目信息id查询备注列表");
        String projectId = request.getParameter("projectId");
        ProjectService ac = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        List<ProjectRemark> prList = ac.getRemarkListById(projectId);
        PrintJson.printJsonObj(response,prList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到项目信息详情页");
        String id = request.getParameter("id");
        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());

        Project p = ps.detail(id);
        request.setAttribute("a",p);
        //重定向
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    private void deleteList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行删除项目信息的操作");
        String ids[] = request.getParameterValues("id");

        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        boolean success = ps.deleteList(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改项目信息界面");
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        //修改时间
        String editTime = DateTimeUtil.getSysTime();
        //修改人
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Project pj = new Project();
        pj.setId(id);
        pj.setOwner(owner);
        pj.setName(name);
        pj.setStartDate(startDate);
        pj.setEndDate(endDate);
        pj.setCost(cost);
        pj.setDescription(description);
        pj.setEditTime(editTime);
        pj.setEditBy(editBy);

        ProjectService as = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        boolean success = as.update(pj);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserProject(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询用户信息列表和根据项目信息id查询单条记录的操作");
        String id = request.getParameter("id");

        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        //前端需要uList    和   a
        Map<String,Object> map = ps.getUserProject(id);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询的界面，执行分页插件的查询操作。");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo-1)*pageSize;
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ProjectService as = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        /*
         * 前端需要的数据类型:{ "total":100,"dataList":[{市场活动1},{},{}] }
         * 我们可以使用VO类进行
         * 两相比较，在以后的业务中也较多次数需要用到VO，则选用VO进行封装
         * */
        PaginationVO<Project> vo = as.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取创建项目信息模态窗口的值");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Project pj = new Project();
        pj.setId(id);
        pj.setOwner(owner);
        pj.setName(name);
        pj.setStartDate(startDate);
        pj.setEndDate(endDate);
        pj.setCost(cost);
        pj.setDescription(description);
        pj.setCreateTime(createTime);
        pj.setCreateBy(createBy);

        ProjectService ps = (ProjectService) ServiceFactory.getService(new ProjectServiceImpl());
        boolean success = ps.save(pj);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("查询用户信息列表");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
       List<User> userList = us.getUserList();
        PrintJson.printJsonObj(response,userList);

    }
}
