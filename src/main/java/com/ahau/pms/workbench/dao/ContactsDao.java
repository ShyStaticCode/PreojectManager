package com.ahau.pms.workbench.dao;


import com.ahau.pms.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts contacts);

    Contacts detail(String id);

    int getTotalByCondition(Map<String, Object> map);

    List<Contacts> getClueListByCondition(Map<String, Object> map);

    Contacts getContactsById(String id);

    int renewContacts(Contacts c);

    int deleteList(String[] ids);

    List<Contacts> getContactsList();

}
