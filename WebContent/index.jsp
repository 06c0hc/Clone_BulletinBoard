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
		//클라이언트가 방문했다면 visitClient를 true로 바꾸고 쿠키에 넣어서 클라이언트에 저장
		//요청정보의 쿠키 항목 중 방문 여부을 확인
		boolean isVisit = false;//방문 여부
		Cookie[] cookies = request.getCookies();
		
		//쿠키값들을 모두 가져옴
		for(int i =0; (cookies != null) && (i < cookies.length); i++){
			if(cookies[i].getName().equals("isVisit")){
				isVisit = Boolean.parseBoolean(cookies[i].getValue());
			}
		}
		//방문 기록 확인
		if(isVisit==false){
			isVisit=true;//방문 처리
			//방문 기록
			VisitHistoryDAO vhDAO = new VisitHistoryDAO();
			vhDAO.writeVisitHistory();
		}
		//24시간 - 현재 시간 = 남은 시간
		int dayOfHours = 24*60*60;//24시간
		
		
		LocalDate localDate = LocalDate.now();
		ZoneId zoneID = ZoneId.of("Asia/Seoul");
		ZonedDateTime tomorrowMidnight = ZonedDateTime.of(localDate.plusDays(1), LocalTime.MIDNIGHT, zoneID);
		ZonedDateTime now = ZonedDateTime.of(localDate, LocalTime.now(), zoneID);
		System.out.println("서울 시간대 기준 현재 시간: " + now);
		long epochSeconds1 = now.toEpochSecond();
		System.out.println("서울 시간대 기준 다음날 자정: " + tomorrowMidnight);//현재 날짜를 기준으로 다음날 자정을 계산
		long epochSeconds2 = tomorrowMidnight.toEpochSecond();
		int result = (int)(epochSeconds2-epochSeconds1);
		System.out.println("서울 시간대 기준 하루의 남은 시간 : " + result);
		System.out.println("서울 시간대 기준 하루의 남은 시간 : " + result/(60*60) + "시"+(result/60)%60 + "분"+ result%60 + "초");
		//방문 정보 쿠키를 생성해서 응답
		Cookie cookie = new Cookie("isVisit", String.valueOf(isVisit));
		cookie.setMaxAge(result);//자정까지만 유지
		response.addCookie(cookie);
		
	%>
	
	
	<script>
		location.href = 'main.jsp';//main.jsp로 이동
	</script>
</body>
</html>