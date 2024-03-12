<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="comment.Comment"%>
<%@ page import="comment.CommentDAO"%>
<%@ page import="reply.Reply"%>
<%@ page import="reply.ReplyDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>답글 수정 웹페이지</title>
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
	//유효한 답글인지 확인
	int replyID = 0;
	if(request.getParameter("replyID") != null){
		replyID = Integer.parseInt(request.getParameter("replyID"));
	}
	if(replyID == 0){
		PrintWriter script = response.getWriter();
		String viewRepliesURL = "location.herf = \'viewReplies.jsp?bbsID=" + bbsID + "&commentID=" + commentID + "\'";
		script.println("<script>");
		script.println("alert('유효하지 않은 답글입니다.')");
		script.println(viewRepliesURL);
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
	<!-- 댓글 및 답글 보기 영역 -->
	<div class="container">
		<div class="row">
			<table class = "table">
				<thead>
					<tr>
						<th colspan="5" style="background-color: #eeeeee;"></th>
					</tr>
				</thead>
				<tbody><!--댓글및  모든 답글 목록-->
					<%
					Comment cmt = new CommentDAO().getComment(commentID);
					%>
					<tr>
						<th style="background-color: #ffffff; text-align: left">
						<%=cmt.getUserID() %>
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
					<%
						if(replyID == rpList.get(i).getReplyID()){//답글 목록 중 수정할 답글 ID와 일치하는 답글이 있는지 확인
					%>
					<!--일치하는 답글이 있으면 그 답글을 수정 창에 안에 표시-->
					<tr>
						<td colspan="5"  class="container input-container" style="margin-top: 0;">
							<form method="post" action="updateReplyAction.jsp?bbsID=<%=bbsID%>&commentID=<%=commentID%>&replyID=<%=replyID%>">
								<textarea class="form-control" name="replyContent" maxlength="500" style="height: 100px;"><%=rpList.get(i).getReplyContent() %></textarea>
								<input type="submit" class="btn btn-success pull-right" value="답글 수정"><!--답글 등록 버튼-->
							</form>
							<a href="viewReplies.jsp?bbsID=<%= bbsID%>&commentID=<%=commentID%>" class="btn btn-danger pull-right">수정 취소</a><!--수정 취소 버튼-->
						</td>
					</tr>
					<%
						}else{
					%>
					<tr>
						<th style="background-color: #ffffff; text-align: left">
						<%=rpList.get(i).getUserID()%>
						</th>
						<td colspan="2" style="background-color: #ffffff; text-align: left;"><%= rpList.get(i).getReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">","&gt").replaceAll("\n", "<br>") %></td>
						<td style="background-color: #ffffff; text-align:center;"><%= rpList.get(i).getReplyDate().substring(0, 11) + rpList.get(i).getReplyDate().substring(11, 13) + "시 " + rpList.get(i).getReplyDate().substring(14, 16) + "분" %></td>
						<td style="background-color: #ffffff;"></td>
					</tr>
					<%
						}
					%>
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