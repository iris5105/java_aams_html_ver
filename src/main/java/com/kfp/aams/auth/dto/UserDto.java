package com.kfp.aams.auth.dto;

public class UserDto {
    private String sysId;
    private String corpGr;
    private String userId;
    private String userNm;
    private String adminYn;
    private String managerYn;
    private String watchmanYn;
    private String encEMail;
    private String inYmd;
    private String outYmd;
    private String deptCd;
    private String deptNm;
    private String regNum;
    private String unSymd;
    private String encTelNo;
    private String encPw;
    private Integer pwCnt;
    private String pwChg;
    private String lastConnect;
    private String bookmarkStart;

    // Additional UI Context attributes
    private String companyName;
    private String hyunYmd;
    private String customerGr;

    public UserDto() {}

    public UserDto(String sysId, String corpGr, String userId, String userNm, String adminYn, String managerYn,
                   String watchmanYn, String encEMail, String inYmd, String outYmd, String deptCd, String deptNm,
                   String regNum, String unSymd, String encTelNo, String encPw, Integer pwCnt, String pwChg,
                   String lastConnect, String bookmarkStart, String companyName, String hyunYmd, String customerGr) {
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
        this.companyName = companyName;
        this.hyunYmd = hyunYmd;
        this.customerGr = customerGr;
    }

    public static UserDtoBuilder builder() {
        return new UserDtoBuilder();
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

    public String getInYmd() { return inYmd; }
    public void setInYmd(String inYmd) { this.inYmd = inYmd; }

    public String getOutYmd() { return outYmd; }
    public void setOutYmd(String outYmd) { this.outYmd = outYmd; }

    public String getDeptCd() { return deptCd; }
    public void setDeptCd(String deptCd) { this.deptCd = deptCd; }

    public String getDeptNm() { return deptNm; }
    public void setDeptNm(String deptNm) { this.deptNm = deptNm; }

    public String getRegNum() { return regNum; }
    public void setRegNum(String regNum) { this.regNum = regNum; }

    public String getUnSymd() { return unSymd; }
    public void setUnSymd(String unSymd) { this.unSymd = unSymd; }

    public String getEncTelNo() { return encTelNo; }
    public void setEncTelNo(String encTelNo) { this.encTelNo = encTelNo; }

    public String getEncPw() { return encPw; }
    public void setEncPw(String encPw) { this.encPw = encPw; }

    public Integer getPwCnt() { return pwCnt; }
    public void setPwCnt(Integer pwCnt) { this.pwCnt = pwCnt; }

    public String getPwChg() { return pwChg; }
    public void setPwChg(String pwChg) { this.pwChg = pwChg; }

    public String getLastConnect() { return lastConnect; }
    public void setLastConnect(String lastConnect) { this.lastConnect = lastConnect; }

    public String getBookmarkStart() { return bookmarkStart; }
    public void setBookmarkStart(String bookmarkStart) { this.bookmarkStart = bookmarkStart; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getHyunYmd() { return hyunYmd; }
    public void setHyunYmd(String hyunYmd) { this.hyunYmd = hyunYmd; }

    public String getCustomerGr() { return customerGr; }
    public void setCustomerGr(String customerGr) { this.customerGr = customerGr; }

    public static class UserDtoBuilder {
        private String sysId;
        private String corpGr;
        private String userId;
        private String userNm;
        private String adminYn;
        private String managerYn;
        private String watchmanYn;
        private String encEMail;
        private String inYmd;
        private String outYmd;
        private String deptCd;
        private String deptNm;
        private String regNum;
        private String unSymd;
        private String encTelNo;
        private String encPw;
        private Integer pwCnt;
        private String pwChg;
        private String lastConnect;
        private String bookmarkStart;
        private String companyName;
        private String hyunYmd;
        private String customerGr;

        public UserDtoBuilder sysId(String sysId) { this.sysId = sysId; return this; }
        public UserDtoBuilder corpGr(String corpGr) { this.corpGr = corpGr; return this; }
        public UserDtoBuilder userId(String userId) { this.userId = userId; return this; }
        public UserDtoBuilder userNm(String userNm) { this.userNm = userNm; return this; }
        public UserDtoBuilder adminYn(String adminYn) { this.adminYn = adminYn; return this; }
        public UserDtoBuilder managerYn(String managerYn) { this.managerYn = managerYn; return this; }
        public UserDtoBuilder watchmanYn(String watchmanYn) { this.watchmanYn = watchmanYn; return this; }
        public UserDtoBuilder encEMail(String encEMail) { this.encEMail = encEMail; return this; }
        public UserDtoBuilder inYmd(String inYmd) { this.inYmd = inYmd; return this; }
        public UserDtoBuilder outYmd(String outYmd) { this.outYmd = outYmd; return this; }
        public UserDtoBuilder deptCd(String deptCd) { this.deptCd = deptCd; return this; }
        public UserDtoBuilder deptNm(String deptNm) { this.deptNm = deptNm; return this; }
        public UserDtoBuilder regNum(String regNum) { this.regNum = regNum; return this; }
        public UserDtoBuilder unSymd(String unSymd) { this.unSymd = unSymd; return this; }
        public UserDtoBuilder encTelNo(String encTelNo) { this.encTelNo = encTelNo; return this; }
        public UserDtoBuilder encPw(String encPw) { this.encPw = encPw; return this; }
        public UserDtoBuilder pwCnt(Integer pwCnt) { this.pwCnt = pwCnt; return this; }
        public UserDtoBuilder pwChg(String pwChg) { this.pwChg = pwChg; return this; }
        public UserDtoBuilder lastConnect(String lastConnect) { this.lastConnect = lastConnect; return this; }
        public UserDtoBuilder bookmarkStart(String bookmarkStart) { this.bookmarkStart = bookmarkStart; return this; }
        public UserDtoBuilder companyName(String companyName) { this.companyName = companyName; return this; }
        public UserDtoBuilder hyunYmd(String hyunYmd) { this.hyunYmd = hyunYmd; return this; }
        public UserDtoBuilder customerGr(String customerGr) { this.customerGr = customerGr; return this; }

        public UserDto build() {
            return new UserDto(sysId, corpGr, userId, userNm, adminYn, managerYn, watchmanYn, encEMail, inYmd,
                    outYmd, deptCd, deptNm, regNum, unSymd, encTelNo, encPw, pwCnt, pwChg, lastConnect, bookmarkStart,
                    companyName, hyunYmd, customerGr);
        }
    }
}
