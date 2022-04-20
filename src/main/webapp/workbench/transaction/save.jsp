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
		//执行函数
		showUserContactsCustomerProject();
        //给保存按钮绑定单机事件
        $("#saveBtn").click(function () {
            $.ajax({
                url:"workbench/tran/save.do",
                data:{
                    "owner" : $.trim($("#create-transactionOwner").val()),
                    "money" : $.trim($("#create-amountOfMoney").val()),
                    "name" : $.trim($("#create-transactionName").val()),
                    "expectedDate" : $.trim($("#create-expectedClosingDate").val()),
					"customerId" : $.trim($("#create-accountName").val()),
					"stage" : $.trim($("#create-transactionStage").val()),
					"type" : $.trim($("#create-transactionType").val()),
					"source" : $.trim($("#create-clueSource").val()),
					"projectId" : $.trim($("#create-activitySrc").val()),
					"contactsId" : $.trim($("#create-contactsName").val()),
					"description" : $.trim($("#create-describe").val()),
					"contactSummary" : $.trim($("#create-contactSummary").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime").val())
                },
                type:"post",
                dataType:"json",
                success:function (data) {
                    /*
                    * data:{"success" : true/false}
                    * */
                    if (data.success){
                        //刷新列表
                        alert("交易保存成功");
                        //清一下表单中的数据
                        $("#tranAddForm")[0].reset();
                        //定向到交易主页,刷新交易列表
                        window.location.href="workbench/transaction/index.jsp";
                    }else{
                        alert("交易保存失败");
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
					var html = "<option>请选择所有者</option>";
					$.each(data.userList,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-transactionOwner").html(html);
					var id1 = "${sessionScope.user.id}";
					$("#create-transactionOwner").val(id1);
				}
				{//客户信息列表
					var html1 = "<option>请选择客户</option>";
					$.each(data.customerList,function (i,m) {
						html1 += "<option value='"+m.id+"'>"+m.name+"</option>";
					})
					$("#create-accountName").html(html1);
				}
				{//联系人信息列表
					var html2 = "<option>请选择联系人</option>";
					$.each(data.contactsList,function (i,q) {
						html2 += "<option value='"+q.id+"'>"+q.fullname+"</option>";
					})
					$("#create-contactsName").html(html2);
				}
				{//项目信息列表
					var html3 = "<option>请选择项目源</option>";
					$.each(data.projectList,function (i,p) {
						html3 += "<option value='"+p.id+"'>"+p.name+"</option>";
					})
					$("#create-activitySrc").html(html3);
				}

			}
		})
	};
</script>

</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;" id="tranAddForm">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">

				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">交易金额(元)</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">交易名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-accountName">

				</select>
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
				  <option>请选择</option>
				  <c:forEach items="${stageList}" var="st">
					  <option value="${st.value}">${st.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option>请选择</option>
				  <option>已有业务</option>
				  <option>新业务</option>
				</select>
			</div>
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
					<option>请选择</option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-activitySrc" class="col-sm-2 control-label">项目信息源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-activitySrc">

				</select>
			</div>
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-contactsName">

				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>