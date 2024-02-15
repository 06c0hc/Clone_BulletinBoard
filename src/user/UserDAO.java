package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//User ������ ���� ��ü
public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	//DB ����
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost/Your db Name";
			String dbID = "your dbID";
			String dbPassword = "your dbPW";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	//�α����� ���� ������ �˻�
	public int login(String userID, String userPassword) {
		String sqlQuery = "SELECT userPassword FROM USER WHERE userID = ?";
		try{
			pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setString(1,userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) {
					return 1; // �α��� ����
				}else {
					return 0; //��й�ȣ ����ġ
				}
			}
			return -1; //���̵� ����
		}catch(Exception e){
			e.printStackTrace();
		}
		return -2; //�����ͺ��̽� ���� �ڵ�
	}
	
	//ȸ�������� ���� ������ �߰�
	public int join(User user) {
		String sqlQuery = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();//����� ����� ������(��) ����, ���� ��� 0�� ��ȯ
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
}
