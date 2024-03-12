package reply;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ReplyDAO {
	private Connection conn;
	private ResultSet rs;
	
	//DB������ ����
	public ReplyDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/your db name";
			String dbID = "your dbID";
			String dbPassword = "your dbPW";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	//�ۼ��� �˻�
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);//�ۼ���(���� ��¥ �� �ð�)�� ��ȯ
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";//�����ͺ��̽� ����
	}
	
	//���� ����� �ִ��� Ȯ��
	public int getNext() {
		String sqlQuery = "SELECT replyID FROM REPLY ORDER BY replyID DESC";//���� �ֱٿ� �ۼ��� ������
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//���� ��� ID�� ��ȯ
			}
			return 1;//����� �ϳ����� ���
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
	//�Խñ��� ��ۿ� �ۼ��� ����� ������(�ִ� 10����)
	public ArrayList<Reply> getReplies(int commentID){
		String sqlQuery = "SELECT * FROM REPLY WHERE commentID = ? AND replyAvailable = 1 ORDER BY replyID LIMIT 10";
		ArrayList<Reply> rpList = new ArrayList<Reply>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Reply reply = new Reply();
				reply.setReplyID(rs.getInt(1));
				reply.setCommentID(rs.getInt(2));
				reply.setUserID(rs.getString(3));
				reply.setReplyDate(rs.getString(4));
				reply.setReplyContent(rs.getString(5));
				reply.setReplyAvailable(rs.getInt(6));
				rpList.add(reply);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return rpList;//��� ��ȯ
	}
	
	//�Խñ��� ��ۿ� �ۼ��� ��� ����� ������
	public ArrayList<Reply> getAllReplies(int commentID){
		String sqlQuery = "SELECT * FROM REPLY WHERE commentID = ? AND replyAvailable = 1 ORDER BY replyID";
		ArrayList<Reply> rpList = new ArrayList<Reply>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Reply reply = new Reply();
				reply.setReplyID(rs.getInt(1));
				reply.setCommentID(rs.getInt(2));
				reply.setUserID(rs.getString(3));
				reply.setReplyDate(rs.getString(4));
				reply.setReplyContent(rs.getString(5));
				reply.setReplyAvailable(rs.getInt(6));
				rpList.add(reply);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return rpList;
	}
	
	//commentID��ۿ� �޸� ����� ������ ��ȯ
	public int count(int commentID) {
		String sqlQuery = "SELECT COUNT(*) FROM REPLY WHERE commentID = ? AND replyAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);//����� ������ ��ȯ
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	//��� �ۼ�
	public int write(int commentID, String userID, String replyContent) {
		String sqlQuery = "INSERT INTO REPLY(replyID, commentID, userID, replyDate, replyContent, replyAvailable) VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, getNext());
			pstmt.setInt(2, commentID);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, replyContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
	//��� ID�� �´� ��� �˻� , ���� �� ���
	public Reply getReply(int replyID, int commentID) {
		String sqlQuery = "SELECT * FROM REPLY WHERE replyID = ? AND commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, replyID);
			pstmt.setInt(2, commentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Reply reply = new Reply();
				reply.setReplyID(rs.getInt(1));
				reply.setCommentID(rs.getInt(2));
				reply.setUserID(rs.getString(3));
				reply.setReplyDate(rs.getString(4));
				reply.setReplyContent(rs.getString(5));
				reply.setReplyAvailable(rs.getInt(6));
				return reply;//��� ��ȯ
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	//��� ����
	public int update(int replyID, String replyContent) {
		String sqlQuery = "UPDATE REPLY SET replyContent = ? WHERE replyID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setString(1, replyContent);
			pstmt.setInt(2, replyID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
	//��� ����
	public int delete(int replyID) {
		String sqlQuery = "UPDATE REPLY SET replyAvailable = 0 WHERE replyID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, replyID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
}
