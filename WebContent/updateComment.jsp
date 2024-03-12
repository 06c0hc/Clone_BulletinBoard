<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="css/customInputWindow.css">
<title>댓글 수정 웹페이지</title>
</head>
<body>
	<script type="text/javascript">
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	
	<%
	String userID = null;
	if(session.getAttribute("userID") != null){//이미 세션 정보가 있다면 그 세션을 가져옴
		userID = (String)session.getAttribute("userID");
	}
	//로그인이 되어있는지 확인
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
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
		script.println("location.herf = 'bbs.jsp'");
		script.println("</script>");
	}
	//유효한 댓글인지 확인
	int commentID = 0;
	if(request.getParameter("commentID") != null){
		commentID = Integer.parseInt(request.getParameter("commentID"));
	}
	if(commentID == 0){
		PrintWriter script = response.getWriter();
		String viewAllCommentsURL = "location.herf = \'viewAllComments.jsp?bbsID="+ bbsID +"\'";
		script.println("<script>");
		script.println("alert('유효하지 않은 댓글입니다.')");
		script.println(viewAllCommentsURL);
		script.println("</script>");
	}
	Comment cmt = new CommentDAO().getComment(commentID);
	if(!userID.equals(cmt.getUserID())){//현재 로그인된 사용자가 댓글 작성자와 동일한지 확인 
		PrintWriter script = response.getWriter();
		String viewAllCommentsURL = "location.herf = \'viewAllComments.jsp?bbsID="+ bbsID +"\'";
		script.println("<script>");
		script.println("alert('수정 권한이 없습니다.')");
		script.println(viewAllCommentsURL);//전체 댓글 보기 페이지로 이동
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
		</div>
	</nav>
	<!--댓글 수정  영역-->
	<div class="container input-container" style="display: block;">
		<div class="row">
			<form method="post" action="updateCommentAction.jsp?bbsID=<%=bbsID%>&commentID=<%= cmt.getCommentID()%>">
				<table class = "table">
					<thead></thead>
					<tbody><!--댓글 수정 창-->
						<tr>
							<td><textarea class="form-control" name="commentContent" maxlength="500" style="height: 100px;"><%= cmt.getCommentContent()%></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-success pull-right" value="수정 완료"><!--수정 완료 버튼-->
			</form>
			<a href="viewAllComments.jsp?bbsID=<%= bbsID%>" class="btn btn-danger pull-right">수정 취소</a><!--수정 취소 버튼-->
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>