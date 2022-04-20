package com.ahau.pms.settings.service.impl;

import com.ahau.pms.settings.dao.DicTypeDao;
import com.ahau.pms.settings.dao.DicValueDao;
import com.ahau.pms.settings.domain.DicType;
import com.ahau.pms.settings.domain.DicValue;
import com.ahau.pms.settings.service.DicService;
import com.ahau.pms.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public class DicServiceImpl implements DicService {
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);

    private DicValueDao dicValueDao = SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);

    public Map<String, List<DicValue>> getAll() {
        Map<String, List<DicValue>> map = new HashMap<String, List<DicValue>>();
        //将字典的类项列表取出
        List<DicType> dtList = dicTypeDao.getTypeList();

        //将字类型的列表遍历
        for (DicType dt : dtList){
            //取的每一种类型的字典类型编码
            String code = dt.getCode();

            //根据每一个字典类型来取得字典值列表
            List<DicValue> dvList = dicValueDao.getListByCode(code);
            map.put(code+"List",dvList);
        }
        return map;

    }
}
