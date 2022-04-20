package com.ahau.pms.settings.dao;


import com.ahau.pms.settings.domain.DicValue;

import java.util.List;

/**
 * Author myh
 */
public interface DicValueDao {
    List<DicValue> getListByCode(String code);
}
