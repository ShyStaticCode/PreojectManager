package com.ahau.pms.vo;

import java.util.List;

/**
 * Author myh
 */
public class PaginationVO<T> {

    private int total;//记录总条数
    private List<T> dataList;//每条记录的详细信息


    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
