<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>게시판 웹페이지</title>
<style type="text/css">
/*링크 또는 마우스 커서가 올려진 링크 요소에 적용 */
	a, a:hover{
		color: #000000;
		text-decoration: none;
	}
</style>
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
		//페이지 번호가 유효한지 확인
		int pageNumber = 1;
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
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
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				if(userID == null){//로그인 되지 않은 경우
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
				}else{//로그인 된 경우
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
	<!--게시판 영역-->
	<div class = "container">
		<div class = "row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody><!--게시글 표시, 게시글 선택시 게시글을 불러옴-->
						<%
							BbsDAO bbsDAO = new BbsDAO();
							ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
							for(int i = 0; i < list.size(); i++){
						%>
					<tr>
							<td><%= list.get(i).getUserID() %></td>
							<td><a href="viewBbs.jsp?bbsID=<%= list.get(i).getBbsID()%>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></a></td>
							<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시 " + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<%
							}
					%>
				</tbody>
			</table>
			<%
				if(pageNumber != 1){//첫 페이지가 아니면 이전 페이지로 이동
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber -1 %>" class="btn btn-success btn-arrow-left">이전</a><!--이전 버튼-->
			<%		
				}if(bbsDAO.nextPage(pageNumber + 1)){//다음 페이지가 존재하면 다음 페이지로 이동
			%>
				<a href="bbs.jsp?pageNumber=<%=pageNumber +1 %>" class="btn btn-success btn-arrow-right">다음</a><!--다음 버튼-->
			<%
				}
			%>
			<a href="writeBbs.jsp" class="btn btn-primary pull-right">글쓰기</a><!--글쓰기 버튼 -->
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>