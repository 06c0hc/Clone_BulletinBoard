package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

//BBS 데이터 접근 객체
public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	//DB서버에 접근
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost/Your db name";
			String dbID = "Your dbID";
			String dbPassword = "Your dbPW";
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
				return rs.getString(1);//작성일(현재 날짜 및 시간) 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";//데이터베이스 오류
	}
	//다음 게시글이 있는지 확인
	public int getNext() {
		String sqlQuery = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//다음 게시글 ID를 반환
			}
			return 1; //게시글이 하나뿐인 경우
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	//게시글 등록을 위한 데이터 추가
	public int wrtie(String bbsTitle, String userID, String bbsContent) {
		String sqlQuery = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);//게시글이 작성되었으므로 bbsAvailable을 1로 설정
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
		//pageNumber에 보여질 게시글을 가져옴(페이지당 최대 게시글 수는 10개 까지임)
		public ArrayList<Bbs> getList(int pageNumber){
				String sqlQuery = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
				ArrayList<Bbs> list = new ArrayList<Bbs>();
				try{
					PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);//pageNumber에 보여질 게시글 수(= sqlQuery에서 bbsID와 비교할 '?'에 해당)
					rs = pstmt.executeQuery();
					while(rs.next()) {
						Bbs bbs = new Bbs();
						bbs.setBbsID(rs.getInt(1));
						bbs.setBbsTitle(rs.getString(2));
						bbs.setUserID(rs.getString(3));
						bbs.setBbsDate(rs.getString(4));
						bbs.setBbsContent(rs.getString(5));
						bbs.setBbsAvailable(rs.getInt(6));
						list.add(bbs);
					}
				}catch(Exception e) {
						e.printStackTrace();
				}
				return list;
		}

		//pageNuber가 존재하는지 확인
		public boolean nextPage(int pageNumber) {
				String sqlQuery = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
				try{
					PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
					rs = pstmt.executeQuery();
					if(rs.next()) {//다음 페이지로 이동이 가능한지 체크(다음 게시글이 1개 이상 존재하는지) 
						return true;
					}
				}catch(Exception e) {
					e.printStackTrace();
				}
				return false;
		}
		
		//게시글ID에 맞는 게시글을 검색
		public Bbs getBbs(int bbsID) {
			String sqlQuery = "SELECT * FROM BBS WHERE bbsID = ?";
			try{
				PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
				pstmt.setInt(1, bbsID);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					Bbs bbs = new Bbs();
					bbs.setBbsID(rs.getInt(1));
					bbs.setBbsTitle(rs.getString(2));
					bbs.setUserID(rs.getString(3));
					bbs.setBbsDate(rs.getString(4));
					bbs.setBbsContent(rs.getString(5));
					bbs.setBbsAvailable(rs.getInt(6));
					return bbs;
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
			return null;//게시글 ID와 일치하는 게시글이 없다면 null 반환
		}
		
		//게시글 수정
		public int update(int bbsID, String bbsTitle, String bbsContent) {
			String sqlQuery = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
				pstmt.setString(1, bbsTitle);
				pstmt.setString(2, bbsContent);
				pstmt.setInt(3, bbsID);
				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
		
		//게시글 삭제
		public int delete(int bbsID) {
			String sqlQuery = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";// bbsAvailable 값만 수정하여 DB 데이터를 직접 삭제하지 않아도 삭제된것처럼 동작하게 됨
			try {
				PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
				pstmt.setInt(1, bbsID);
				return pstmt.executeUpdate();//실행된 결과의 데이터(행) 개수, 없는 경우 0을 반환
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류
		}
}
