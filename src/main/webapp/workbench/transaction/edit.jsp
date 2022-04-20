<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		$(function(){
			//添加时间控件，便利，规范用户的日期输入
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
			//执行填充信息函数
			showUserContactsCustomerProject();
			//给更新按钮绑定单机事件
			$("#renewBtn").click(function () {
				$.ajax({
					url :"workbench/tran/renew.do",
					data : {
						"owner":$.trim($("#edit-transactionOwner").val()),
						"id":$.trim($("#edit-tranId").val()),
						"money" : $.trim($("#edit-amountOfMoney").val()),
						"name" : $.trim($("#edit-transactionName").val()),
						"expectedDate" : $.trim($("#edit-expectedClosingDate").val()),
						"customerId" : $.trim($("#edit-accountName").val()),
						"stage" : $.trim($("#edit-transactionStage").val()),
						"type" : $.trim($("#edit-transactionType").val()),
						"source" : $.trim($("#edit-clueSource").val()),
						"projectId" : $.trim($("#edit-activitySrc").val()),
						"contactsId" : $.trim($("#edit-contactsName").val()),
						"description" : $.trim($("#create-describe").val()),
						"contactSummary" : $.trim($("#create-contactSummary").val()),
						"nextContactTime" : $.trim($("#create-nextContactTime").val())
					},
					type: "post",
					dataType: "json",
					success : function (date) {
						//返回一个更新成功与否的标志{success : true/false}
						if(date.success){
							//添加成功
							alert("修改交易成功");
							//定向到交易主页,刷新交易列表
							window.location.href="workbench/transaction/index.jsp";
						}else {
							alert("修改交易失败");
							//定向到交易主页,刷新交易列表
							window.location.href="workbench/transaction/index.jsp";
						}
					}
				})
			});
		});

		//填充信息函数
		function showUserContactsCustomerProject() {
			$.ajax({
				url:"workbench/tran/getUserContactsCustomerProject.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					/*
                    * data  :用户信息列表userList和客户信息列表customerList,项目信息表projectList，联系人信息表contactsList,
                    *      [用户信息列表userList和客户信息列表customerList,项目信息表projectList，联系人信息表contactsList]
                    * */
					{//所有者
						var html = "";
						$.each(data.userList,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-transactionOwner").html(html);
						var id1 = "${sessionScope.user.id}";
						$("#edit-transactionOwner").val(id1);
					}
					{//客户信息列表
						var html1 = "";
						$.each(data.customerList,function (i,m) {
							html1 += "<option value='"+m.id+"'>"+m.name+"</option>";
						})
						$("#edit-accountName").html(html1);
					}
					{//联系人信息列表
						var html2 = "";
						$.each(data.contactsList,function (i,q) {
							html2 += "<option value='"+q.id+"'>"+q.fullname+"</option>";
						})
						$("#edit-contactsName").html(html2);
					}
					{//项目信息列表
						var html3 = "";
						$.each(data.projectList,function (i,p) {
							html3 += "<option value='"+p.id+"'>"+p.name+"</option>";
						})
						$("#edit-activitySrc").html(html3);
					}
				}
			})
		};
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="renewBtn">更新</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">

		<input type="hidden" id="edit-tranId" value="${tran.id}">

		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionOwner">

				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">交易金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" value="${tran.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">交易名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" value="${tran.name}">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="edit-expectedClosingDate" value="${tran.expectedDate}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-accountName" class="col-sm-2 control-label">客户公司名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-accountName">

				</select>
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">交易阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-transactionStage">
				  <option>${tran.stage}</option>
				  <c:forEach items="${stageList}" var="st">
					  <option value="${st.value}">${st.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">交易类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-transactionType">
					<option>${tran.type}</option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-nextContactTime" value="${tran.nextContactTime}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-clueSource">
					<option>${tran.source}</option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label">项目信息源 *</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-activitySrc">

				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称 *</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-contactsName">

				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe">${tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary">${tran.contactSummary}</textarea>
			</div>
		</div>
		
	</form>
</body>
</html>