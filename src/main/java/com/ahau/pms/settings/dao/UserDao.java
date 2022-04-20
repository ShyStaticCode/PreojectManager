package com.ahau.pms.settings.dao;

import com.ahau.pms.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface UserDao {

    User login(Map<String, Object> map);

    int updatePassword(String newPwd,String id);

    List<User> getUserList();

    int register(User user);

    int deleteList(String[] ids);

    User getUser(String id);

    int update(User user);
}
