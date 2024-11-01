<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="visithistory.VisitHistoryDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>메인 홈페이지</title>
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
		
		VisitHistoryDAO vhDAO = new VisitHistoryDAO();
	%>
	<!--웹 사이트 헤더-->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collase-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!--좌측에 "JSP 게시판 웹 사이트" 링크-->
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				if(userID == null){//로그인되지 않은 경우
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				}else{//로그인 된 경우(그 회원은 회원가입 페이지로는 접속할 수 없음)
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
				
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
			
		</div>
	</nav>
	<div class="container">
		<div class="container"  style="float: left; width: 200px; margin-right: 30px;">
			<h1 style="text-align: center;">방문자 수</h1>
			<p style="font-size: 40px; text-align: center;">Today : <%=vhDAO.getVisitors()%></p>
			<p style="font-size: 40px; text-align: center;">Total : <%=vhDAO.getAllVisitors()%></p>
		</div>
		<div class="jumbotron" style="float: right; width: 700px;">
			<div class="contaner">
				<h1>안내</h1>
				<p>어서오세요. 이 웹 사이트는 JSP를 활용하여 개발한 웹 게시판입니다.</p>
			</div>
		</div>
	</div>
	<!-- 제이쿼리 자바스크릡트 추가 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 자바스크립트 추가 -->
	<script src="js/bootstrap.js"></script>
</body>
</html>