package com.ahau.pms.workbench.service.impl;

import com.ahau.pms.settings.dao.UserDao;
import com.ahau.pms.settings.domain.User;
import com.ahau.pms.utils.SqlSessionUtil;
import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.dao.ClueProjectRelationDao;
import com.ahau.pms.workbench.dao.ProjectDao;
import com.ahau.pms.workbench.dao.ProjectRemarkDao;
import com.ahau.pms.workbench.domain.Project;
import com.ahau.pms.workbench.domain.ProjectRemark;
import com.ahau.pms.workbench.service.ProjectService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public class ProjectServiceImpl implements ProjectService {

    private ProjectDao projectDao = SqlSessionUtil.getSqlSession().getMapper(ProjectDao.class);

    private ProjectRemarkDao projectRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ProjectRemarkDao.class);

    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    private ClueProjectRelationDao clueProjectRelationDao = SqlSessionUtil.getSqlSession().getMapper(ClueProjectRelationDao.class);
    @Override
    public boolean save(Project pj) {
        boolean success = true;
        int count = projectDao.save(pj);
        if (count != 1){
            success = false;
        }
        return success;
    }

    @Override
    public PaginationVO<Project> pageList(Map<String,Object> map) {
        //拿到total，拿到datalist，分装到vo中，并返回
        int total = projectDao.getTotalByCondition(map);//根据查询条件得到总条数
        List<Project> dataList = projectDao.getProjectListByCondition(map);

        PaginationVO<Project> vo = new PaginationVO<Project>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public Map<String, Object> getUserProject(String id) {
        //拿到uList
        List<User> uList = userDao.getUserList();
        //拿到a
        Project a = projectDao.getById(id);
        //放到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",a);
        //返回map,
        return map;
    }

    @Override
    public boolean update(Project pj) {
        boolean success = true;
        int count = projectDao.update(pj);
        if (count != 1){
            success = false;
        }
        return success;
    }

    @Override
    public boolean deleteList(String[] ids) {
        boolean success = true;

        //查询应该删除的备注的数量
        int count1 = projectRemarkDao.getCountByAids(ids);
        //与 返回的收到影响的条数  作比较
        int count2 = projectRemarkDao.deleteByAids(ids);

        if(count1 != count2){
            success = false;
        }
        //删除项目信息
        int count3 = projectDao.delete(ids);
        if (count3 != ids.length){
            success = false;
        }
        //删除项目线索和项目关联关系表中的信息
            //查询关联关系表中的要删除的线索对应的数据条数
            int count4 = clueProjectRelationDao.getCountBypids(ids);
            int count5 = clueProjectRelationDao.deleteProjectBypids(ids);
            if (count4 != count5) {
                success = false;
            }
        return success;
    }

    @Override
    public Project detail(String id) {
        Project p = projectDao.detail(id);
        return p;
    }

    @Override
    public List<ProjectRemark> getRemarkListById(String projectId) {
        List<ProjectRemark> prList = projectRemarkDao.getRemarkListById(projectId);
        return prList;
    }

    @Override
    public boolean saveRemark(ProjectRemark pr) {
        boolean success = false;
        int count = projectRemarkDao.saveRemark(pr);
        if(count == 1){
            success = true;
        }
        return success;
    }

    @Override
    public boolean updateRemark(ProjectRemark pr) {
        boolean success = false;
        int count = projectRemarkDao.updateRemark(pr);
        if(count==1){
            success=true;
        }
        return success;
    }

    @Override
    public List<Project> getProjectList() {
        List<Project> projectsList = projectDao.getProjectList();
        return projectsList;
    }

    @Override
    public List<Project> getProjectListAndNotByContactsId(Map<String, String> map) {
        List<Project> pList = projectDao.getProjectListAndNotByContactsId(map);
        return pList;
    }

    @Override
    public List<Project> getProjectListByContactsId(String contactsId) {
        List<Project> pList = projectDao.getProjectListByContactsId(contactsId);
        return pList;
    }

    @Override
    public List<Project> getProjectListByClueId(String clueId) {
        List<Project> pList = projectDao.getProjectListByClueId(clueId);
        return pList;
    }

    @Override
    public List<Project> getProjectListByName(String pname) {
        List<Project> pList = projectDao.getProjectListByName(pname);
        return pList;
    }

    @Override
    public List<Project> getProjectListAndNotByClueId(Map<String, String> map) {
        List<Project> pList = projectDao.getProjectListAndNotByClueId(map);
        return pList;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean success = false;
        int count = projectRemarkDao.deleteRemark(id);
        if(count == 1){
            success = true;
        }
        return success;
    }
}
