package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	//DB������ ����
	public UserDAO() {
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
	
	//�α���
	public int login(String userID, String userPassword) {
		String SQLquery = "SELECT userPassword FROM USER WHERE userID = ?";
		try{
			pstmt = conn.prepareStatement(SQLquery);
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
}
