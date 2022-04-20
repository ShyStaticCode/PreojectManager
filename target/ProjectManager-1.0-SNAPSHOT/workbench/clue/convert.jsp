<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
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
			pickerPosition: "bottom-left"
		});
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//对项目信息源的放大镜图标添加事件
		$("#openSearchModalBtn").click(function () {
			$("#searchActivityModal").modal("show");
		})
		//为搜索模态窗口的文本框，添加一个搜索的事件
		$("#pname").keydown(function (event) {
			//如果是回车键，触发函数事件
			if(event.keyCode==13){
				//alert("刷新列表");
				$.ajax({
					url:"workbench/clue/getProjectListByName.do",
					data:{
						"pname" : $.trim($("#pname").val()),
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						/*取得项目信息列表
						data{项目信息1,2,3}
						 */
						var html = '';
						$.each(data,function (i,n) {
						html += '<tr>';
						html += '<td><input type="radio" value="'+n.id+'" name="xz"/></td>';
						html += '<td id="'+n.id+'">'+n.name+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '</tr>';
						})
						$("#projectSearchBody").html(html);
					}
				})
				//展现完列表后，记得将模态窗户默认的回车行为禁用、
				return false;
			}
		})
		//给模态窗口的提交按钮绑定单机事件,目的：给项目信息源填充项目信息名，给隐藏域添加项目信息的Id
		$("#submitActivityBtn").click(function () {
			var id = $("input[name=xz]:checked").val();
			var name = $("#"+id).html();
			//alert(id);
			//alert(name);
			//将获取到的id和name放到项目信息源中
			$("#projectName").val(name);
			$("#projectId").val(id);
			//关闭模态窗口
			$("#searchActivityModal").modal("hide");
		})

		//为转换按钮绑定事件
		$("#convertBtn").click(function () {
			/*
			单机按钮，线索转换
			提交请求到后台，发出传统请求
			请求结束，返回到线索列表页面
		根据《为客户创建交易的框有没有选中》来判断是否需要创建交易
			 */
			if($("#isCreateTransaction").prop("checked")){
				/*alert("需要创建交易");
				参数有clueId，还有交易表单中的信息，金额、预计成交日期、交易名称、阶段、项目信息源
				window.location.href="workbench/clue/convert.do?clueId=xxx&xxx&xxx&xxx&xxx.....";
				以上的传统请求这种悬挂参数的方式行不通了，
				使用提交交易表单代替这种传统请求，好处:参数不用手动悬挂，写name属性，可以提交post请求，不用担心安全问题
				 */
				//绑定表单，提交内容参数
				$("#tranForm").submit();
			}else {
				/*alert("不用创建交易")
				传一个clueId就可以了
				 */
				window.location.href="workbench/clue/convert.do?clueId=${param.id}";

			}
		})
	});
</script>

</head>
<body>
	
	<!-- 搜索项目信息的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索项目信息</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入项目信息名称，支持模糊查询" id="pname">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>项目名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="projectSearchBody">
							<%--<tr>
								项目信息列表展示
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<!--EL表达式给我们提供了很多的隐含对象，
		只有xxxScope系列的隐含对象可以省略，
		其他形式的隐含对象一概不可以省略，
		如果省略就会从域对象中取值-->
		<h4>转换项目线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	<%--提交表单的行为结果--%>
		<form id="tranForm" action="workbench/clue/convert.do" method="post">
			<input type="hidden" name="flag" value="YES">

			<input type="hidden" name="clueId" value="${param.id}">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="安农-" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计落成日期</label>
		    <input type="text" class="form-control time" id="expectedClosingDate" name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">现在项目阶段</label>
		    <select id="stage"  class="form-control" name="stage">
		    	<option></option>
		    	<c:forEach items="${stageList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">项目信息源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="projectName" placeholder="点击上面搜索" readonly>
			  <%--设置隐藏域，保存项目信息的ID--%>
		    <input type="hidden" id="projectId" name="projectId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的项目所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" value="线索转换" id="convertBtn">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>