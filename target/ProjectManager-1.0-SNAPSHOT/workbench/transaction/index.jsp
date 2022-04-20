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

	<%--BootStrap的分页插件--%>
	<link rel="stylesheet" type="text/css" href="jquery\bs_pagination\jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery\bs_pagination\jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery\bs_pagination\en.js"></script>
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
		//页面加载完毕后，触发一个方法
		pageList(1,3);
		//给复选框绑定事件，触发全选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		});
		$("#tranBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});
		//给查询按钮绑定事件
		$("#searchBtn").click(function () {
			/*点击查询按钮的时候我们应该保存搜索框中的内容
            * 建立隐藏域，保存信息
            * */
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-transactionname").val($.trim($("#search-transactionname").val()));
			$("#hidden-customername").val($.trim($("#search-customername").val()));
			$("#hidden-stage").val($.trim($("#search-stage").val()));
			$("#hidden-transactionType").val($.trim($("#search-transactionType").val()));
			$("#hidden-contactsfullname").val($.trim($("#search-contactsfullname").val()));
			pageList(1,3);
		});
		//给修改按钮绑定单击事件
		$("#updateBtn").click(function () {
			var $xz = $("input[name=xz]:checked");
			if ($xz.length == 0){
				alert("请选择需要修改的记录");
			}else if($xz.length>1){
				alert("只能选择一条记录");
			}else {
				//选定了一条记录，进行修改相关操作
				var id = $xz.val();
				//发送传统请求
				window.location.href="workbench/tran/edit.do?id="+id;
			}
		});
		//给删除按钮绑定单击事件
		$("#deleteBtn").click(function () {
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
						url:"workbench/tran/deleteList.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data) {
							//返回一个标记就可以了
							if(data.success){
								//TRUE
								alert("删除成功");
								pageList(1,3);
							}else {
								//false
								alert("删除失败");
							}
						}
					})
				}
			}
		});
	});
	//添加函数，分页插件，可以刷新列表
	function pageList(pageNo,pageSize) {
		//将全选的复选框取消
		$("#qx").prop("checked",false);
		//查询之前，将隐藏域保存的信息取出来，重新赋值到搜索框中
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-transactionname").val($.trim($("#hidden-transactionname").val()));
		$("#search-customername").val($.trim($("#hidden-customername").val()));
		$("#search-stage").val($.trim($("#hidden-stage").val()));
		$("#search-transactionType").val($.trim($("#hidden-transactionType").val()));
		$("#search-contactsfullname").val($.trim($("#hidden-contactsfullname").val()));

		$.ajax({
			url:"workbench/tran/pageList.do",
			data:{"pageNo":pageNo,
				"pageSize":pageSize,
				"owner":$.trim($("#search-owner").val()),
				"transactionname":$.trim($("#search-transactionname").val()),
				"customername":$.trim($("#search-customername").val()),
				"stage":$.trim($("#search-stage").val()),
				"transactionType":$.trim($("#search-transactionType").val()),
				"contactsfullname":$.trim($("#search-contactsfullname").val()),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//我们需要从后台拿到的信息，项目信息列表(开发人员需要展示的数据) 和 数据库的总记录数(分页插件需要)
				//{ "total":100,"dataList":[{信息1},{},{}] }
				var html = "";
				//每一个n就是一个项目信息对象
				$.each(data.dataList,function (i,n) {
					html += '<tr>';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/tran/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.customerId+'</td>';
					html += '<td>'+n.stage+'</td>';
					html += '<td>'+n.type+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.contactsId+'</td>';
					html += '</tr>';
				})
				$("#tranBody").html(html);
				//计算总页数
				var totalPages = data.total%pageSize==0 ? data.total/pageSize : parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件，对前端进行分页展示
				$("#tranPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数
					visiblePageLinks: 3, // 显示几个卡片
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//该回调函数是在点击分页组组件的是时候触发的
					onChangePage : function(even, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}
</script>
</head>
<body>

<%--创建隐藏域，保存查询的信息--%>
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-transactionname">
<input type="hidden" id="hidden-customername">
<input type="hidden" id="hidden-stage">
<input type="hidden" id="hidden-transactionType">
<input type="hidden" id="hidden-contactsfullname">

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">交易名称</div>
				      <input class="form-control" type="text" id="search-transactionname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户公司</div>
				      <input class="form-control" type="text" id="search-customername">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">现今阶段</div>
					  <select class="form-control" id="search-stage">
						  <option></option>
						  <c:forEach items="${stageList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">交易类型</div>
					  <select class="form-control" id="search-transactionType">
					  	<option>请选择</option>
					  	<option></option>
					  	<option>已有业务</option>
					  	<option>新业务</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactsfullname">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>

			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/save.jsp';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>

			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>交易名称</td>
							<td>客户公司</td>
							<td>阶段</td>
							<td>交易类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<%--分页插件--%>
					<div id="tranPage"></div>
					<%--实现分页组件的代码--%>
				</div>
		</div>
	</div>
	</div>
</body>
</html>