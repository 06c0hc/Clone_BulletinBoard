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
	
	//���� �湮 ID�� Ȯ��
	public int getNext() {
		String sqlQuery = "SELECT visitHistoryID FROM VISIT_HISTORY ORDER BY visitHistoryID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//���� �湮 ID�� ��ȯ
			}
			return 1;// ù �湮�� ���
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
	//�湮�� �˻�
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);//�湮��(���� ��¥�� �ð�)�� ��ȯ
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //�����ͺ��̽� ����
	}
	
	
	
	//���� �湮�� �湮�� ��
	public int getVisitors() {
		String sqlQuery = "SELECT COUNT(*) FROM VISIT_HISTORY WHERE DATE(visitDate) = DATE(?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setString(1, getDate());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);//�湮�� ���� ��ȯ
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	//��ü �湮�� ��
	public int getAllVisitors() {
		String sqlQuery = "SELECT COUNT(*) FROM VISIT_HISTORY";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);//��ü �湮�� ���� ��ȯ
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	//�湮 ��� �߰�
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
		return -1;//�����ͺ��̽� ����
	}

}
