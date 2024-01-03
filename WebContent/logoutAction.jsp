<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그아웃 진행 화면</title>
</head>
<body>
	<%
		session.invalidate();//현재 접속중인 회원의 세션을 해제
	%>
	<script>
		location.href='main.jsp';
	</script>
</body>
</html>