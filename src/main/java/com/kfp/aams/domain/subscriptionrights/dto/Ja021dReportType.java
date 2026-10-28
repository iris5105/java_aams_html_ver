package com.kfp.aams.domain.subscriptionrights.dto;

/** d_ja021d.srd 출력구분 및 w_ja021d.srw RD 파라미터 매핑. */
public enum Ja021dReportType {
    CASH_EXPECTED("10", "현금예상배당", "1", "G10"),
    STOCK_EXPECTED("20", "주식예상배당", "2", "G10"),
    CASH_BOARD("30", "현금이사회배당", "3", "G20"),
    STOCK_BOARD("40", "주식이사회배당", "4", "G20"),
    CASH_INTERIM("50", "현금중간배당", "3", "G15"),
    STOCK_INTERIM("60", "주식중간배당", "4", "G15"),
    CASH_INTERIM_CONFIRMED("61", "현금중간확정배당", "3", "G23"),
    STOCK_INTERIM_CONFIRMED("62", "주식중간확정배당", "4", "G23"),
    CASH_GENERAL_MEETING("70", "현금주총배당", "3", "G25"),
    STOCK_GENERAL_MEETING("80", "주식주총배당", "4", "G25");

    private final String code;
    private final String name;
    private final String gb;
    private final String trCd;

    Ja021dReportType(String code, String name, String gb, String trCd) {
        this.code = code;
        this.name = name;
        this.gb = gb;
        this.trCd = trCd;
    }

    public String getCode() { return code; }
    public String getName() { return name; }
    public String getGb() { return gb; }
    public String getTrCd() { return trCd; }
}
