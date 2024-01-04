package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	//DB������ ����
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
		return "";//�����ͺ��̽� ����
	}
	
	public int getNext() {
		String sqlQuery = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//���� �Խñ��� �ҷ���
			}
			return 1; //�Խñ��� �ϳ����� ���
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
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
			pstmt.setInt(6, 1);//�Խñ��� �ۼ��Ǿ����Ƿ� bbsAvailable 1�� ��
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
}