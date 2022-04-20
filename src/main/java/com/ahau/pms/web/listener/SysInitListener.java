package com.ahau.pms.web.listener;


import com.ahau.pms.settings.domain.DicValue;
import com.ahau.pms.settings.service.DicService;
import com.ahau.pms.settings.service.impl.DicServiceImpl;
import com.ahau.pms.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Author myh
 */
public class SysInitListener implements ServletContextListener {

    /**
     * 该方法是用来监听上下文域对象的方法，当服务器启动，上下域对象
     * 创建，对象创建完毕，马上执行该方法。
     * @param event
     * event  ：该参数能够取得监听的对象
     *      监听什么对象，就能通过该参数获得什么对象
     */
    public void contextInitialized(ServletContextEvent event) {
        //System.out.println("上下文域对象创建了");

        System.out.println("服务器缓存处理数据字典开始");

        ServletContext application = event.getServletContext();
        //取数据字典
        DicService ds = (DicService) ServiceFactory.getService(new DicServiceImpl());
        /*
        * 向业务层索要7个List对象
        * 打包放到map中
        * */
        Map<String, List<DicValue>> map = ds.getAll();
        //将map解析为上下文域对象中保存的键值对
        Set<String> set = map.keySet();
        for (String key : set){
            application.setAttribute(key,map.get(key));
        }
        System.out.println("服务器缓存处理数据字典结束");
    }

}
