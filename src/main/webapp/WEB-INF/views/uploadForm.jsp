<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="uploadFormAction" method="post" enctype="multipart/form-data">
		<input type="file" name="uploadFile" multiple> <!-- multipart->여러개의 폼을 만들지 않아도 복수의 파일을 올릴 수 있도록 설정함 -->
		<button>파일 업로드</button>
	</form>
</body>
</html>