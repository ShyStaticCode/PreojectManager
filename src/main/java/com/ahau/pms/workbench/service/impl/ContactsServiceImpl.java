package com.ahau.pms.workbench.service.impl;

import com.ahau.pms.utils.SqlSessionUtil;
import com.ahau.pms.utils.UUIDUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.dao.ContactsDao;
import com.ahau.pms.workbench.dao.ContactsProjectRelationDao;
import com.ahau.pms.workbench.dao.ContactsRemarkDao;
import com.ahau.pms.workbench.domain.ClueProjectRelation;
import com.ahau.pms.workbench.domain.Contacts;
import com.ahau.pms.workbench.domain.ContactsProjectRelation;
import com.ahau.pms.workbench.domain.ContactsRemark;
import com.ahau.pms.workbench.service.ContactsService;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public class ContactsServiceImpl implements ContactsService {
    //联系人相关表
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsProjectRelationDao contactsProjectRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsProjectRelationDao.class);

    @Override
    public boolean deleteList(String[] ids) {
        boolean success = true;
        //查询应该删除的备注的数量
        int count1 = contactsRemarkDao.getCountByCids(ids);
        //与 返回的收到影响的条数  作比较
        int count2 = contactsRemarkDao.deleteByCids(ids);
        if(count1 != count2){
            success = false;
        }
        int count3 = contactsDao.deleteList(ids);
        if (count3 != ids.length) {
            success = false;
        }
        //删除联系人和项目关联关系表中的信息
        //查询关联关系表中的要联系人对应的数据条数
        int count4 = contactsProjectRelationDao.getCountByCids(ids);
        int count5 = contactsProjectRelationDao.deleteContactsByCids(ids);
        if (count4 != count5) {
            success = false;
        }
        return success;
    }

    @Override
    public List<Contacts> getContactsList() {
        List<Contacts> contactsList = contactsDao.getContactsList();
        return contactsList;
    }

    @Override
    public boolean unbund(String id) {
        boolean success = true;
        int count = contactsProjectRelationDao.unbund(id);
        if(count != 1){
            success = false;
        }
        return success;
    }

    @Override
    public boolean bund(String cid, String[] pids) {
        boolean success = true;
        for (String pid : pids) {
            //操作线索—项目关联关系表
            ContactsProjectRelation cpr = new ContactsProjectRelation();
            cpr.setId(UUIDUtil.getUUID());
            cpr.setContactsId(cid);
            cpr.setProjectId(pid);
            //执行添加操作，操作关联关系表
            int count = contactsProjectRelationDao.bund(cpr);
            if (count != 1) {
                success = false;
            }
        }
        return success;
    }

    @Override
    public boolean saveRemark(ContactsRemark cr) {
        boolean success = true;
        int count = contactsRemarkDao.save(cr);
        if (count != 1) {
            success=false;
        }
        return success;
    }

    @Override
    public boolean updateRemark(ContactsRemark cr) {
        boolean success = true;
        int count = contactsRemarkDao.updateRemark(cr);
        if (count != 1) {
            success=false;
        }
        return success;
    }

    @Override
    public boolean deleteRemarkById(String id) {
        boolean success = true;
        int count = contactsRemarkDao.deleteRemarkById(id);
        if (count != 1) {
            success = false;
        }
        return success;
    }

    @Override
    public List<ContactsRemark> getContactsRemarkListById(String contactsId) {
        List<ContactsRemark> crList = contactsRemarkDao.getContactsRemarkListById(contactsId);
        return crList;
    }

    @Override
    public boolean renewContacts(Contacts c) {
        boolean success = true;
        int count = contactsDao.renewContacts(c);
        if (count != 1){
            success=false;
        }
        return success;
    }

    @Override
    public Contacts getContactsById(String id) {
        Contacts contacts = contactsDao.getContactsById(id);
        return contacts;
    }

    @Override
    public boolean save(Contacts contacts) {
        boolean success = true;
        int count = contactsDao.save(contacts);
        if (count != 1) {
            success = false;
        }
        return success;
    }

    @Override
    public PaginationVO<Contacts> pageList(Map<String, Object> map) {
        //拿到total，拿到datalist，分装到vo中，并返回
        int total = contactsDao.getTotalByCondition(map);//根据查询条件得到总条数
        List<Contacts> dataList = contactsDao.getClueListByCondition(map);//查询线索列表集合

        PaginationVO<Contacts> vo = new PaginationVO<Contacts>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public Contacts detail(String id) {
        Contacts contacts = contactsDao.detail(id);
        return contacts;
    }
}
