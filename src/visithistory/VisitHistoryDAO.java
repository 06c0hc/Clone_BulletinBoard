package visithistory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class VisitHistoryDAO {
	private Connection conn;
	private ResultSet rs;
	
	public VisitHistoryDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/your db name";
			String dbID = "your dbID";
			String dbPassword = "your dbPW";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	//다음 방문 ID를 확인
	public int getNext() {
		String sqlQuery = "SELECT visitHistoryID FROM VISIT_HISTORY ORDER BY visitHistoryID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//다음 방문 ID를 반환
			}
			return 1;// 첫 방문인 경우
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	//방문일 검색
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);//방문일(현재 날짜및 시간)를 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	
	
	//오늘 방문한 방문자 수
	public int getVisitors() {
		String sqlQuery = "SELECT COUNT(*) FROM VISIT_HISTORY WHERE DATE(visitDate) = DATE(?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setString(1, getDate());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);//방문자 수를 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	//전체 방문자 수
	public int getAllVisitors() {
		String sqlQuery = "SELECT COUNT(*) FROM VISIT_HISTORY";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);//전체 방문자 수를 반환
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	//방문 기록 추가
	public int writeVisitHistory() {
		String sqlQuery = "INSERT INTO VISIT_HISTORY(visitHistoryID, visitDate) VALUES(?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, getDate());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}

}
