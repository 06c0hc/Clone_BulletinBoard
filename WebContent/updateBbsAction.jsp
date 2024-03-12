<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시글 수정 진행 웹페이지</title>
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
		//로그인 확인
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
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");//bbs.jsp로 이동
			script.println("</script>");
		}
		//현재 접속중인 사용자와 게시글 작성자가 동일한지 확인
		Bbs bbs = new BbsDAO().getBbs(bbsID);//게시글ID와 일치하는 게시글을 가져옴
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('수정 권한이 없습니다.')");
			script.println("location.href = 'bbs.jsp'");//bbs.jsp로 이동
			script.println("</script>");
		}else{
			//게시글 양식(제목,내용)이 모두 작성되었는지 확인
			if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
					|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()");//이전 페이지로 이동
				script.println("</script>");
			}else{
				//게시글 수정 처리 진행
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
				if(result == -1){//DB오류 발생시
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정에 실패했습니다.')");
					script.println("history.back()");//이전 페이지로 이동
					script.println("</script>");
				}else{
					PrintWriter script = response.getWriter();
					String viewBbsURL = "location.href = \'viewBbs.jsp?bbsID="+bbsID+"\'";
					script.println("<script>");
					script.println(viewBbsURL);//viewBbs.jsp로 이동
					script.println("</script>");
				}
			}	
		}
	%>
</body>
</html>