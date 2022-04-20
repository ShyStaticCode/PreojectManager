package com.ahau.pms.web.filter;

import com.ahau.pms.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Author myh
 */
public class LoginFilter implements Filter {
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        //拦截器，防止恶意登陆
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getServletPath();
        System.out.println(path);
        //不应该被拦截，自动放行
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            chain.doFilter(req,resp);
        }else {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            //不为空，有了session，说明登录过
            if (user != null) {
                chain.doFilter(req,resp);
            }else {
                //session空，重定向
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }
    }

    public void destroy() {}
}
