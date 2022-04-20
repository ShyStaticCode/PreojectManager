package com.ahau.pms.workbench.service.impl;

import com.ahau.pms.settings.dao.UserDao;
import com.ahau.pms.settings.domain.User;
import com.ahau.pms.utils.DateTimeUtil;
import com.ahau.pms.utils.SqlSessionUtil;
import com.ahau.pms.utils.UUIDUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.dao.*;
import com.ahau.pms.workbench.domain.*;
import com.ahau.pms.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Author myh
 */
public class ClueServiceImpl implements ClueService {
    //用户表相关
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    //线索相关表
    private ClueDao clueDao = SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueProjectRelationDao clueProjectRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueProjectRelationDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    //客户相关表
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    //联系人相关表
    private ContactsDao contactsDao = SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsProjectRelationDao contactsProjectRelationDao = SqlSessionUtil.getSqlSession().getMapper(ContactsProjectRelationDao.class);
    //交易相关的表
    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);


    @Override
    public boolean convert(String clueId, Tran t, String createBy) {
        String createTime = DateTimeUtil.getSysTime();
        boolean success = true;
        //通过线索的id的查询线索的详细信息
        Clue clue = clueDao.getById(clueId);
        //通过线索对象，提取客户信息，如果客户不存在就创建新的客户(根据公司名称精确匹配(sql中使用==号判断)客户是否存在)
        String company = clue.getCompany();
        //客户的名字即就是线索的公司名
        Customer customer = customerDao.getCustomerByName(company);
        //如果customer为空，需要新建
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(clue.getAddress());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setOwner(clue.getOwner());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setName(company);
            customer.setDescription(clue.getDescription());
            customer.setCreateTime(createTime);
            customer.setCreateBy(createBy);
            customer.setContactSummary(clue.getContactSummary());
            //添加客户
            int count1 = customerDao.save(customer);
            if (count1 != 1) {
                success = false;
            }
        }
        //经过第二步骤处理之后，客户表已经被创建，之后的环节若是用到，直接用get方法获取

        //通过线索对象，提取联系人的的信息，保存联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        //添加联系人
        int count2 = contactsDao.save(contacts);
        if (count2 != 1) {
            success = false;
        }
        //联系人处理结束，以后若是用到联系人直接使用get即可
        //线索备注转换到客户备注和联系人备注中去
        //查询到和该线索关联的备注信息列表，根据clueId来查询
        List<ClueRemark> clueRemarkList = clueRemarkDao.getListByClueId(clueId);
        for (ClueRemark clueRemark : clueRemarkList) {
            //取出每一条线索备注，存到联系人和客户中去*主要转换的是备注信息
            String noteContent = clueRemark.getNoteContent();
            //创建客户备注对象，添加客户备注信息
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(createTime);
            customerRemark.setEditFlag("0");
            customerRemark.setNoteContent(noteContent);
            int count3 = customerRemarkDao.save(customerRemark);
            if (count3 != 1) {
                success = false;
            }
            //创建联系人备注对象，添加联系人备注信息
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setEditFlag("0");
            contactsRemark.setNoteContent(noteContent);
            int count4 = contactsRemarkDao.save(contactsRemark);
            if (count4 != 1) {
                success = false;
            }
        }
        //查询出于该条线索相关联的市场活动，查询项目信息和线索的关联关系表
        List<ClueProjectRelation> clueProjectRelationList = clueProjectRelationDao.getListByClueId(clueId);
        for (ClueProjectRelation clueProjectRelation : clueProjectRelationList) {
            //从每一条遍历出来的记录中取出相关联的市场活动id
            String projectId = clueProjectRelation.getProjectId();
            //创建 联系人和市场活动关联关系对象，添加联系人市场活动关联关系表
            ContactsProjectRelation contactsProjectRelation = new ContactsProjectRelation();
            contactsProjectRelation.setId(UUIDUtil.getUUID());
            contactsProjectRelation.setProjectId(projectId);
            contactsProjectRelation.setContactsId(contacts.getId());
            int count5 = contactsProjectRelationDao.save(contactsProjectRelation);
            if (count5 != 1) {
                success = false;
            }
        }
        //判断交易的对象是否为空，如果不为空，需要创建一条交易
        if (t != null) {
            /*
            t(交易对象)已经在controller中存放了很多信息
            ActivityId,CreateBy,CreateTime,ExpectedDate,Money,Name,Id,Stage，
            通过第一步生成的clue对象，取出一些信息，继续完善对t(交易对象)有用的信息
             */
            t.setSource(clue.getSource());
            t.setOwner(clue.getOwner());
            t.setNextContactTime(clue.getNextContactTime());
            t.setDescription(clue.getDescription());
            t.setCustomerId(customer.getId());
            t.setContactSummary(contacts.getContactSummary());
            t.setContactsId(contacts.getId());
            //添加交易
            int count6 = tranDao.save(t);
            if (count6 != 1) {
                success = false;
            }
            //若是有交易创建，就生成一个交易历史，，一条交易可以创建多条交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setTranId(t.getId());
            tranHistory.setExpectedDate(t.getExpectedDate());
            tranHistory.setMoney(t.getMoney());
            tranHistory.setStage(t.getStage());
            //添加交易历史
            int count7 = tranHistoryDao.save(tranHistory);
            if (count7 != 1) {
                success = false;
            }
        }
        //删除线索的备注
        for (ClueRemark clueRemark : clueRemarkList){
            int count8 = clueRemarkDao.delete(clueRemark);
            if (count8 != 1) {
                success = false;
            }
        }
        //删除市场活动和线索的关联关系
        for (ClueProjectRelation clueProjectRelation : clueProjectRelationList){
            int count9 = clueProjectRelationDao.delete(clueProjectRelation);
            if (count9 != 1) {
                success = false;
            }
        }
        //删除线索(clueId即就是线索表的Id值)
        int count10 = clueDao.deleteByClueId(clueId);
        if (count10 != 1) {
            success = false;
        }
        return success;
    }

    @Override
    public boolean save(Clue clue) {
        boolean success = true;
        int count = clueDao.save(clue);
        if(count !=1 ){
            success = false;
        }
        return success;
    }

    @Override
    public PaginationVO<Clue> pageList(Map<String, Object> map) {
        //拿到total，拿到datalist，分装到vo中，并返回
        int total = clueDao.getTotalByCondition(map);//根据查询条件得到总条数
        List<Clue> dataList = clueDao.getClueListByCondition(map);//查询线索列表集合

        PaginationVO<Clue> vo = new PaginationVO<Clue>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public Clue detail(String id) {
        Clue clue = clueDao.detail(id);
        return clue;
    }

    @Override
    public Map<String, Object> getUserClue(String id) {
        //拿到uList
        List<User> uList = userDao.getUserList();
        //拿到a
        Clue c = clueDao.getById(id);
        //放到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("c",c);
        //返回map,
        return map;
    }

    @Override
    public boolean renewClue(Clue clue) {
        boolean success = true;
        int count = clueDao.renewClue(clue);
        if(count !=1 ){
            success = false;
        }
        return success;
    }

    @Override
    public boolean deleteList(String[] ids) {
        boolean success = true;
        //查询应该删除的备注的数量
        int count1 = clueRemarkDao.getCountByCids(ids);
        //与 返回的收到影响的条数  作比较
        int count2 = clueRemarkDao.deleteByCids(ids);
        if(count1 != count2){
            success = false;
        }
        //删除项目线索记录
        int count3 = clueDao.delete(ids);
        if (count3 != ids.length){
            success = false;
        }
        //删除项目线索和项目关联关系表中的信息
            //查询关联关系表中的要删除的线索对应的数据条数
            int count4 = clueProjectRelationDao.getCountByCids(ids);
            int count5 = clueProjectRelationDao.deleteClueByCids(ids);
        if (count4 != count5) {
            success = false;
        }
        return success;

    }

    @Override
    public List<ClueRemark> getClueRemarkListById(String clueId) {
        List<ClueRemark> crList = clueRemarkDao.getClueRemarkListById(clueId);
        return crList;
    }

    @Override
    public boolean saveRemark(ClueRemark cr) {
        boolean success = false;
        int count = clueRemarkDao.saveRemark(cr);
        if(count == 1){
            success = true;
        }
        return success;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean success = false;
        int count =clueRemarkDao.deleteRemark(id);
        if(count == 1){
            success = true;
        }
        return success;
    }

    @Override
    public boolean updateRemark(ClueRemark cr) {
        boolean success = false;
        int count = clueRemarkDao.updateRemark(cr);
        if(count==1){
            success=true;
        }
        return success;
    }

    @Override
    public boolean unbund(String id) {
        boolean success = true;
        int count = clueProjectRelationDao.unbund(id);
        if(count !=1 ){
            success = false;
        }
        return success;
    }

    @Override
    public boolean bund(String cid, String[] pids) {
        boolean success = true;
        for (String pid : pids) {
            //操作线索—项目关联关系表
            ClueProjectRelation cpr = new ClueProjectRelation();
            cpr.setId(UUIDUtil.getUUID());
            cpr.setClueId(cid);
            cpr.setProjectId(pid);
            //执行添加操作，操作关联关系表
            int count = clueProjectRelationDao.bund(cpr);
            if (count != 1) {
                success = false;
            }
        }
        return success;
    }
}