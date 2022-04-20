package com.ahau.pms.settings.service;

import com.ahau.pms.exception.LoginException;
import com.ahau.pms.settings.domain.User;

import java.util.List;

/**
 * Author myh
 */
public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    Boolean updatePassword(String newPwd,String id);

    List<User> getUserList();

    boolean register(User use);

    boolean deleteList(String[] ids);

    User getUser(String id);

    boolean update(User user);

}
