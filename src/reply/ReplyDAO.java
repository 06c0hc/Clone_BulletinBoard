package reply;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ReplyDAO {
	private Connection conn;
	private ResultSet rs;
	
	//DB서버에 접근
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
	
	//작성일 검색
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try {
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
	
	//다음 답글이 있는지 확인
	public int getNext() {
		String sqlQuery = "SELECT replyID FROM REPLY ORDER BY replyID DESC";//가장 최근에 작성한 순으로
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//다음 답글 ID를 반환
			}
			return 1;//답글이 하나뿐인 경우
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	//게시글의 댓글에 작성된 답글을 보여줌(최대 10개씩)
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
		return rpList;//답글 반환
	}
	
	//게시글의 댓글에 작성된 모든 답글을 보여줌
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
	
	//commentID댓글에 달린 답글의 개수를 반환
	public int count(int commentID) {
		String sqlQuery = "SELECT COUNT(*) FROM REPLY WHERE commentID = ? AND replyAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, commentID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);//답글의 갯수를 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	//답글 작성
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
		return -1;//데이터베이스 오류
	}
	
	//답글 ID에 맞는 답글 검색 , 수정 시 사용
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
				return reply;//답글 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	//답글 수정
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
		return -1;//데이터베이스 오류
	}
	
	//답글 삭제
	public int delete(int replyID) {
		String sqlQuery = "UPDATE REPLY SET replyAvailable = 0 WHERE replyID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, replyID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
}
