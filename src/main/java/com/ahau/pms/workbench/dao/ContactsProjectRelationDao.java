package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.ContactsProjectRelation;

public interface ContactsProjectRelationDao {

    int save(ContactsProjectRelation contactsProjectRelation);

    int bund(ContactsProjectRelation cpr);

    int unbund(String id);

    int getCountByCids(String[] ids);

    int deleteContactsByCids(String[] ids);

}
