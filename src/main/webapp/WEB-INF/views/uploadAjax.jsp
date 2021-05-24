<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<button id="uploadBtn">Upload</button>
</body>
<script>
	$(document).ready(function(){
		var regex=new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize=5242880;
		function checkExtension(fileName, fileSize){
			if(fileSize>=maxSize){
				alert("파일 크기 초과");
				return false;
			}
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할 수 없음");
				return false;
			}
			return false;
		}
		
		$("#uploadBtn").on("click", function(e){
			var formData=new FormData();
			var inputFile=$("input[name='uploadFile']");
			var files=inputFile[0].files;
			console.log(files);
			
			for(var i=0;i<files.length;i++){
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				formData.append("uploadFile",files[i]);
			}
			console.log("files.length: "+files.length);
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,
				data: formData,
				type: 'POST',
				success: function(result){
					alert('Uploaded');
				}
			});
		});
	})
</script>
</html>