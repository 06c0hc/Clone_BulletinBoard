<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="comment.Comment"%>
<%@ page import="comment.CommentDAO"%>

<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>댓글 삭제 진행 웹페이지</title>
</head>
<body>
	<script>
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){//이미 세션 정보가 있다면 그 세션을 가져옴
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
		//게시글 ID 추출
		int bbsID = 0;
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		//댓글 ID 추출
		int commentID = 0;
		if(request.getParameter("commentID") != null){
			commentID = Integer.parseInt(request.getParameter("commentID"));
		}
		//유효한 댓글인지 확인
		if(commentID == 0){
			PrintWriter script = response.getWriter();
			String viewAllCommentsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
			script.println("<script>");
			script.println("alert('유효하지 않는 댓글입니다.')");
			script.println(viewAllCommentsURL);//전체 댓글 보기 페이지로 이동
			script.println("</script>");
		}
		
		Comment comment = new CommentDAO().getComment(commentID);//댓글 ID와 일치하는 댓글을 가져옴
		//현재 접속중인 사용자와 댓글 작성자가 동일한지 확인
		if(!userID.equals(comment.getUserID())){
			PrintWriter script = response.getWriter();
			String viewAllCommentsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
			script.println("<script>");
			script.println("alert('수정 권한이 없습니다.')");
			script.println(viewAllCommentsURL);//전체 댓글 보기 페이지로 이동
			script.println("</script>");
		}else{
			//댓글 삭제 처리 진행
			CommentDAO cmtDAO = new CommentDAO();
			int result = cmtDAO.delete(commentID);
			if(result == -1){//DB오류 발생시
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('댓글 삭제에 실패했습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				PrintWriter script = response.getWriter();
				String viewAllCommentsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
				script.println("<script>");
				script.println(viewAllCommentsURL);
				script.println("</script>");
			}	
		}
	%>
</body>
</html>