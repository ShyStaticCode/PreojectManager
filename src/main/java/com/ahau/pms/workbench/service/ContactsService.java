package com.ahau.pms.workbench.service;

import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Contacts;
import com.ahau.pms.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface ContactsService {

    Contacts detail(String id);

    PaginationVO<Contacts> pageList(Map<String, Object> map);

    boolean save(Contacts contacts);

    Contacts getContactsById(String id);

    boolean renewContacts(Contacts c);

    boolean deleteList(String[] ids);

    List<ContactsRemark> getContactsRemarkListById(String contactsId);

    boolean deleteRemarkById(String id);

    boolean updateRemark(ContactsRemark cr);

    boolean saveRemark(ContactsRemark cr);

    boolean bund(String cid, String[] pids);

    boolean unbund(String id);

    List<Contacts> getContactsList();

}
