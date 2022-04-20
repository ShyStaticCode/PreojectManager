<%--
  Created by IntelliJ IDEA.
  User: Lenovo
  Date: 2021/12/24
  Time: 18:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
        String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
        <base href="<%=basePath%>">

    <title>Title</title>
</head>
<body>
        <%--ajax请求--%>

        $.ajax({
        url:"",
        data:{},
        type:"",
        dataType:"",
        success:function (data) {


        }
        })

        //添加时间控件，便利，规范用户的日期输入
        $(".time").datetimepicker({
        minView: "month",
        language:  'zh-CN',
        format: 'yyyy-mm-dd',
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
        });

        <%--创建人和创建时间--%>

        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
</body>
</html>
