<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript">
	$(function () {
		//界面加载完毕，刷新界面
		getUserList();
		//添加时间控件，便利，规范用户的日期输入
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});
		//给复选框绑定事件，触发全选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#userList").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		})
		//给删除按钮绑定事件，执行项目信息的删除操作
		$("#deleteBtn").click(function () {
			//找到复选框中所有选中的jquery对象
			var $xz = $("input[name=xz]:checked");
			if ($xz.length==0){
				alert("请选择需要删除的记录");
			}else {
				if (confirm("确认删除选中内容吗？")){
					//拼接需要发送的参数信息
					var param = "";
					for (var i =0;i<$xz.length;i++){
						param += "id="+$($xz[i]).val();
						if(i < $xz.length-1){
							param += "&";
						}
					}
					//alert(param);
					$.ajax({
						url:"setting/user/deleteList.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							//返回一个标记就可以了
							if(data.success){
								//TRUE
								alert("删除成功");
								getUserList();
							}else {
								//false
								alert("删除失败");
							}
						}
					})
				}
			}
		})
		//给修改按钮绑定单机事件
		$("#editBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择需要修改的记录");
			}else if($xz.length>1){
				alert("只能选择一条记录");
			}else {
				//做相关操作
				var id = $xz.val();
				//alert(id);
				$.ajax({
					url:"setting/user/getUser.do",
					data:{"id" : id},
					type:"post",
					dataType:"json",
					success:function (data) {
						//alert(data);
						//需要的数据，用户列表user
						$("#edit-id").val(data.id);
						$("#edit-name").val(data.name);
						$("#edit-loginAct").val(data.loginAct);
						$("#edit-loginPwd").val(data.loginPwd);
						$("#edit-email").val(data.email);
						$("#edit-expireTime").val(data.expireTime);
						$("#edit-lockState").val(data.lockState);
						$("#edit-deptno").val(data.deptno);
						$("#edit-allowIps").val(data.allowIps);
						//值处理完毕，打开模态窗口
						$("#editUserModal").modal("show");
					}
				})
			}
		})
		//给更新按钮绑定事件，执行修改
		$("#updateBtn").click(function () {
			$.ajax({
				url :"setting/user/update.do",
				data : {
					"id" : $.trim($("#edit-id").val()),
					"loginAct":$.trim($("#edit-loginAct").val()),
					"name":$.trim($("#edit-name").val()),
					"loginPwd":$.trim($("#edit-loginPwd").val()),
					"email":$.trim($("#edit-email").val()),
					"expireTime":$.trim($("#edit-expireTime").val()),
					"lockState":$.trim($("#edit-lockState").val()),
					"deptno":$.trim($("#edit-deptno").val()),
					"allowIps":$.trim($("#edit-allowIps").val())
				},
				type: "post",
				dataType: "json",
				success : function (date) {
					//返回一个更新成功与否的标志
					if(date.success){
						//添加成功
						alert("修改个人信息成功");
						//局部刷新，市场活动信息列表
						//pageList(1,5);
						getUserList();
						$("#editUserModal").modal("hide");
					}else {
						alert("修改个人信息失败");
						//关闭模态窗口
						$("#createUserModal").modal("hide");
					}
				}
			})
		})
	})
		function getUserList() {
			$.ajax({
				url:"setting/user/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					/*
					* 索要用户信息列表
					* data:json数组[{id:?,name:?,loginAct:?......},{},{}]
					* */
					var html = "";
					//遍历json数组
					$.each(data,function (index,n) {
					html += '<tr style="color: #000000;">';
					html+= '<td><input type="checkbox" name="xz" value="'+n.id+'" /></td>';
					html += '<td>'+n.name+'</td>';
					html += '<td>'+n.loginAct+'</td>';
					html += '<td>'+n.email+'</td>';
					html += '<td>'+n.expireTime+'</td>';
					html += '<td>'+n.lockState+'</td>';
					html += '<td>'+n.deptno+'</td>';
					html += '<td>'+n.allowIps+'</td>';
					html += '</tr>';
					})
					$("#userList").html(html);
				}
			})
		}
	</script>
</head>
<body>
<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editUserModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel2">修改个人用户信息</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<input type="hidden" id="edit-id">
					<div class="form-group">
						<label for="edit-marketUserOwner" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input class="form-control" id="edit-name">
						</div>
						<label for="edit-marketUserName" class="col-sm-2 control-label">账号<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-loginAct">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-marketUserName" class="col-sm-2 control-label">密码<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-loginPwd">
						</div>
						<label for="edit-marketUserName" class="col-sm-2 control-label">邮箱<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-endDate" class="col-sm-2 control-label">有效期限</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="edit-expireTime" readonly>
						</div>
						<label for="edit-marketUserName" class="col-sm-2 control-label">锁定状态<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-lockState" placeholder="1或者0">
						</div>
					</div>
					<div class="form-group">
						<label for="edit-marketUserName" class="col-sm-2 control-label">部门编号<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-deptno">
						</div>
						<label for="edit-marketUserName" class="col-sm-2 control-label">允许IP<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-allowIps">
						</div>
					</div>

				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			</div>
		</div>
	</div>
</div>
<div align="center">
	<p><h2>用户信息列表</h2></p>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
		<div class="btn-group" style="position: relative; top: 18%;">
			<button type="button" class="btn btn-default" data-toggle="modal" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<table class="table table-hover" border="1">
		<thead>
		<tr style="color: #0410a8;" align="center">
			<td><input type="checkbox" id="qx"/></td>
			<td>姓名</td>
			<td>账号</td>
			<td>邮箱</td>
			<td>有效期</td>
			<td>锁定状态</td>
			<td>部门编号</td>
			<td>允许IP</td>
		</tr>
		</thead>
		<tbody id="userList">
		<!--内容展示-->
		</tbody>
	</table>
</div>
</body>
</html>