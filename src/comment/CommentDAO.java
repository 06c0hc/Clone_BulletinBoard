package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CommentDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	//DB서버에 접근
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
	
	//다음 댓글이 있는지 확인
	public int getNext() {
		String sqlQuery = "SELECT commentID FROM COMMENT ORDER BY commentID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//다음 댓글ID를 반환
			}
			return 1;//댓글이 하나뿐인 경우
		}catch(Exception e){
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	//현재 게시글 보기 페이지에서 보여질 댓글(최대 10개까지만 보여줌)
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
	
	
	//현재 게시글에 작성된 모든 댓글을 보여줌
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
	
	
	//작성일 검색
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try{
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);//작성일(현재 날짜 및 시간)을 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";//데이터베이스 오류
	}
	
	//댓글 데이터 추가
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
		return -1;//데이터베이스 오류
	}
	
	//댓글 ID에 맞는 댓글 검색
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
				return cmt;//댓글 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;//댓글이 없으면 null을 반환
	}
	
	//댓글 수정
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
		return -1;//데이터베이스 오류
	}
	
	//댓글 삭제
	public int delete(int commentID) {
		String sqlQuery = "UPDATE COMMENT SET commentAvailable = 0 WHERE commentID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, commentID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
}
