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
		$("#customerBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
		});

		//给查询按钮绑定事件
		$("#searchBtn").click(function () {
			/*点击查询按钮的时候我们应该保存搜索框中的内容
            * 建立隐藏域，保存信息
            * */
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-name").val($.trim($("#search-name").val()));
			pageList(1,3);
		});
		//给客户的创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {
			$.ajax({
				url:"workbench/customer/getUserList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					/*
					* data  :用户信息列表
					*      [{用户1},{},{}]
					* */
					var html = "<option>请选择</option>";
					$.each(data,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-customerOwner").html(html);
					var id = "${user.id}";
					$("#create-customerOwner").val(id);
					//处理完下拉框列表的信息，打开模态窗口
					$("#createCustomerModal").modal("show");
				}
			})
		});
		//给保存按钮绑定事件
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/customer/save.do",
				data:{
					"name" : $.trim($("#create-customerName").val()),
					"owner" : $.trim($("#create-customerOwner").val()),
					"phone" : $.trim($("#create-phone").val()),
					"website" : $.trim($("#create-website").val()),
					"description" : $.trim($("#create-describe").val()),
					"contactSummary" : $.trim($("#create-contactSummary").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime").val()),
					"address" : $.trim($("#create-address1").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					/*
					* data:{"success" : true/false}
					* */
					if (data.success){
						//刷新列表
						alert("客户信息保存成功");
						pageList(1,3);
						//清一下模态窗口
						$("#customerAddForm")[0].reset();
						//关闭模态窗口
						$("#createCustomerModal").modal("hide");
					}else{
						alert("该客户信息保存失败");
					}
				}
			})
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
				$.ajax({
					url:"workbench/customer/getUserCustomer.do",
					data:{"id" : id},
					type:"get",
					dataType:"json",
					success:function (data) {
						//需要的数据，用户列表uList，客户列表c
						var html = "";
						$.each(data.uList,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})
						$("#edit-customerOwner").html(html);

						$("#edit-id").val(data.c.id);
						$("#edit-customerName").val(data.c.name);
						$("#edit-phone").val(data.c.phone);
						$("#edit-website").val(data.c.website);
						$("#edit-describe").val(data.c.description);
						$("#create-contactSummary1").val(data.c.contactSummary);
						$("#create-nextContactTime2").val(data.c.nextContactTime);
						$("#create-address").val(data.c.address);
						//值处理完毕，打开模态窗口
						$("#editCustomerModal").modal("show");
					}
				})
			}
		});
		//给修改客户模态窗口，更新按钮绑定单机事件
		$("#renewBtn").click(function () {
			$.ajax({
				url :"workbench/customer/renewCustomer.do",
				data : {
					"edit-owner":$.trim($("#edit-customerOwner").val()),
					"edit-name":$.trim($("#edit-customerName").val()),
					"edit-id":$.trim($("#edit-id").val()),
					"edit-phone":$.trim($("#edit-phone").val()),
					"edit-website":$.trim($("#edit-website").val()),
					"edit-description":$.trim($("#edit-describe").val()),
					"edit-contactSummary":$.trim($("#create-contactSummary1").val()),
					"edit-nextContactTime":$.trim($("#create-nextContactTime2").val()),
					"edit-address":$.trim($("#create-address").val())
				},
				type: "post",
				dataType: "json",
				success : function (date) {
					//返回一个更新成功与否的标志{success : true/false}
					if(date.success){
						//添加成功
						alert("修改客户信息成功");
						//局部刷新，客户信息列表
						//pageList(1,3);
						pageList($("#customerPage").bs_pagination('getOption', 'currentPage'),$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editCustomerModal").modal("hide");
					}else {
						alert("修改客户信息失败");
						//关闭模态窗口
						$("#editCustomerModal").modal("hide");
					}
				}
			})
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
						url:"workbench/customer/deleteList.do",
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
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$.ajax({
			url:"workbench/customer/pageList.do",
			data:{"pageNo":pageNo,
				"pageSize":pageSize,
				"name":$.trim($("#search-name").val()),
				"phone":$.trim($("#search-phone").val()),
				"owner":$.trim($("#search-owner").val()),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//我们需要从后台拿到的信息，项目信息列表(开发人员需要展示的数据) 和 数据库的总记录数(分页插件需要)
				//{ "total":100,"dataList":[{线索信息1},{},{}] }
				var html = "";
				//每一个n就是一个项目信息对象
				$.each(data.dataList,function (i,n) {
					html += '<tr>';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'" /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.phone+'</td>';
					html += '<td>'+n.website+'</td>';
					html += '</tr>';
				})
				$("#customerBody").html(html);
				//计算总页数
				var totalPages = data.total%pageSize==0 ? data.total/pageSize : parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件，对前端进行分页展示
				$("#customerPage").bs_pagination({
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
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-phone">

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="customerAddForm">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">

								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" value="单位名称">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">

								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime2">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="renewBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
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
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">动力节点</a></td>
							<td>zhangsan</td>
							<td>010-84846003</td>
							<td>http://www.bjpowernode.com</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">

				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<%--分页插件--%>
					<div id="customerPage"></div>
					<%--实现分页组件的代码--%>
			</div>
			
		</div>
		
	</div>
	</div>
</body>
</html>