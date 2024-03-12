<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="reply" class="reply.Reply" scope="page"/>
<jsp:setProperty name="reply" property="replyContent"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>답글 등록 진행 웹페이지</title>
</head>
<body>
	<script type="text/javascript">
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	<%
	String userID = null;
	if(session.getAttribute("userID")!=null){//이미 세션 정보가 있다면 그 세션을 가져옴
		userID = (String)session.getAttribute("userID");
	}
	
	int bbsID = 0;
	if(request.getParameter("bbsID")!=null){
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	
	int commentID = 0;
	if(request.getParameter("commentID") !=null){
		commentID = Integer.parseInt(request.getParameter("commentID"));
	}
	
	
	//로그인이 되어있는지 확인
	if(userID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.herf = login.jsp");
		script.println("</script>");
	}else{//로그인이 되었다면
		if(reply.getReplyContent()==null){//답글 내용이 작성되어있는지 체크
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("답글이 입력되지 않았습니다.");
			script.println("history.back()");
			script.println("</script>");
		}else{//답글 등록 처리 진행
			ReplyDAO rpDAO = new ReplyDAO();
			int result = rpDAO.write(commentID, userID, reply.getReplyContent());
			if(result == -1){//DB 오류 발생시
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('답글 등록에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				String viewReplyURL = "location.href = \'viewReplies.jsp?bbsID="+bbsID+"&commentID="+commentID+"\'";
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println(viewReplyURL);
				script.println("</script>");
			}
		}
	}
	%>
</body>
</html>