<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>게시글 보기 웹페이지</title>
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
		//유효한 게시글인지 확인
		int bbsID = 0;
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		
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
	<!--게시글 보기 영역-->
	<div class = "container" style = "margin-bottom: 50px">
		<div class = "row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일</td>
						<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시 " + bbs.getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
					</tr>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a><!--게시판 이동 버튼-->
			<%
				if(userID != null && userID.equals(bbs.getUserID())){
			%>
					<a href="updateBbs.jsp?bbsID=<%= bbsID%>" class="btn btn-success pull-right" style = "margin-left: 10px">수정</a><!--게시글 수정 버튼-->
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteBbsAction.jsp?bbsID=<%= bbsID%>" class="btn btn-danger pull-right">삭제</a><!--게시글 삭제 버튼-->
			<%		
				}
			%>
		</div>
	</div>
	
	<!--댓글 보기 영역-->
	<div class="container">
		<div class="row">
			<table class = "table">
				<thead>
					<tr>
						<th colspan="4" style="background-color: #eeeeee; text-align: right;">
							<a href="viewAllComments.jsp?bbsID=<%=bbsID%>">댓글 모두 보기</a><!--댓글 모두 보기 링크-->
						</th>
					</tr>
				</thead>
				<tbody><!--댓글 목록(최대 10개까지)-->
						<%
						CommentDAO cmtDAO = new CommentDAO();
						ArrayList <Comment> cmtList = cmtDAO.getComments(bbsID);
						for(int i = 0; i < cmtList.size(); i++){
						%>
						<tr>
							<th style="background-color: #ffffff; text-align: left"> <%=cmtList.get(i).getUserID()%> </th>
							<td colspan="2" style="background-color: #ffffff; text-align: left;"><%= cmtList.get(i).getCommentContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
							<td style="background-color: #ffffff; text-align:right;"><%= cmtList.get(i).getCommentDate().substring(0, 11) + cmtList.get(i).getCommentDate().substring(11, 13) + "시 " + cmtList.get(i).getCommentDate().substring(14, 16) + "분" %></td>
						</tr>
						<%
						}
						%>
				</tbody>
			</table>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>