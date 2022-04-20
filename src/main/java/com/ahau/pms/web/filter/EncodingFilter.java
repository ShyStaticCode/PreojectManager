package com.ahau.pms.web.filter;

import javax.servlet.*;
import java.io.IOException;

/**
 * Author myh
 */
public class EncodingFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        //过滤login的字符乱码问题
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8;");

        //放行
        chain.doFilter(req,resp);
    }

    public void init(FilterConfig filterConfig) throws ServletException {}
    public void destroy() {}
}
