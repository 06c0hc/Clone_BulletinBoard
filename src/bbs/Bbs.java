package bbs;

//게시판(BBS) 자바빈즈 객체
public class Bbs {
	private int bbsID;//게시글 ID
	private String bbsTitle;// 게시글 제목
	private String userID;//작성자 ID
	private String bbsDate;//작성일
	private String bbsContent;//게시글 내용
	private int bbsAvailable;////현재 게시글의 존재 여부(1이면 존재, 0이면 존재하지 않음(삭제됨))
	
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
