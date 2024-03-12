<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="reply.Reply"%>
<%@ page import="reply.ReplyDAO" %>
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<title>답글 수정 진행 웹페이지</title>
</head>
<body>
	<script type="text/javascript">
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	<%
	String userID = null;
	if(session.getAttribute("userID") != null){//세션이 있는지 확인
		userID = (String)session.getAttribute("userID");
	}
	//로그인이 되어있는지 확인
	if(userID == null){
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
		script.println("location.href = 'bbs.jsp'");
		script.println("</script>");
	}
	//유효한 댓글인지 확인
	int commentID = 0;
	if(request.getParameter("commentID") != null){
		commentID = Integer.parseInt(request.getParameter("commentID"));
	}
	if(commentID == 0){
		PrintWriter script = response.getWriter();
		String viewAllCommentsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
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
		String viewRepliesURL = "location.href = \'viewReplies.jsp?bbsID="+bbsID+"&commentID="+commentID+"\'";
		script.println("<script>");
		script.println("alert('유효하지 않은 답글입니다.')");
		script.println(viewRepliesURL);
		script.println("</script>");
	}
	//답글ID와 일치하는 답글을 가져옴
	Reply reply = new ReplyDAO().getReply(replyID, commentID);
	//현재 접속중인 사용자와 답글 작성자가 동일한지 확인
	if(!userID.equals(reply.getUserID())){
		PrintWriter script = response.getWriter();
		String viewRepliesURL = "location.href = \'viewReplies.jsp?bbsID="+bbsID+"&commentID="+commentID+"\'";
		script.println("<script>");
		script.println("alert('수정 권한이 없습니다.')");
		script.println(viewRepliesURL);
		script.println("</script>");
	}else{
		//답글 수정 양식이 작성되었는지 확인
		if(request.getParameter("replyContent") == null|| request.getParameter("replyContent").equals("")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('답글 내용이 입력되지 않았습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}else{
			//답글 수정 처리 진행
			int result = new ReplyDAO().update(replyID, request.getParameter("replyContent"));
			if(result == -1){//DB 오류 발생 시
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('답글 수정에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				PrintWriter script = response.getWriter();
				String viewRepliesURL = "location.href = \'viewReplies.jsp?bbsID="+bbsID+"&commentID="+commentID+"\'";
				script.println("<script>");
				script.println(viewRepliesURL);
				script.println("</script>");
			}
		}
	}
	%>
</body>
</html>