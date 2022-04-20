<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="jquery/common.css">
	<link rel="stylesheet" href="jquery/register.css">
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript">
	$(function () {

		//在页面加载完毕后，用户窗口自动获得焦点
		$("#loginAct").focus();
		//给注册按钮绑定事件
		$("#submitBtn").click(function () {
			register();
		})
		//给当前的登录窗口绑定敲键盘事件
		//event:该参数可以拿到我们敲击的那一个键
		$(window).keydown(function (event) {
			if (event.keyCode == 13){
				register();
			}
		})
	})
	function register() {
		var loginAct = $.trim($("#loginAct").val());
		var loginPwd = $.trim($("#password").val());
		var name = $.trim($("#username").val());
		var email = $.trim($("#email").val());
		var deptno = $.trim($("#deptno").val());
		var expireTime = $.trim($("#expireTime").val());
		if (loginAct==""||loginPwd==""||name==""||email==""||deptno==""||expireTime==""){
			alert("信息填写不能为空");
			//如果为空，终止该方法
			return false;
		}
		//后台相关
		$.ajax({
			url:"settings/user/register.do",
			data:{
				"loginAct":loginAct,
				"loginPwd":loginPwd,
				"name" :name,
				"email" :email,
				"deptno": deptno,
				"expireTime":expireTime
			},
			type:"post",
			dataType:"json",
			success:function (data) {
				/*
                *data{"success":true/false,"msg":"出现的问题"}
                *  */
				if (data.success){
					alert("注册成功");
					$(":text").val("");
				}else {
					alert("注册失败");
				}
			}
		})
	}
</script>
</head>
<body>
<!--引入头部-->
<div id="header"></div>
<!-- 头部 end -->
<div class="rg_layout">
	<div class="rg_form clearfix">
		<div class="rg_form_left">
			<p>新用户注册</p>
			<p>USER REGISTER</p>
		</div>
		<div class="rg_form_center">
			<div id="errorMsg" style="text-align: center;color: red"></div>
			<!--注册表单-->
			<form id="registerForm">
				<table style="margin-top: 25px;">
					<tr>
						<td class="td_left">
							<label for="username">用户名</label>
						</td>
						<td class="td_right">
							<input type="text" id="username" name="username" placeholder="请输入真实姓名">
						</td>
					</tr>
					<tr>
						<td class="td_left">
							<label for="loginAct">账号</label>
						</td>
						<td class="td_right">
							<input type="text" id="loginAct" name="loginAct" placeholder="请输入账号">
						</td>
					</tr>
					<tr>
						<td class="td_left">
							<label for="password">密码</label>
						</td>
						<td class="td_right">
							<input type="text" id="password" name="password" placeholder="请输入密码">
						</td>
					</tr>
					<tr>
						<td class="td_left">
							<label for="email">Email</label>
						</td>
						<td class="td_right">
							<input type="text" id="email" name="email" placeholder="请输入Email">
						</td>
					</tr>
					<tr>
						<td class="td_left">
							<label for="deptno">部门编号</label>
						</td>
						<td class="td_right">
							<input type="text" id="deptno" name="deptno" placeholder="请输入您的部门编号">
						</td>
					</tr>
					<tr>
						<td class="td_left">
							<label for="expireTime">有效期限</label>
						</td>
						<td class="td_right">
							<input type="date" id="expireTime" name="expireTime" placeholder="年/月/日">
						</td>
					</tr>
					<tr>
						<td class="td_left">
						</td>
						<td class="td_right check">
							<button type="button" id="submitBtn" class="submit">注册</button>
							<span id="msg" style="color: red;"></span>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="rg_form_right">
			<p>
				账户信息请认真填写，点击注册。
			</p>
		</div>
	</div>
</div>
<!--引入尾部-->
<div id="footer"></div>
<!--导入布局js，共享header和footer-->
<script type="text/javascript" src="jquery/include.js"></script>
</body>
</html>