<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.uploadResult{
width:100%;
background-color: #ddd;
}
.uploadResult ul{
display: flex;
flex-flow: row;
justify-content: center;
align-items: center;
}
.uploadResult ul li{
list-style: none;
padding: 10px;
}
.uploadResult ul li img{
width:20px;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script> 
</head>
<body>
<div class="uploadDiv">
	<input type="file" name="uploadFile" multiple="multiple">
</div>
<div class="uploadResult">
	<ul></ul>
</div>
<button id="uploadBtn">Upload</button>
</body>

<script type="text/javascript">

$(document).ready(function(){
	var regEx = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;
	function checkExtension(fileName, fileSize){
		if(fileSize>=maxSize){
			alert("파일 크기 초과");
			return false;
		}
		if(regEx.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없음.")
			return false;
		}
		return true;
	}

	
	$("#uploadBtn").on("click", function(e){
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		var cloneObj = $(".uploadDiv").clone();
		console.log(files);
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		console.log("files.length"+files.length);
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false, //전달할 데이터를 query string으로 만들지 말것
			contentType: false,
			data: formData,
			type: 'POST',
			dataType: 'json', //받는 파일 타입
			success: function(result){
				console.log(result);
				showUploadedFile(result);
				$(".uploadDiv").html(cloneObj.html());
			}
		});
	});
	
	var uploadResult = $(".uploadResult ul");
	function showUploadedFile(uploadResultArr){
		var str="";
		$(uploadResultArr).each(function(i, obj){
			if(!obj.image){
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				str += "<li><a href='/download?fileName="+fileCallPath+"'><img src='/resources/images/attach.png'>"+obj.fileName+"</a></li>";
			}else{
				//str += "<li>"+obj.fileName+"</li>";
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				str += "<li><img src='/display?fileName="+fileCallPath+"'></li>";
			}
		});
		uploadResult.append(str);
	}
	
});
</script>

</html>