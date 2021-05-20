<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../includes/header.jsp"></jsp:include>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Check</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Check your words</div>
			<div class="panel-body">
				<div class="form-group">
					<label>Bno</label> <input class="form-control" name="bno"
						value='<c:out value="${board.bno}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Title</label> <input class="form-control" name="title"
						value='<c:out value="${board.title}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>Content</label>
					<textarea class="form-control" rows="3" name="content"
						readonly="readonly"><c:out value="${board.content}" /></textarea>
				</div>
				<div class="form-group">
					<label>Writer</label> <input class="form-control" name="writer"
						value='<c:out value="${board.writer}"/>' readonly="readonly">
				</div>
				<%-- <button data-oper='modify' class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button> --%>
				<button data-oper="modify" class="btn btn-default">Modify</button>
				<button data-oper="list" class="btn btn-default"
					onclick="location.href='/board/list'">List</button>
				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'> 
					<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'> 
					<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
					<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
					<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
				</form>
			</div>
		</div>
	</div>
</div>
<jsp:include page="../includes/footer.jsp"></jsp:include>
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
	$(document).ready(function(){
		var operForm=$("#operForm");
		$('button[data-oper="modify"]').on("click",function(e){
			operForm.attr("action","/board/modify").submit();
		});
		$('button[data-oper="list"]').on("click",function(e){
			operForm.find("#bno").remove();
			operForm.attr("action","/board/list");
			operForm.submit();
		});
		
		//reply module
		console.log(replyService);
		var bnoValue='<c:out value="${board.bno}"/>';
		/* replyService.add( //객체에 있는 메소드 호출 ★☆★☆★☆지형언니 천재★☆★☆★☆
			{reply: "JS TEST", replyer:"js tester", bno: bnoValue}
			,function(result){
				alert("RESULT: "+result);
		}); */
		
		/* replyService.getList(
				{bno: bnoValue, page:1}
				,function(list){
					for(var i=0, len=list.length||0; i<len; i++){
						console.log(list[i]);
				}
		}); */
		
		/* replyService.remove(
		7
		,function(count){
			console.log(count);
			if(count==="success"){alert("REMOVED");}
		},function(err){
				alert("error occurred...");			
		}); */
		
		/* replyService.update({
			rno: 4,
			bno: bnoValue,
			reply: "modified reply..."
		}, function(result){
			alert("수정 완료");
		}); */
		
		replyService.get(10, function(data){
			console.log(data);
		})
	});
</script>