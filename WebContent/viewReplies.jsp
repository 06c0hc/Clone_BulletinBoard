<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="comment.CommentDAO" %>
<%@ page import="comment.Comment"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="reply.Reply"%>
<%@ page import="reply.ReplyDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="css/customInputWindow.css">
<title>답글 보기 웹페이지</title>

</head>
<body>
	<script type="text/javascript">
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	<%
	String userID = null;
	if(session.getAttribute("userID")!=null){
		userID = (String)session.getAttribute("userID");
	}
	int bbsID = 0;
	if(request.getParameter("bbsID")!=null){
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	if(bbsID == 0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 게시글입니다.')");
		script.println("location.href = 'bbs.jsp'");//게시글 목록 페이지로 이동
		script.println("</script>");
	}
	
	int commentID = 0;
	if(request.getParameter("commentID") != null){
		commentID = Integer.parseInt(request.getParameter("commentID"));
	}
	if(commentID == 0){
		PrintWriter script = response.getWriter();
		String viewAllCommentsURL = "location.href = \'"+"viewAllComments.jsp?bbsID="+bbsID+"\'";
		script.println("<script>");
		script.println("alert('유효하지 않은 댓글입니다.')");
		script.println(viewAllCommentsURL);//댓글 전체 보기 페이지로 이동
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
	<!-- 댓글 및 답글 보기 영역 -->
	<div class="container">
		<div class="row">
			<table class = "table">
				<thead>
					<tr>
						<th colspan="5" style="background-color: #eeeeee; text-align: left;">
							<a href="viewAllComments.jsp?bbsID=<%=bbsID%>">전체 댓글</a><!--전체 댓글 링크-->
						</th>
					</tr>
				</thead>
				<tbody><!--댓글및  모든 답글 목록-->
					<%
					Comment cmt = new CommentDAO().getComment(commentID);
					%>
					<tr>
						<th style="background-color: #ffffff; text-align: left">
						<%=cmt.getUserID() %>
						<a class ="reply-link">답글 쓰기</a><!--답글 쓰기 링크-->
						</th>
						<td colspan="2" style="background-color: #ffffff; text-align: left;"><%= cmt.getCommentContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
						<td style="background-color: #ffffff; text-align:center;"><%= cmt.getCommentDate().substring(0, 11) + cmt.getCommentDate().substring(11, 13) + "시 " + cmt.getCommentDate().substring(14, 16) + "분" %></td>
						<td style="background-color: #ffffff;">
					</tr>
					<%
					ReplyDAO rpDAO = new ReplyDAO();
					ArrayList<Reply> rpList = rpDAO.getAllReplies(commentID);
					for(int i = 0; i < rpList.size(); i++){
					%>
					<tr>
						<th style="background-color: #ffffff; text-align: left">
						<%=rpList.get(i).getUserID()%>
						</th>
						<td colspan="2" style="background-color: #ffffff; text-align: left;"><%= rpList.get(i).getReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
						<td style="background-color: #ffffff; text-align:center;"><%= rpList.get(i).getReplyDate().substring(0, 11) + rpList.get(i).getReplyDate().substring(11, 13) + "시 " + rpList.get(i).getReplyDate().substring(14, 16) + "분" %></td>
						<%
							if(userID != null && userID.equals(rpList.get(i).getUserID())){
						%>
						<td style="background-color: #ffffff;">
						<div class="dropdown" style="float: right;">
								<button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
								<span class="glyphicon glyphicon-option-horizontal"></span>
								</button>
							<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
								<li><a href="updateReply.jsp?bbsID=<%=bbsID%>&commentID=<%=rpList.get(i).getCommentID()%>&replyID=<%=rpList.get(i).getReplyID()%>">답글 수정</a></li>
								<li><a href="deleteReplyAction.jsp?bbsID=<%=bbsID%>&commentID=<%=rpList.get(i).getCommentID()%>&replyID=<%=rpList.get(i).getReplyID()%>">답글 삭제</a></li>
							</ul>
						</div>
						</td>
						<%
							}else{
						%>
						<td style="background-color: #ffffff;"></td>
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
	<!-- 답글 작성 창-->
	<div class="container input-container">
		<div class="row">
			<form method="post" action="writeReplyAction.jsp?bbsID=<%=bbsID%>&commentID=<%=commentID%>">
				<table class = "table">
					<thead></thead>
					<tbody><!--답글 작성 창-->
						<tr>
							<td><textarea class="form-control" placeholder="답글 내용" name="replyContent" maxlength="500" style="height: 100px;"></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-success pull-right" value="답글 등록"><!--답글 등록 버튼-->
			</form>
		</div>
	</div>
	
	<script>
	//웹 페이지에 이벤트를 등록
    document.addEventListener("DOMContentLoaded", function() {
        var replyLink = document.querySelector(".reply-link");//"답글 쓰기" 링크
        var inputContainer = document.querySelector(".input-container"); //"답글 입력 창"과 "전송 버튼"을 갖는 입력 컨테이너
        //"답글 쓰기" 링크  클릭 시 답글 입력창과 전송 버튼이 활성화/비활성화되는 이벤트를 등록
        replyLink.addEventListener("click", function() {
            inputContainer.classList.toggle("active");
        });
    });
	</script>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>