<%@ page language="java" contentType="text/html;charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comment" class="comment.Comment" scope="page"/>
<jsp:setProperty name="comment" property="commentContent"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<title>댓글 등록 진행 웹페이지</title>
</head>
<body>
	<script type="text/javascript">
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){//이미 세션 정보가 있다면 그 세션 정보를 가져옴
			userID = (String)session.getAttribute("userID");
		}
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}else{//로그인된 상황
			//게시글ID 추출
			int bbsID = 0;
			if(request.getParameter("bbsID") != null){
				bbsID = Integer.parseInt(request.getParameter("bbsID"));
			}
			if(bbsID == 0){//유효한 게시글인지 확인
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
			}
			//댓글 내용이 작성되었는지 확인
			if(comment.getCommentContent() == null||comment.getCommentContent() == ""){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력된 내용이 없습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				//댓글 등록 처리
				CommentDAO cmtDAO = new CommentDAO();
				int result = cmtDAO.write(userID, bbsID, comment.getCommentContent());
				//오류 확인용 메시지
				System.out.println("POST로 전송된 CommentContent: " + request.getParameter("commentContent"));
				System.out.println("cmtDAO is null :  "+ (cmtDAO==null));//CommentDAO가 null이 아님을 확인.
				System.out.println("result: " + result);//-1임을 확인.
				System.out.println("userID: " + userID);//댓글 작성자ID가 맞음.
				System.out.println("bbsID: " + bbsID);//댓글이 작성된 게시글의 ID가 맞음.
				
				System.out.println("commentContent: "+comment.getCommentContent());//댓글내용이 깨져서 출력됨.
				if(result == -1){//DB오류 발생시
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 등록에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}else{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					String viewBbsURL = "location.href = \'viewAllComments.jsp?bbsID="+bbsID+"\'";
					script.println(viewBbsURL);
					script.println("</script>");
				}
			}	
		}
		
	%>
</body>
</html>