package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CommentDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	//DB������ ����
	public CommentDAO() {
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
	
	//���� ����� �ִ��� Ȯ��
	public int getNext() {
		String sqlQuery = "SELECT commentID FROM COMMENT ORDER BY commentID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//���� ���ID�� ��ȯ
			}
			return 1;//����� �ϳ����� ���
		}catch(Exception e){
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
	//���� �Խñ� ���� ���������� ������ ���(�ִ� 10�������� ������)
	public ArrayList<Comment> getComments(int bbsID){
		String sqlQuery = "SELECT * FROM COMMENT WHERE bbsID = ? AND commentAvailable = 1 ORDER BY commentID LIMIT 10";
		ArrayList<Comment> cmtList = new ArrayList<>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Comment cmt = new Comment();
				cmt.setCommentID(rs.getInt(1));
				cmt.setUserID(rs.getString(2));
				cmt.setBbsID(rs.getInt(3));
				cmt.setCommentDate(rs.getString(4));
				cmt.setCommentContent(rs.getString(5));
				cmt.setCommentAvailable(rs.getInt(6));
				cmtList.add(cmt);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return cmtList;
	}
	
	
	//���� �Խñۿ� �ۼ��� ��� ����� ������
	public ArrayList<Comment> getAllComments(int bbsID){
		String sqlQuery = "SELECT * FROM COMMENT WHERE bbsID = ? AND commentAvailable = 1 ORDER BY commentID";
		ArrayList<Comment> cmtList = new ArrayList<>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Comment cmt = new Comment();
				cmt.setCommentID(rs.getInt(1));
				cmt.setUserID(rs.getString(2));
				cmt.setBbsID(rs.getInt(3));
				cmt.setCommentDate(rs.getString(4));
				cmt.setCommentContent(rs.getString(5));
				cmt.setCommentAvailable(rs.getInt(6));
				cmtList.add(cmt);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return cmtList;
	}
	
	
	//�ۼ��� �˻�
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try{
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
	
	//��� ������ �߰�
	public int write(String userID, int bbsID, String commentContent) {
		String sqlQuery = "INSERT INTO COMMENT(commentID, userID, bbsID, commentDate, commentContent, commentAvailable) VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, userID);
			pstmt.setInt(3, bbsID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, commentContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
	//��� ID�� �´� ��� �˻�
	public Comment getComment(int commentID) {
		String sqlQuery = "SELECT * FROM COMMENT WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Comment cmt = new Comment();
				cmt.setCommentID(rs.getInt(1));
				cmt.setUserID(rs.getString(2));
				cmt.setBbsID(rs.getInt(3));
				cmt.setCommentDate(rs.getString(4));
				cmt.setCommentContent(rs.getString(5));
				cmt.setCommentAvailable(rs.getInt(6));
				return cmt;//��� ��ȯ
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;//����� ������ null�� ��ȯ
	}
	
	//��� ����
	public int update(int commentID, String commentContent) {
		String sqlQuery = "UPDATE COMMENT SET commentContent = ? WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setString(1, commentContent);
			pstmt.setInt(2, commentID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
	//��� ����
	public int delete(int commentID) {
		String sqlQuery = "UPDATE COMMENT SET commentAvailable = 0 WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, commentID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//�����ͺ��̽� ����
	}
	
}
