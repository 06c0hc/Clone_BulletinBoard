package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

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
	//���� �Խñ��� �ִ��� Ȯ��
	public int getNext() {
		String sqlQuery = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;//���� �Խñ� ID�� ��ȯ
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
	
	//pageNumber�� ������ �Խñ��� ������(�������� �ִ� �Խñ� ���� 10�� ������)
		public ArrayList<Bbs> getList(int pageNumber){//
				String sqlQuery = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
				ArrayList<Bbs> list = new ArrayList<Bbs>();
				try{
					PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);//pageNumber�� ������ �Խñ� ��(= sqlQuery���� bbsID�� ���� '?'�� �ش�)
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

		//pageNuber�� �����ϴ��� Ȯ��
		public boolean nextPage(int pageNumber) {
				String sqlQuery = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
				try{
					PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
					pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
					rs = pstmt.executeQuery();
					if(rs.next()) {//���� �������� �̵��� �������� üũ(���� �Խñ��� 1�� �̻� �����ϴ���) 
						return true;
					}
				}catch(Exception e) {
					e.printStackTrace();
				}
				return false;
		}
		
		//�Խñ��� ������
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
			return null;
		}
	
}
