package com.ahau.pms.settings.web.controller;


import com.ahau.pms.settings.domain.User;
import com.ahau.pms.settings.service.UserService;
import com.ahau.pms.settings.service.impl.UserServiceImpl;
import com.ahau.pms.utils.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Author myh
 */
public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到用户控制器");
        String path = request.getServletPath();
        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }else if ("/settings/user/updatePassword.do".equals(path)){
            updatePassword(request,response);
        }else if ("/settings/user/register.do".equals(path)){
            register(request,response);
        }else if ("/setting/user/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if ("/setting/user/deleteList.do".equals(path)){
            deleteList(request,response);
        }else if ("/setting/user/getUser.do".equals(path)){
            getUser(request,response);
        }else if ("/setting/user/update.do".equals(path)){
            update(request,response);
        }

    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行个信息的修改操作");
        String id = request.getParameter("id");
        String loginAct = request.getParameter("loginAct");
        String name = request.getParameter("name");
        String loginPwd = MD5Util.getMD5(request.getParameter("loginPwd"));
        String email = request.getParameter("email");
        String expireTime = request.getParameter("expireTime");
        String lockState = request.getParameter("lockState");
        String deptno = request.getParameter("deptno");
        String allowIps = request.getParameter("allowIps");
        String editTime =DateTimeUtil.getSysTime();
        User user = (User) request.getSession().getAttribute("user");
        String editBy = user.getName();
        User use = new User();
        use.setId(id);
        use.setLockState(lockState);
        use.setLoginAct(loginAct);
        use.setAllowIps(allowIps);
        use.setEditBy(editBy);
        use.setEditTime(editTime);
        use.setName(name);
        use.setExpireTime(expireTime);
        use.setEmail(email);
        use.setDeptno(deptno);
        use.setLoginPwd(loginPwd);
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        boolean success = us.update(use);
        PrintJson.printJsonFlag(response,success);

    }

    private void getUser(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据ID查单个用户信息");
        String id = request.getParameter("id");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        User user = us.getUser(id);
        PrintJson.printJsonObj(response,user);
    }

    private void deleteList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行用户信息删除操作");
        String ids[] = request.getParameterValues("id");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        boolean success = us.deleteList(ids);
        PrintJson.printJsonFlag(response,success);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行用户信息预览的操作");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = us.getUserList();
        PrintJson.printJsonObj(response,userList);
    }

    private void register(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("用户注册");

        String id = UUIDUtil.getUUID();
        String lockState = "1";
        String allowIps = request.getRemoteAddr();
        String createTime = DateTimeUtil.getSysTime();
        User user = (User) request.getSession().getAttribute("user");
        String createBy =user.getName();
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String deptno = request.getParameter("deptno");
        String expireTime = request.getParameter("expireTime");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = MD5Util.getMD5(request.getParameter("loginPwd"));
        User use = new User();
        use.setId(id);
        use.setLockState(lockState);
        use.setLoginAct(loginAct);
        use.setAllowIps(allowIps);
        use.setCreateBy(createBy);
        use.setCreateTime(createTime);
        use.setName(name);
        use.setExpireTime(expireTime);
        use.setEmail(email);
        use.setDeptno(deptno);
        use.setLoginPwd(loginPwd);
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        boolean success = us.register(use);
        PrintJson.printJsonFlag(response,success);
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进来了修改密码的界面");
        User user = (User) request.getSession().getAttribute("user");
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        String id = user.getId();
        String loginPwd = user.getLoginPwd();
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");
        newPwd = MD5Util.getMD5(newPwd);
        System.out.println("新密码"+newPwd);
        oldPwd = MD5Util.getMD5(oldPwd);
        if (loginPwd.equals(oldPwd)){
            Boolean success = us.updatePassword(newPwd,id);
            PrintJson.printJsonFlag(response,success);
        }else {
            Boolean success = false;
            PrintJson.printJsonFlag(response,success);
        }

    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("登录成功");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码转换为MD5的密文格式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接受IP地址
        String ip = request.getRemoteAddr();
        System.out.println("这是本机的IP地址:"+ip);
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        try {
            User user = us.login(loginAct,loginPwd,ip);
            request.getSession().setAttribute("user",user);

            //如果成功，返回{success:true}
            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            e.printStackTrace();
            String message = e.getMessage();
            //如果失败，返回{success:false,msg:错误信息}

            /*创建一个VO，制作一个对象
                    private boolean success;
                    private String msg;
             */
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",message);
            PrintJson.printJsonObj(response,map);
        }
    }
}
