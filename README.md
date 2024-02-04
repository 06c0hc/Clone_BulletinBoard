# JSP 게시판 웹 사이트
유튜버 나동빈님의 [JSP게시판 만들기 강좌](https://www.youtube.com/playlist?list=PLRx0vPvlEmdAZv_okJzox5wj2gG_fNh_6)를 클론 코딩해서 만든 게시판 프로젝트입니다. 현재 이 게시판에 추가해보고 싶은 사항들을 기획하고 적용해보고 있습니다.
#

# 기간
2024/01/01 ~ 2024/01/08 : 게시판 구현
2024/01/27 ~ 2024/02/05 : HTTPS 통신 구현
#

# 사용한 기술 스택
+ OS : Windows10 64bit
+ Langauge : JAVA SE 8(JDK 8u151), JSP
+ Web Server : Apache Tomcat 8.5.35
+ DBMS : MySQL 5.7.18
+ Framework : Bootstrap 3.3.7
+ Protocol : HTTP(S)
#

# 프로젝트를 만들어보면서 알게된 것들
+ Network
  - HTTP 통신 방식에 세션을 사용하여 상태정보를 유지(statusful)하는 방법을 알게 되었다.
  - SSL 인증서를 적용하여 HTTPS 통신을 구현하는 방법을 알게 되었다.
+ DB
  - DAO(Data Access Object)를 이용하여 DB에 접근 및 데이터를 처리하는 방법을 알 수 있었다.
+ Security
  - PreparedStatement와 바인딩 변수를 사용하여 SQL주입(SQLInjection)을 방지하는 방법을 알게 되었다.
  - 특수문자 처리를 통해 크로스 사이트 스크립팅(XSS)을 방지하는 방법을 알게 되었다.
+ etc
  - CAFE24 웹서버 호스팅을 이용하여 직접 웹 프로젝트를 배포해봄으로써 웹 프로젝트의 배포 과정을 알 수 있었다.
#

# 이 프로젝트에 추가로 적용할 사항들

+ 기능 추가 : 게시판 방문자 수 체크, 댓글 달기
+ 통신 방식을 HTTP -> HTTPS 로 변경(적용 완료) : [HTTPS 통신 구현 과정 정리](https://itknowledgewarehouse.tistory.com/213)
+ 연동된 DBMS를  MySQL -> MariaDB로 변경

#

# 사이트 URL

현재 CAFE24 호스팅 서버에 배포된 상태입니다. 아래 링크중 하나를 누르면 사이트로 접속할 수 있습니다.

<https://devchh006.cafe24.com/BBS/main.jsp>
