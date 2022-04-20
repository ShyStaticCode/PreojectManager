package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.Project;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface ProjectDao {
    int save(Project pj);

    int getTotalByCondition(Map<String, Object> map);//查询总条数

    List<Project> getProjectListByCondition(Map<String,Object> map);//查询记录的详细信息

    Project getById(String id);

    int update(Project pj);

    int delete(String[] ids);

    Project detail(String id);

    List<Project> getProjectListByClueId(String clueId);

    List<Project> getProjectListAndNotByClueId(Map<String, String> map);

    List<Project> getProjectListByName(String pname);

    List<Project> getProjectListByContactsId(String contactsId);

    List<Project> getProjectListAndNotByContactsId(Map<String, String> map);

    List<Project> getProjectList();

}
