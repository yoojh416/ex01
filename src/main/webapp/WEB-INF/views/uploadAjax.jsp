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
.uploadResult ul li span{
color: white;
}
.bigPictureWrapper{
position:absolute;
display:none;
justify-content:center;
align-items:center;
top:0%;
width: 100%;
height: 100%;
background-color: gray;
z-index:100;
background:rgba(255,255,255,0.5);
}
.bigPicture{
position:relative;
display:flex;
justify-content:center;
align-items:center;
}
.bigPicture img{
width:400px;
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
<div class="bigPictureWrapper">
	<div class="bigPicture"></div>
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
		$(uploadResultArr).each(function(i, obj){ //이미지가 아닌 경우
			if(!obj.image){
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				str += "<li><div><a href='/download?fileName="+fileCallPath+"'><img src='/resources/images/attach.png'>"+obj.fileName+"</a>"+"<span data-file=\'"+fileCallPath+"\'data-type='file'>x</span></div></li>";
			}else{ //이미지인 경우
				//str += "<li>"+obj.fileName+"</li>";
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				var originPath=obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;
				originPath=originPath.replace(new RegExp(/\\/g),"/"); //direct 작성 시 '\\'를 사용했다면 '/'로 변경해 줌'
				str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a>"+"<span data-file=\'"+fileCallPath+"\'data-type='image'>x</span></li>";
			}
		});
		uploadResult.append(str);
	}
	
	$(".uploadResult").on("click","span",function(e){
		var targetFile=$(this).data("file");
		var type=$(this).data("type");
		console.log(targetFile);
		$.ajax({
			url:'/deleteFile',
			data: {fileName:targetFile, type:type},
			dataType:'text',
			type:'post',
			success:function(result){ alert(result); }
		});
	});
	
});

function showImage(fileCallPath){
	/* alert(fileCallPath); */
	$(".bigPictureWrapper").css("display","flex").show();
	$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%',height:'100%'},1000);
	$(".bigPictureWrapper").on("click",function(e){
		$(".bigPicture").animate({width:'0%',height:'0%'},1000);
		setTimeout(function(){
			$('.bigPictureWrapper').hide();
		},1000);
	});
} //<a>태그에서 직접 showImage() 호출할 수 있도록 document ready 외부에 선언
</script>

</html>