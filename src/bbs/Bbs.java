package bbs;

//�Խ���(BBS) �ڹٺ��� ��ü
public class Bbs {
	private int bbsID;//�Խñ� ID
	private String bbsTitle;// �Խñ� ����
	private String userID;//�ۼ��� ID
	private String bbsDate;//�ۼ���
	private String bbsContent;//�Խñ� ����
	private int bbsAvailable;////���� �Խñ��� ���� ����(1�̸� ����, 0�̸� �������� ����(������))
	
	public int getBbsID() {
		return bbsID;
	}
	public void setBbsID(int bbsID) {
		this.bbsID = bbsID;
	}
	public String getBbsTitle() {
		return bbsTitle;
	}
	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getBbsDate() {
		return bbsDate;
	}
	public void setBbsDate(String bbsDate) {
		this.bbsDate = bbsDate;
	}
	public String getBbsContent() {
		return bbsContent;
	}
	public void setBbsContent(String bbsContent) {
		this.bbsContent = bbsContent;
	}
	public int getBbsAvailable() {
		return bbsAvailable;
	}
	public void setBbsAvailable(int bbsAvailable) {
		this.bbsAvailable = bbsAvailable; 
	}
	
	
}
