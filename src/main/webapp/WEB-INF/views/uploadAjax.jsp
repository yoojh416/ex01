<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
   <title>upload</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<style>
	.uploadResult{
		width: 100%;
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
		width: 20px;
	}
</style>
</head>
<body>
<div class ="uploadDiv">
	<input type ="file" name ="uploadFile" multiple>
</div>
<div class="uploadResult">
	<ul>
	
	</ul>
</div>
<button id="uploadBtn">Upload</button>
</body>
<script type="text/javascript">
   $(document).ready(function() {
	   var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;//5MB
		var cloneObj=$(".uploadDiv").clone();
		
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
           $("#uploadBtn").on("click",function(e){
              var formData= new FormData();
              var inputFile=$("input[name='uploadFile']");
              var files = inputFile[0].files;
              console.log(files);
              
              for (var i = 0; i < files.length; i++){
            	  if(!checkExtension(files[i].name,files[i].size)){
            		  return false;
            	  }
                 formData.append("uploadFile", files[i]);
              }
              
              $.ajax({
                 url:'/uploadAjaxAction',
                 processData: false,
                 contentType: false,
                 data: formData,
                 type: 'POST',
                 dataType:'json',
                 success: function(result){
                    alert("uploaded");
                    console.log(result);
                    showUploadedFile(result);
                    $(".uploadDiv").html(cloneObj.html());
                 }
            }); //$.ajax
              
          });
          
          var uploadResult=$(".uploadResult ul");
          function showUploadedFile(uploadResultArr){
        	  var str="";
        	  $(uploadResultArr).each(function(i,obj){
        		 /*  str+="<li>"+obj.fileName+"</li>"; */
        		  if(!obj.image){
        			  str+="<li><img src='/resources/images/attach.png'>"+obj.fileName+"</li>";
        		  }else{
        			  str+="<li>"+obj.fileName+"</li>"
        		  }
        	  });
        	  uploadResult.append(str);
          }
     });
</script>
</html>