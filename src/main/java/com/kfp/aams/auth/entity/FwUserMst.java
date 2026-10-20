package com.kfp.aams.auth.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "FW_USER_MST")
public class FwUserMst {

    @Column(name = "SYS_ID", length = 10, nullable = false)
    private String sysId;

    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "USER_ID", length = 10, nullable = false)
    private String userId;

    @Column(name = "USER_NM", length = 80)
    private String userNm;

    @Column(name = "ADMIN_YN", length = 1)
    private String adminYn;

    @Column(name = "MANAGER_YN", length = 1)
    private String managerYn;

    @Column(name = "WATCHMAN_YN", length = 1)
    private String watchmanYn;

    @Column(name = "ENC_E_MAIL", length = 90)
    private String encEMail;

    @Column(name = "IN_YMD")
    private LocalDate inYmd;

    @Column(name = "OUT_YMD")
    private LocalDate outYmd;

    @Column(name = "DEPT_CD", length = 4)
    private String deptCd;

    @Column(name = "DEPT_NM", length = 40)
    private String deptNm;

    @Column(name = "REG_NUM", length = 30)
    private String regNum;

    @Column(name = "UN_SYMD")
    private LocalDate unSymd;

    @Column(name = "ENC_TEL_NO", length = 30)
    private String encTelNo;

    @Column(name = "ENC_PW", length = 80)
    private String encPw;

    @Column(name = "PW_CNT")
    private Integer pwCnt;

    @Column(name = "PW_CHG")
    private LocalDate pwChg;

    @Column(name = "LAST_CONNECT")
    private LocalDateTime lastConnect;

    @Column(name = "BOOKMARK_START", length = 1)
    private String bookmarkStart;

    public FwUserMst() {}

    public FwUserMst(String sysId, String corpGr, String userId, String userNm, String adminYn, String managerYn,
                     String watchmanYn, String encEMail, LocalDate inYmd, LocalDate outYmd, String deptCd,
                     String deptNm, String regNum, LocalDate unSymd, String encTelNo, String encPw, Integer pwCnt,
                     LocalDate pwChg, LocalDateTime lastConnect, String bookmarkStart) {
        this.sysId = sysId;
        this.corpGr = corpGr;
        this.userId = userId;
        this.userNm = userNm;
        this.adminYn = adminYn;
        this.managerYn = managerYn;
        this.watchmanYn = watchmanYn;
        this.encEMail = encEMail;
        this.inYmd = inYmd;
        this.outYmd = outYmd;
        this.deptCd = deptCd;
        this.deptNm = deptNm;
        this.regNum = regNum;
        this.unSymd = unSymd;
        this.encTelNo = encTelNo;
        this.encPw = encPw;
        this.pwCnt = pwCnt;
        this.pwChg = pwChg;
        this.lastConnect = lastConnect;
        this.bookmarkStart = bookmarkStart;
    }

    public static FwUserMstBuilder builder() {
        return new FwUserMstBuilder();
    }

    public String getSysId() { return sysId; }
    public void setSysId(String sysId) { this.sysId = sysId; }

    public String getCorpGr() { return corpGr; }
    public void setCorpGr(String corpGr) { this.corpGr = corpGr; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserNm() { return userNm; }
    public void setUserNm(String userNm) { this.userNm = userNm; }

    public String getAdminYn() { return adminYn; }
    public void setAdminYn(String adminYn) { this.adminYn = adminYn; }

    public String getManagerYn() { return managerYn; }
    public void setManagerYn(String managerYn) { this.managerYn = managerYn; }

    public String getWatchmanYn() { return watchmanYn; }
    public void setWatchmanYn(String watchmanYn) { this.watchmanYn = watchmanYn; }

    public String getEncEMail() { return encEMail; }
    public void setEncEMail(String encEMail) { this.encEMail = encEMail; }

    public LocalDate getInYmd() { return inYmd; }
    public void setInYmd(LocalDate inYmd) { this.inYmd = inYmd; }

    public LocalDate getOutYmd() { return outYmd; }
    public void setOutYmd(LocalDate outYmd) { this.outYmd = outYmd; }

    public String getDeptCd() { return deptCd; }
    public void setDeptCd(String deptCd) { this.deptCd = deptCd; }

    public String getDeptNm() { return deptNm; }
    public void setDeptNm(String deptNm) { this.deptNm = deptNm; }

    public String getRegNum() { return regNum; }
    public void setRegNum(String regNum) { this.regNum = regNum; }

    public LocalDate getUnSymd() { return unSymd; }
    public void setUnSymd(LocalDate unSymd) { this.unSymd = unSymd; }

    public String getEncTelNo() { return encTelNo; }
    public void setEncTelNo(String encTelNo) { this.encTelNo = encTelNo; }

    public String getEncPw() { return encPw; }
    public void setEncPw(String encPw) { this.encPw = encPw; }

    public Integer getPwCnt() { return pwCnt; }
    public void setPwCnt(Integer pwCnt) { this.pwCnt = pwCnt; }

    public LocalDate getPwChg() { return pwChg; }
    public void setPwChg(LocalDate pwChg) { this.pwChg = pwChg; }

    public LocalDateTime getLastConnect() { return lastConnect; }
    public void setLastConnect(LocalDateTime lastConnect) { this.lastConnect = lastConnect; }

    public String getBookmarkStart() { return bookmarkStart; }
    public void setBookmarkStart(String bookmarkStart) { this.bookmarkStart = bookmarkStart; }

    public static class FwUserMstBuilder {
        private String sysId;
        private String corpGr;
        private String userId;
        private String userNm;
        private String adminYn;
        private String managerYn;
        private String watchmanYn;
        private String encEMail;
        private LocalDate inYmd;
        private LocalDate outYmd;
        private String deptCd;
        private String deptNm;
        private String regNum;
        private LocalDate unSymd;
        private String encTelNo;
        private String encPw;
        private Integer pwCnt;
        private LocalDate pwChg;
        private LocalDateTime lastConnect;
        private String bookmarkStart;

        public FwUserMstBuilder sysId(String sysId) { this.sysId = sysId; return this; }
        public FwUserMstBuilder corpGr(String corpGr) { this.corpGr = corpGr; return this; }
        public FwUserMstBuilder userId(String userId) { this.userId = userId; return this; }
        public FwUserMstBuilder userNm(String userNm) { this.userNm = userNm; return this; }
        public FwUserMstBuilder adminYn(String adminYn) { this.adminYn = adminYn; return this; }
        public FwUserMstBuilder managerYn(String managerYn) { this.managerYn = managerYn; return this; }
        public FwUserMstBuilder watchmanYn(String watchmanYn) { this.watchmanYn = watchmanYn; return this; }
        public FwUserMstBuilder encEMail(String encEMail) { this.encEMail = encEMail; return this; }
        public FwUserMstBuilder inYmd(LocalDate inYmd) { this.inYmd = inYmd; return this; }
        public FwUserMstBuilder outYmd(LocalDate outYmd) { this.outYmd = outYmd; return this; }
        public FwUserMstBuilder deptCd(String deptCd) { this.deptCd = deptCd; return this; }
        public FwUserMstBuilder deptNm(String deptNm) { this.deptNm = deptNm; return this; }
        public FwUserMstBuilder regNum(String regNum) { this.regNum = regNum; return this; }
        public FwUserMstBuilder unSymd(LocalDate unSymd) { this.unSymd = unSymd; return this; }
        public FwUserMstBuilder encTelNo(String encTelNo) { this.encTelNo = encTelNo; return this; }
        public FwUserMstBuilder encPw(String encPw) { this.encPw = encPw; return this; }
        public FwUserMstBuilder pwCnt(Integer pwCnt) { this.pwCnt = pwCnt; return this; }
        public FwUserMstBuilder pwChg(LocalDate pwChg) { this.pwChg = pwChg; return this; }
        public FwUserMstBuilder lastConnect(LocalDateTime lastConnect) { this.lastConnect = lastConnect; return this; }
        public FwUserMstBuilder bookmarkStart(String bookmarkStart) { this.bookmarkStart = bookmarkStart; return this; }

        public FwUserMst build() {
            return new FwUserMst(sysId, corpGr, userId, userNm, adminYn, managerYn, watchmanYn, encEMail, inYmd,
                    outYmd, deptCd, deptNm, regNum, unSymd, encTelNo, encPw, pwCnt, pwChg, lastConnect, bookmarkStart);
        }
    }
}
