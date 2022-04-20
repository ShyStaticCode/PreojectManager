package com.ahau.pms.workbench.dao;

import com.ahau.pms.workbench.domain.ProjectRemark;

import java.util.List;

/**
 * Author myh
 */
public interface ProjectRemarkDao {

    int getCountByAids(String[] ids);

    int deleteByAids(String[] ids);

    List<ProjectRemark> getRemarkListById(String projectId);

    int saveRemark(ProjectRemark pr);

    int updateRemark(ProjectRemark pr);

    int deleteRemark(String id);
}
