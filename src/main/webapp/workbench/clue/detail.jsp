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
		//界面加载完毕后，展现项目线索关联的备注信息列表,单独列出一个函数
		showClueRemarkList();
		//界面加载完毕后，取出关联的项目信息列表
        showProjectList();
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})
        //给关联关系模态窗口中的搜索框添加事件，触发回车键查询吗，展现项目信息 列表
		$("#pname").keydown(function (event) {
			//如果是回车键，触发函数事件
			if(event.keyCode==13){
				//alert("刷新列表");
				$.ajax({
                    //根据项目的名称检索没有被该线索关联的项目信息，返回项目信息列表
					url:"workbench/clue/getProjectListAndNotByClueId.do",
					data:{
						"pname" : $.trim($("#pname").val()),
						"clueId" : "${clue.id}"
					},
					type:"get",
					dataType:"json",
					success:function (data) {
						/*
						data{项目信息1,项目信息2，项目信息3}
						 */
						var html = '';
						$.each(data,function (i,n) {
							html += '<tr>';
							html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
							html += '<td>'+n.name+'</td>';
							html += '<td>'+n.startDate+'</td>';
							html += '<td>'+n.endDate+'</td>';
							html += '<td>'+n.owner+'</td>';
							html += '</tr>';
						})
						$("#projectSearchBody").html(html);
					}
				})
				//展现完列表后，记得将模态窗户默认的回车行为禁用
				return false;
			}
		})
		//给关联关系按钮绑定事件
		$("#bundBtn").click(function () {
			var $xz = $("input[name=xz]:checked");//标签选择器
			if ($xz.length==0){
				alert("请选择需要关联的项目");
			}else{
				//编写请求地址和参数：workbench/clue/bund.do?cid=xxx&pid=xxx&pid=xxx
				var param ="cid=${clue.id}&";
				for (var i = 0; i < $xz.length; i++) {
					param += "pid="+ $($xz[i]).val();
					if (i<$xz.length-1){
						param +="&";
					}
				}
			}
			//检验参数是否完整   alert(param);
			$.ajax({
				url:"workbench/clue/bund.do",
				data:param,
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.success){
						alert("关联项目成功")
						showProjectList();
						$("#pname").val("");
						$("#bundModal").modal("hide");
					}else{
						alert("关联项目操作失败")
					}

				}
			})
		})

		//给备注保存按钮添加单击事件
		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/clue/saveRemark.do",
				data:{
					"noteContent" : $.trim($("#remark").val()),
					"clueId" : "${clue.id}"
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					/*需要的数据
                    * [{success:true/false},{cr:{备注信息}}]
                    * */
					if(data.success){
						$("#remark").val("");
						//添加成功，在备注后边追加一个div
						var html = "";
						html += '<div class="remarkDiv" id="'+data.cr.id+'" style="height: 60px;">';
						html += '<img title="${clue.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="edit'+data.cr.id+'">'+data.cr.noteContent+'</h5>';
						html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}</b> <small style="color: gray;" id="s'+data.cr.id+'"> '+data.cr.createTime+'由'+data.cr.createBy+'</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="editClueRemark(\''+data.cr.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="deleteClueRemark(\''+data.cr.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';
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
				url:"workbench/clue/updateRemark.do",
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
                    * {SUCCESS:true/false；cr:list}
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
	//刷新项目信息列表函数
	function showProjectList() {
        $.ajax({
            url:"workbench/clue/getProjectListByClueId.do",
            data:{
                "clueId" : "${clue.id}"
            },
            type:"get",
            dataType:"json",
            success:function (data) {
                /*
                data[{项目1},{项目2},....]
                 */
                var html = '';
                $.each(data,function (i,n) {
                    html += '<tr>';
                    html += '<td>'+n.name+'</td>';
                    html += '<td>'+n.startDate+'</td>';
                    html += '<td>'+n.endDate+'</td>';
                    html += '<td>'+n.owner+'</td>';
                    html += '<td><a href="javascript:void(0);" onclick="unbund(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
                    html += '</tr>';
                })
                $("#projectList").html(html);
            }
        })
    }
    //解除项目信息和线索的关联关系函数
    function unbund(id) {
		$.ajax({
			url:"workbench/clue/unbund.do",
			data:{
				"id" : id
			},
			type:"post",
			dataType:"json",
			success:function (data) {
				/*
				data{success:true/false}
				 */
				if(data.success){
					//解除关联关系成功
					showProjectList();
				}else {
					alert("解除关联失败");
				}
			}
		})
    }
    //刷新线索备注函数
	function showClueRemarkList(){
		$.ajax({
			url:"workbench/clue/getClueRemarkListById.do",
			data:{
				"clueId" : "${clue.id}"
			},
			type:"get",
			dataType:"json",
			success:function (data) {
				/*查询备注信息列表
				data[{备注1},{备注2},{3}]
				*/
				var html = "";
				$.each(data,function (i,n) {
					html +='<div class="remarkDiv" id="'+n.id+'" style="height: 60px;">';
					html +='<img title="${clue.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html +='<div style="position: relative; top: -40px; left: 40px;" >';
					html +='<h5 id="edit'+n.id+'">'+n.noteContent+'</h5>';
					html +='<font color="gray">项目线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0 ? n.createTime:n.editTime)+' 由'+(n.editFlag==0 ? n.createBy:n.editBy)+'</small>';
					html +='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="editClueRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="deleteClueRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html +='</div>';
					html +='</div>';
					html +='</div>';
				})
				$("#remarkDiv").before(html);
			}
		})
	}
	//删除线索备注函数
	function deleteClueRemark(id) {
		$.ajax({
			url:"workbench/clue/deleteRemark.do",
			data:{"id" : id},
			type:"post",
			dataType:"json",
			success:function (data) {
				/*
				* SUCCESS:true/false
				* */
				if(data.success){
					//showRemarkList();
					$("#"+id).remove();
				}else{
					alert("删除备注信息失败");
				}
			}
		})
	}
	//修改线索备注函数
	function editClueRemark(id) {
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
	//打开关联模态窗口之前清理一下旧的信息
	function cleanBundBtn() {
		var html = "";
		$("#projectSearchBody").html(html);
		$("#bundModal").modal("show");
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
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联项目信息</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="pname" style="width: 300px;" placeholder="请输入项目名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="hidden"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="projectSearchBody">
							<%--关联关系活动列表--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="bundBtn">关联</button>
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
			<h3>${clue.fullname} ${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-danger" onclick="window.location.href='workbench/clue/convert.jsp?id=${clue.id}&fullname=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}';"><span class="glyphicon glyphicon-retweet"></span> 线索转换</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname} ${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		
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
	
	<!-- 项目信息 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>项目信息</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>项目名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="projectList">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" onclick="cleanBundBtn()" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联项目信息</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>