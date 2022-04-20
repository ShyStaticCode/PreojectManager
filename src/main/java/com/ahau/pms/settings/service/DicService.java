package com.ahau.pms.settings.service;


import com.ahau.pms.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * Author myh
 */
public interface DicService {
    Map<String, List<DicValue>> getAll();
}
