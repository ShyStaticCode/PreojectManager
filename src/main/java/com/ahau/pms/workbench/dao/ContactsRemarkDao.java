package com.ahau.pms.workbench.dao;


import com.ahau.pms.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkDao {

    int save(ContactsRemark contactsRemark);

    List<ContactsRemark> getContactsRemarkListById(String contactsId);

    int deleteRemarkById(String id);

    int updateRemark(ContactsRemark cr);

    int getCountByCids(String[] ids);

    int deleteByCids(String[] ids);

}
