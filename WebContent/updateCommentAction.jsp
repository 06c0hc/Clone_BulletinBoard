<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="comment.Comment" %>
<%@ page import="comment.CommentDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", inital-scale="1">
<title>댓글 수정 진행 웹페이지</title>
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
		//로그인 되어있는지 확인
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
			String viewAllCommentsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
			script.println("<script>");
			script.println("alert('유효하지 않는 댓글입니다.')");
			script.println(viewAllCommentsURL);//전체 댓글 보기 페이지로 이동
			script.println("</script>");
		}
		Comment cmt = new CommentDAO().getComment(commentID);//댓글ID와 일치하는 댓글을 가져옴
		//현재 접속중인 사용자와 댓글 작성자가 동일한지 확인
		if(!userID.equals(cmt.getUserID())){
			PrintWriter script = response.getWriter();
			String viewAllCommentsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
			script.println("<script>");
			script.println("alert('수정 권한이 없습니다.')");
			script.println(viewAllCommentsURL);//전체 댓글 보기 페이지로 이동
			script.println("</script>");
		}else{
			//댓글 수정 양식이 작성되었는지 확인
			if(request.getParameter("commentContent") == null || request.getParameter("commentContent").equals("")){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('댓글 내용이 작성되지 않았습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				//댓글 수정 처리 진행
				CommentDAO cmtDAO = new CommentDAO();
				int result = cmtDAO.update(commentID, request.getParameter("commentContent"));
				if(result == -1){//DB오류 발생시
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}else{
					PrintWriter script = response.getWriter();
					String viewAllCommentsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
					script.println("<script>");
					script.println(viewAllCommentsURL);//수정된 댓글을 확인할 수 있도록 viewAllComments.jsp로 이동
					script.println("</script>");
				}
			}	
		}
	%>
</body>
</html>