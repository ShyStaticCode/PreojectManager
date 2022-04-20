package com.ahau.pms.workbench.service;

import com.ahau.pms.vo.PaginationVO;
import com.ahau.pms.workbench.domain.Project;
import com.ahau.pms.workbench.domain.ProjectRemark;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface ProjectService {

    boolean save(Project pj);

    PaginationVO<Project> pageList(Map<String, Object> map);

    Map<String, Object> getUserProject(String id);

    boolean update(Project pj);

    boolean deleteList(String[] ids);

    Project detail(String id);

    List<ProjectRemark> getRemarkListById(String projectId);

    boolean saveRemark(ProjectRemark pr);

    boolean updateRemark(ProjectRemark pr);

    boolean deleteRemark(String id);

    List<Project> getProjectListByClueId(String clueId);

    List<Project> getProjectListAndNotByClueId(Map<String, String> map);

    List<Project> getProjectListByName(String pname);

    List<Project> getProjectListByContactsId(String contactsId);

    List<Project> getProjectListAndNotByContactsId(Map<String, String> map);

    List<Project> getProjectList();

}
