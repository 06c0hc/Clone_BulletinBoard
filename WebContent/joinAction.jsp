<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>
<jsp:setProperty name="user" property="userName"/>
<jsp:setProperty name="user" property="userGender"/>
<jsp:setProperty name="user" property="userEmail"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원가입 진행 웹페이지</title>
</head>
<body>
	<script type="text/javascript">
	
	//HTTP를 HTTPS로 리다이렉트
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	<%
		//세션 확인
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		//이미 로그인 되어있으면 회원가입 거부
		if(userID != null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("location.href = 'main.jsp'");//main.jsp로 이동
			script.println("</script>");
		}
		//회원 가입 양식에 비어있는 항목이 있는 확인
		if(user.getUserID()==null||user.getUserPassword()==null||user.getUserName()==null||user.getUserGender()==null||user.getUserEmail()==null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 항목이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}else{
			//회원 가입 처리 진행
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user);
			if(result == -1){//회원가입이 정상적으로 되지 않은 경우(입력한 아이디가 이미 존재하는 경우)
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");//이전 페이지로 이동
				script.println("</script>");
			}else{//회원가입이 정상적으로 된 경우
				session.setAttribute("userID", user.getUserID());
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'");//main.jsp로 이동
				script.println("</script>");
			}
		}
	%>
</body>
</html>