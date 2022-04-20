<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		//为创建按钮绑定一个事件
		//打开添加操作的模态窗口
		$("#addBtn").click(function () {

			//添加时间控件，便利，规范用户的日期输入
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//alert("走后台拿数据");
			//$("#createActivityModal").modal("show");
			//取得用户信息列表，将所有者的信息填充
			$.ajax({
				url:"workbench/project/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					/*
					* 索要用户信息列表
					* data:json数组[{id:?,name:?,loginAct:?......},{},{}]
					* */
					var html = "<option></option>";
					//遍历json数组
					$.each(data,function (index,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-marketActivityOwner").html(html);
					/*
					* 取得当前登录的用户id，默认填充在创建者的框中
					* */
					var currentId = "${sessionScope.user.id}";
					$("#create-marketActivityOwner").val(currentId);
					//处理好下拉列表框之后，展示模态窗口
					$("#createActivityModal").modal("show");
				}
			})
		})
		//给保存按钮，添加单机事件
		$("#saveBtn").click(function () {
		 	$.ajax({
				url :"workbench/project/save.do",
				data : {
					"owner" : $.trim($("#create-marketActivityOwner").val()),
					"name" : $.trim($("#create-marketActivityName").val()),
					"startDate" : $.trim($("#create-startTime").val()),
					"endDate" : $.trim($("#create-endTime").val()),
					"cost" : $.trim($("#create-cost").val()),
					"description" : $.trim($("#create-describe").val())
				},
				type: "post",
				dataType: "json",
				success : function (date) {
					if(date.success){
						//添加成功
						alert("项目信息添加成功");
						//局部刷新，项目信息列表
						/*
						* pageList($("#activityPage").bs_pagination('getOption', 'currentPage',$("#activityPage").bs_pagination('getOption', 'rowsPerPage')));
						* */
						pageList(1,3);
						//清一下模态窗口的数据
						$("#activityAddForm")[0].reset();
						$("#createActivityModal").modal("hide");
					}else {
						alert("项目信息添加失败");
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
					}
				}
			})
		 })

		//页面加载完毕后，触发一个方法
		pageList(1,3);
		//给查询按钮绑定一个click事件
		$("#searchBtn").click(function () {
			/*
			* 点击查询按钮的时候我们应该保存搜索框中的内容
			* 建立隐藏域，保存信息
			* */
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,3);
		})
		//给复选框绑定事件，触发全选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#activityBody").on("click",$("input[name=xz]"),function () {
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
						url:"workbench/project/deleteList.do",
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
				$.ajax({
					url:"workbench/project/getUserProject.do",
					data:{"id" : id},
					type:"get",
					dataType:"json",
					success:function (data) {
						//需要的数据，用户列表uList，市场活动列表a
						var html = "";
						$.each(data.uList,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-marketActivityOwner").html(html);

						$("#edit-id").val(data.a.id);
						$("#edit-marketActivityOwner").val(data.a.owner);
						$("#edit-marketActivityName").val(data.a.name);
						$("#edit-cost").val(data.a.cost);
						$("#edit-startDate").val(data.a.startDate);
						$("#edit-endDate").val(data.a.endDate);
						$("#edit-describe").val(data.a.description);

						//值处理完毕，打开模态窗口
						$("#editActivityModal").modal("show");
					}
				})
			}
		})
		//给更新按钮绑定事件，执行市场活动的修改
		$("#updateBtn").click(function () {
			$.ajax({
				url :"workbench/project/update.do",
				data : {
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-marketActivityOwner").val()),
					"name" : $.trim($("#edit-marketActivityName").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-describe").val())
				},
				type: "post",
				dataType: "json",
				success : function (date) {
					//返回一个更新成功与否的标志
					if(date.success){
						//添加成功
						alert("修改项目信息成功");
						//局部刷新，市场活动信息列表
						//pageList(1,3);
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage'),$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editActivityModal").modal("hide");
					}else {
						alert("修改项目信息失败");
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
					}
				}
			})

		})

	});
	/*
	* 对于所有的关系型数据库，做前端的分页的相关操作的基础组件
	* 就是pageNo(当前页码) 和 pageSize(每页展示记录数)
	* ***打开项目信息界面时，发出ajax请求，拿到市场活动信息列表的数据，局部刷新列表
	*
	* 什么时候需要使用刷新列表，调用pageList方法
	*		1，单机左侧市场活动；
	*		2，创建，修改，删除项目信息之后；
	*		3，点击查询按钮的时候；
	*		4，点击分页组件的时候。
	* */
	function pageList(pageNo,pageSize){
		//将全选的复选框取消
		$("#qx").prop("checked",false);
		//查询之前，将隐藏域保存的信息取出来，重新赋值到搜索框中
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));
		$.ajax({
			url:"workbench/project/pageList.do",
			data:{"pageNo":pageNo,
				  "pageSize":pageSize,
				  "name" : $.trim($("#search-name").val()),
				  "owner" : $.trim($("#search-owner").val()),
				  "startDate" : $.trim($("#search-startDate").val()),
				  "endDate" : $.trim($("#search-endDate").val())
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//我们需要从后台拿到的信息，项目信息列表(开发人员需要展示的数据) 和 数据库的总记录数(分页插件需要)
				//{ "total":100,"dataList":[{市场活动1},{},{}] }
				var html = "";
				//每一个n就是一个项目信息对象
				$.each(data.dataList,function (i,n) {
					html+= '<tr class="active"> ';
					html+= '<td><input type="checkbox" name="xz" value="'+n.id+'" /></td>';
					html+= '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/project/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html+= '<td>'+n.owner+'</td>';
					html+= '<td>'+n.startDate+'</td>';
					html+= '<td>'+n.endDate+'</td>';
					html+= '</tr>';
				})
				$("#activityBody").html(html);

				//计算总页数
				var totalPages = data.total%pageSize==0 ? data.total/pageSize : parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件，对前端进行分页展示
				$("#activityPage").bs_pagination({
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

<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-startDate">
<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建项目信息</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityAddForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">项目名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">项目成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">项目简况</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
						<!--自己把控保存按钮
						data-dismiss="modal"表示保存模态窗口
						-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改项目信息</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">项目名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">项目成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">项目简况 </label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
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

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>项目信息列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">项目名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					 <!--创建和修改两个模态窗口
					 	通过属性值的方式，打开各自的模态窗口
					 	data-target="#createActivityModal"
						data-target="#editActivityModal"
					 	问题：没有办法对按钮功能进行扩充
					 	解决：实际项目开发中，对于出发模态窗口的操作不能写死，要自己来写js 代码来操作
					 -->
				  <button type="button" class="btn btn-primary" data-toggle="modal" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>项目名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--项目信息列表展示--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<%--
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				--%>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<%--分页插件展示--%>
					<div id="activityPage"></div>
						<%--实现分页组件的代码--%>
				</div>
			
			</div>
	</div>
	</div>
</body>
</html>