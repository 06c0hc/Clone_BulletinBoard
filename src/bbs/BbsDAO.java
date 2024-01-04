package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	//DB서버에 접근
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "gkqjem1212@";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";//데이터베이스 오류
	}
	
	public int getNext() {
		String sqlQuery = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//다음 게시글을 불러옴
			}
			return 1; //게시글이 하나뿐인 경우
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int wrtie(String bbsTitle, String userID, String bbsContent) {
		String sqlQuery = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);//게시글이 작성되었으므로 bbsAvailable 1이 됨
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
}
