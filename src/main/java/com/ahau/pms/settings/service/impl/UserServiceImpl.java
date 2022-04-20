package com.ahau.pms.settings.service.impl;


import com.ahau.pms.exception.LoginException;
import com.ahau.pms.settings.dao.UserDao;
import com.ahau.pms.settings.domain.User;
import com.ahau.pms.settings.service.UserService;
import com.ahau.pms.utils.DateTimeUtil;
import com.ahau.pms.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public class UserServiceImpl implements UserService {

    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,Object> map =  new HashMap<String, Object>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        User user = userDao.login(map);
        if (user == null) {
            throw new LoginException("账号密码错误");
        }
        //若程序执行到此，则账号密码正确，验证其余三项信息
        //失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("账户登录信息已失效");
        }
        //验证锁状态
        String lockStack = user.getLockState();
        if ("0".equals(lockStack)){
            throw new LoginException("账号已锁定，请联系客服");
        }
        //ip地址
        String allowIps = user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("ip地址受限，请联系客服");
        }
        return user;
    }

    @Override
    public Boolean updatePassword(String newPwd,String id) {
        Boolean success = false;
        int count = userDao.updatePassword(newPwd,id);
        System.out.println(count);
        if (count == 1 ){
            success=true;
        }
        return success;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList = userDao.getUserList();
        return userList;
    }

    @Override
    public boolean register(User user) {
        boolean success = true;
        int count = userDao.register(user);
        if (count != 1 ){
            success=false;
        }
        return success;
    }

    @Override
    public boolean deleteList(String[] ids) {
        boolean success = false;
        int count = userDao.deleteList(ids);
        if (count == ids.length){
            success = true;
        }
        return success;
    }

    @Override
    public User getUser(String id) {
        User u = userDao.getUser(id);
        return u;
    }

    @Override
    public boolean update(User user) {
        boolean success = true;
        int count = userDao.update(user);
        if (count != 1 ){
            success=false;
        }
        return success;
    }

}
