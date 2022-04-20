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
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

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
        $("#contactsBody").on("click",$("input[name=xz]"),function () {
            $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
        });
        //给查询按钮绑定事件
        $("#searchBtn").click(function () {
            /*点击查询按钮的时候我们应该保存搜索框中的内容
            * 建立隐藏域，保存信息
            * */
            $("#hidden-fullname").val($.trim($("#search-fullname").val()));
            $("#hidden-owner").val($.trim($("#search-owner").val()));
            $("#hidden-birth").val($.trim($("#search-birth").val()));
            $("#hidden-customerName").val($.trim($("#search-customerName").val()));
            $("#hidden-source").val($.trim($("#search-source").val()));
            pageList(1,3);
        });
		//给联系人的创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {
			$.ajax({
				url:"workbench/contacts/getUserAndCustomerList.do",
				type:"get",
				dataType:"json",
				success:function (data) {
					/*
					* data  :用户信息列表uList和客户信息列表cList
					*      [{用户1},{},{}]
					* */
					{
						var html = "<option>请选择所有者</option>";
					$.each(data.uList,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-contactsOwner").html(html);
					var id1 = "${sessionScope.user.id}";
					$("#create-contactsOwner").val(id1);
					}
					{
						var html1 = "<option>请选择客户</option>";
					$.each(data.cList,function (i,m) {
						html1 += "<option value='"+m.id+"'>"+m.name+"</option>";
					})
					$("#create-customerName").html(html1);
					}
					//处理完下拉框列表的信息，打开模态窗口
					$("#createContactsModal").modal("show");
				}
			})
		});
		//给保存按钮绑定单机事件
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/contacts/save.do",
				data:{
					"owner" : $.trim($("#create-contactsOwner").val()),
					"source" : $.trim($("#create-clueSource").val()),
					"fullname" : $.trim($("#create-surname").val()),
					"appellation" : $.trim($("#create-call").val()),
					"job" : $.trim($("#create-job").val()),
					"mphone" : $.trim($("#create-mphone").val()),
					"email" : $.trim($("#create-email").val()),
					"birth" : $.trim($("#create-birth").val()),
					"description" : $.trim($("#create-describe").val()),
					"customerId" : $.trim($("#create-customerName").val()),
					"contactSummary" : $.trim($("#create-contactSummary1").val()),
					"nextContactTime" : $.trim($("#create-nextContactTime1").val()),
					"address" : $.trim($("#edit-address1").val())
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					/*
					* data:{"success" : true/false}
					* */
					if (data.success){
						//刷新列表
						alert("联系人保存成功");
						pageList(1,3);
						//清一下模态窗口的数据
						$("#contactsAddForm")[0].reset();
						//关闭模态窗口
						$("#createContactsModal").modal("hide");
					}else{
						alert("联系人保存失败");
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
					url:"workbench/contacts/getUserContacts.do",
					data:{"id" : id},
					type:"get",
					dataType:"json",
					success:function (data) {
						//需要的数据，用户列表uList，客户列表custList ,联系人对象c
						var html = "";
						$.each(data.uList,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})
						var html1 = "";
						$.each(data.custList,function (i,m) {
							html1 += "<option value='"+m.id+"'>"+m.name+"</option>";
						})
						$("#edit-contactsOwner").html(html);
						$("#edit-id").val(data.c.id);
						$("#edit-clueSource1").val(data.c.source);
						$("#edit-surname").val(data.c.fullname);
						$("#edit-call").val(data.c.appellation);
						$("#edit-job").val(data.c.job);
						$("#edit-customerName").html(html1);
						$("#edit-describe").val(data.c.description);
						$("#create-contactSummary").val(data.c.contactSummary);
						$("#create-nextContactTime").val(data.c.nextContactTime);
						$("#edit-address2").val(data.c.address);
						$("#edit-mphone").val(data.c.mphone);
						$("#edit-email").val(data.c.email);
						$("#edit-birth").val(data.c.birth);
						//值处理完毕，打开模态窗口
						$("#editContactsModal").modal("show");
					}
				})
			}
		});
		//给修改线索模态窗口，更新按钮绑定单机事件
		$("#renewBtn").click(function () {
			$.ajax({
				url :"workbench/contacts/renew.do",
				data : {
					"edit-contactsOwner":$.trim($("#edit-contactsOwner").val()),
					"edit-id":$.trim($("#edit-id").val()),
					"edit-customer":$.trim($("#edit-customerName").val()),
					"edit-appellation":$.trim($("#edit-call").val()),
					"edit-fullname":$.trim($("#edit-surname").val()),
					"edit-job":$.trim($("#edit-job").val()),
					"edit-email":$.trim($("#edit-email").val()),
					"edit-mphone":$.trim($("#edit-mphone").val()),
					"edit-source":$.trim($("#edit-clueSource1").val()),
					"edit-describe":$.trim($("#edit-describe").val()),
					"edit-contactSummary":$.trim($("#create-contactSummary").val()),
					"edit-nextContactTime":$.trim($("#create-nextContactTime").val()),
					"edit-address":$.trim($("#edit-address2").val()),
					"edit-birth":$.trim($("#edit-birth").val())
				},
				type: "post",
				dataType: "json",
				success : function (date) {
					//返回一个更新成功与否的标志{success : true/false}
					if(date.success){
						//添加成功
						alert("修改联系人成功");
						//局部刷新，项目信息列表
						//pageList(1,3);
						pageList($("#contactsPage").bs_pagination('getOption', 'currentPage'),$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editContactsModal").modal("hide");
					}else {
						alert("修改联系人失败");
						//关闭模态窗口
						$("editContactsModal").modal("hide");
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
						url:"workbench/contacts/deleteList.do",
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
		$("#search-fullname").val($.trim($("#hidden-fullname").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
        $("#search-birth").val($.trim($("#hidden-birth").val()));
        $("#search-customnerName").val($.trim($("#hidden-customerName").val()));
		$.ajax({
			url:"workbench/contacts/pageList.do",
			data:{"pageNo":pageNo,
				"pageSize":pageSize,
				"fullname":$.trim($("#search-fullname").val()),
				"source":$.trim($("#search-source").val()),
				"owner":$.trim($("#search-owner").val()),
				"customerName":$.trim($("#search-customerName").val()),
				"birth":$.trim($("#search-birth").val()),
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				//我们需要从后台拿到的信息，联系人列表(开发人员需要展示的数据) 和 数据库的总记录数(分页插件需要)
				//{ "total":100,"dataList":[{线索信息1},{},{}] }
				var html = "";
				//每一个n就是一个项目信息对象
				$.each(data.dataList,function (i,n) {
					html += '<tr>';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contacts/detail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
					html += '<td>'+n.customerId+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.source+'</td>';
					html += '<td>'+n.birth+'</td>';
					html += '</tr>';
				})
				$("#contactsBody").html(html);
				//计算总页数
				var totalPages = data.total%pageSize==0 ? data.total/pageSize : parseInt(data.total/pageSize)+1;
				//数据处理完毕后，结合分页插件，对前端进行分页展示
				$("#contactsPage").bs_pagination({
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
<input type="hidden" id="hidden-fullname">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-birth">
<input type="hidden" id="hidden-customerName">
<input type="hidden" id="hidden-source">

	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="contactsAddForm">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">

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
							<label for="create-surname" class="col-sm-2 control-label">联系人姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<option>请选择</option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerName">

								</select>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
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
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address1"></textarea>
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
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id">

						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">

								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource1">
                                    <option>请选择</option>
                                    <c:forEach items="${sourceList}" var="s">
                                        <option value="${s.value}">${s.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">联系人姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<option>请选择</option>
									<c:forEach items="${appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerName">

								</select>
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
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address2"></textarea>
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
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">联系人姓名</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户公司名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人来源</div>
				      <select class="form-control" id="search-source">
                          <option>请选择</option>
                          <c:forEach items="${sourceList}" var="s">
                              <option value="${s.value}">${s.text}</option>
                          </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人生日</div>
				      <input class="form-control time" type="text" id="search-birth">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>

			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="contactsBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四</a></td>
							<td>动力节点</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>2000-10-10</td>
						</tr>--%>

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<%--分页插件--%>
					<div id="contactsPage"></div>
					<%--实现分页组件的代码--%>
			</div>
			
		</div>
	</div>
	</div>
</body>
</html>