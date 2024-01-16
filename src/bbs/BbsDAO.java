package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

//BBS ������ ���� ��ü
public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	//DB������ ����
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
	
	//�ۼ��� �˻�
	public String getDate() {
		String sqlQuery = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);//�ۼ���(���� ��¥ �� �ð�) ��ȯ
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
	
	//�Խñ� ����� ���� ������ �߰�
	public int wrtie(String bbsTitle, String userID, String bbsContent) {
		String sqlQuery = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);//�Խñ��� �ۼ��Ǿ����Ƿ� bbsAvailable�� 1�� ����
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
		//pageNumber�� ������ �Խñ��� ������(�������� �ִ� �Խñ� ���� 10�� ������)
		public ArrayList<Bbs> getList(int pageNumber){
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
		
		//�Խñ�ID�� �´� �Խñ��� �˻�
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
			return null;//�Խñ� ID�� ��ġ�ϴ� �Խñ��� ���ٸ� null ��ȯ
		}
		
		//�Խñ� ����
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
			return -1; //�����ͺ��̽� ����
		}
		
		//�Խñ� ����
		public int delete(int bbsID) {
			String sqlQuery = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";// bbsAvailable ���� �����Ͽ� DB �����͸� ���� �������� �ʾƵ� �����Ȱ�ó�� �����ϰ� ��
			try {
				PreparedStatement pstmt = conn.prepareStatement(sqlQuery);
				pstmt.setInt(1, bbsID);
				return pstmt.executeUpdate();//����� ����� ������(��) ����, ���� ��� 0�� ��ȯ
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //�����ͺ��̽� ����
		}
}
