<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="visithistory.VisitHistory" %>
<%@ page import="visithistory.VisitHistoryDAO" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.ZoneId"%>
<%@ page import="java.time.ZonedDateTime" %>
<%@ page import="java.time.LocalTime" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<script type="text/javascript">
	
	//HTTP를 HTTPS로 리다이렉트
	if (document.location.protocol == 'http:') {
    	document.location.href = document.location.href.replace('http:', 'https:');
	}
	</script>
	
	<%
		//쿠키를 통해  클라이언트의 방문 여부를 확인
		boolean isVisit = false;//방문 여부
		Cookie[] cookies = request.getCookies();//요청 정보의 쿠키 목록
		
		//쿠키 목록 조회
		for(int i =0; (cookies != null) && (i < cookies.length); i++){
			if(cookies[i].getName().equals("isVisit")){//클라이언트의 방문 여부 조회
				isVisit = Boolean.parseBoolean(cookies[i].getValue());
			}
		}
		//오늘 처음 방문 시 방문 처리
		if(isVisit==false){
			isVisit=true;
			VisitHistoryDAO vhDAO = new VisitHistoryDAO();
			vhDAO.writeVisitHistory();
		}
		//다음날 자정 - 현재 시간 = 오늘 남은 시간
		LocalDate localDate = LocalDate.now();
		ZoneId zoneID = ZoneId.of("Asia/Seoul");
		ZonedDateTime tomorrowMidnight = ZonedDateTime.of(localDate.plusDays(1), LocalTime.MIDNIGHT, zoneID);//다음날 자정
		ZonedDateTime now = ZonedDateTime.of(localDate, LocalTime.now(), zoneID);//오늘 남은 시간
		long epochSeconds1 = now.toEpochSecond();
		long epochSeconds2 = tomorrowMidnight.toEpochSecond();
		int result = (int)(epochSeconds2-epochSeconds1);
		
		//방문 정보 쿠키를 생성해서 응답으로 전송
		Cookie cookie = new Cookie("isVisit", String.valueOf(isVisit));
		cookie.setMaxAge(result);//쿠키는 자정까지만 유지
		response.addCookie(cookie);
		
	%>
	
	
	<script>
		location.href = 'main.jsp';//main.jsp로 이동
	</script>
</body>
</html>