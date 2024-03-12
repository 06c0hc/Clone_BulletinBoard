<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="comment.Comment"%>
<%@ page import="comment.CommentDAO" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="css/customInputWindow.css">

<title>모든 댓글 보기 웹페이지</title>
</head>
<body>
	<script type="text/javascript">
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	<%
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
			script.println("alert('유효하지 않은 게시글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collase-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<%
				if(userID == null){
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
				}else{	
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
	
	<!--전체 댓글 보기 영역-->
	<div class="container">
		<div class="row">
			<table class = "table">
				<thead>
					<tr>
						<th colspan="5" style="background-color: #eeeeee; text-align: left;">
							<a href="viewBbs.jsp?bbsID=<%=bbsID%>">게시글로 돌아가기</a><!--게시글로 돌아가기 링크-->
						</th>
					</tr>
				</thead>
				<tbody><!--모든 댓글 목록-->
						<%
						CommentDAO cmtDAO = new CommentDAO();
						ArrayList <Comment> cmtList = cmtDAO.getAllComments(bbsID);
						
						for(int i = 0; i < cmtList.size(); i++){
						%>
						<tr>
							<th style="background-color: #ffffff; text-align: left">
							<%=cmtList.get(i).getUserID()%>
							<%
								if(new ReplyDAO().count(cmtList.get(i).getCommentID())==0){
							%>
							<a href="viewReplies.jsp?bbsID=<%=bbsID%>&commentID=<%=cmtList.get(i).getCommentID() %>" class="comment-link">답글</a><!--답글 보기 링크-->
							<%
								}else{
							%>
							<a href="viewReplies.jsp?bbsID=<%=bbsID%>&commentID=<%=cmtList.get(i).getCommentID() %>" class="comment-link">답글 (<span><%= new ReplyDAO().count(cmtList.get(i).getCommentID())%></span>)</a><!--답글 보기 링크-->
							<%
								}
							%>
							</th>
							<td colspan="2" style="background-color: #ffffff; text-align: left;"><%= cmtList.get(i).getCommentContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
							<td style="background-color: #ffffff; text-align:center;"><%= cmtList.get(i).getCommentDate().substring(0, 11) + cmtList.get(i).getCommentDate().substring(11, 13) + "시 " + cmtList.get(i).getCommentDate().substring(14, 16) + "분" %></td>
							<%
								if(userID != null && userID.equals(cmtList.get(i).getUserID())){
							%>
							<td style="background-color: #ffffff;">
							<div class="dropdown" style="float: right;">
  								<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
    								<span class="glyphicon glyphicon-option-horizontal"></span>
  								</button>
								<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
									<li><a href="updateComment.jsp?bbsID=<%=bbsID%>&commentID=<%=cmtList.get(i).getCommentID() %>">답글 수정</a></li>
									<li><a href="deleteCommentAction.jsp?bbsID=<%=bbsID%>&commentID=<%=cmtList.get(i).getCommentID() %>">답글 삭제</a></li>
								</ul>
							</div>
							</td>
							<%
								}else{
							%>
							<td style="background-color: #ffffff;">
							<%
								}
							%>
						</tr>
						<%
						}
						%>
				</tbody>
			</table>
		</div>
	</div>
	
	<!--댓글 작성  영역-->
	<div class="container input-container" style="display: block;">
		<div class="row">
			<form method="post" action="writeCommentAction.jsp?bbsID=<%=bbsID%>">
				<table class = "table">
					<thead></thead>
					<tbody><!--댓글 작성 창-->
						<tr>
							<td><textarea class="form-control" placeholder="댓글 내용" name="commentContent" maxlength="500" style="height: 100px;"></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-success pull-right" value="댓글 등록"><!--댓글 등록 버튼-->
			</form>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>