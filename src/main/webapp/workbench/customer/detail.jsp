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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		//界面加载完毕后，展现备注信息列表,单独列出一个函数
		showRemarkList();

		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//给备注保存按钮绑定事件
		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/customer/saveRemark.do",
				data:{
					"noteContent" : $.trim($("#remark").val()),
					"customerId" : "${customer.id}"
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					/*需要的数据
                    * [{success:true/false},{cr:{备注信息}}]
                    * */
					if(data.success){
						//清理一下备注文本框
						$("#remark").val("");
						//添加成功，在备注后边追加一个div
						var html = "";
						html += '<div class="remarkDiv" id="'+data.cr.id+'"style="height: 60px;">';
						html += '<img title="${customer.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="edit'+data.cr.id+'">'+data.cr.noteContent+'</h5>';
						html += ' <font color="gray">客户公司</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;" id="s'+data.cr.id+'"> '+(data.cr.editFlag==0 ? data.cr.createTime:data.cr.editTime)+'由'+(data.cr.editFlag==0 ? data.cr.createBy:data.cr.editBy)+'</small>';
						html += ' <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += ' <a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.cr.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #c44545;"></span></a>';
						html += ' &nbsp;&nbsp;&nbsp;&nbsp;';
						html += ' <a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.cr.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #b34141;"></span></a>';
						html += ' </div>';
						html += ' </div>';
						html += ' </div>';

						$("#remarkDiv").before(html);
					}else{
						alert("添加备注失败");
					}
				}
			})
		})

		//给备注更新按钮绑定事件
		$("#updateRemarkBtn").click(function () {
			var id =$("#remarkId").val();
			var noteContent =$.trim($("#noteContent").val());
			$.ajax({
				url:"workbench/customer/updateRemark.do",
				data:{
					"id":id,
					"noteContent":noteContent
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					/*需要的数据
                    *成功与否的标志
                    * 更新时间，备注内容的信息
                    * {SUCCESS:true/false;cr:list}
                    * */
					if(data.success){
						//更新div中的相应内容noteContent;editTime,editBy
						$("#edit"+id).html(data.cr.noteContent);
						$("#s"+id).html(data.cr.editTime+"由"+data.cr.editBy);
						//内容更新成功，关闭窗口
						$("#editRemarkModal").modal("hide");
					}else{
						alert("更新备注失败");
					}
				}
			})
		})
	});

	function showRemarkList(){
		$.ajax({
			url:"workbench/customer/getRemarkListById.do",
			data:{
				"customerId" : "${customer.id}"
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				/*查询备注信息列表
				data[{备注1},{备注2},{3}]
				*/
				var html = "";
				$.each(data,function (i,n) {
					html += '<div class="remarkDiv" id="'+n.id+'"style="height: 60px;">';
					html += '<img title="${customer.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="edit'+n.id+'">'+n.noteContent+'</h5>';
					html += ' <font color="gray">客户公司</font> <font color="gray">-</font> <b>${customer.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0 ? n.createTime:n.editTime)+'由'+(n.editFlag==0 ? n.createBy:n.editBy)+'</small>';
					html += ' <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += ' <a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #c44545;"></span></a>';
					html += ' &nbsp;&nbsp;&nbsp;&nbsp;';
					html += ' <a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #b34141;"></span></a>';
					html += ' </div>';
					html += ' </div>';
					html += ' </div>';
				})
				$("#remarkDiv").before(html);
			}
		})
	}
	function deleteRemark(id) {
		$.ajax({
			url:"workbench/customer/deleteRemark.do",
			data:{"id" : id},
			type:"post",
			dataType:"json",
			success:function (data) {
				/*
				* SUCCESS:true/false
				* */
				if(data.success){
					$("#"+id).remove();
				}else{
					alert("删除备注信息失败");
				}
			}
		})
	}
	function editRemark(id) {
		//alert(id);
		//将模态窗口中的隐藏域ID赋值
		$("#remarkId").val(id);
		//找到模态窗口之前，找到指定的备注信息标签的信息
		var noteContent = $("#edit"+id).html();
		//将拿到的备注信息放到修改备注框中
		$("#noteContent").val(noteContent);
		//处理完以上功能，打开模态窗口
		$("#editRemarkModal").modal("show");
	}
</script>

</head>
<body>
<!-- 修改备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${customer.name} <small><a href="http://www.ahau.edu.cn" target="_blank">${customer.website}</a></small></h3>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 10px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>客户信息备注</h4>
		</div>

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>