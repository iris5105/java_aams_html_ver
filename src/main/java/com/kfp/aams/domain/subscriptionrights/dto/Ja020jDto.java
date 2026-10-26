package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA020J (현금 펀드/종목별 시가등록) DTO
 * d_ja020j.srd 메타데이터 매핑
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020jDto {

    private String corpGr;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;

    private String fundCd;
    private String fundNm;
    private String xxFundCd;

    private String jmCd;
    private String hjNm;
    private String xxHjNm;

    private String pgCd;

    private BigDecimal aekm;     // 보유액면
    private BigDecimal aek;      // 보유취득액
    private BigDecimal sigaAek;  // 시가평가액 (편집 가능)
    private String ipUser;       // 입력자

    // CUD 상태 관리 필드 (규칙 02 준수)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // 양방향 명칭 프로퍼티 호환성 지원 (Zero-Serialization-Loss)
    public String getXxFundCd() {
        return xxFundCd != null ? xxFundCd : fundNm;
    }

    public void setXxFundCd(String xxFundCd) {
        this.xxFundCd = xxFundCd;
        if (this.fundNm == null) this.fundNm = xxFundCd;
    }

    public String getFundNm() {
        return fundNm != null ? fundNm : xxFundCd;
    }

    public void setFundNm(String fundNm) {
        this.fundNm = fundNm;
        if (this.xxFundCd == null) this.xxFundCd = fundNm;
    }

    public String getXxHjNm() {
        return xxHjNm != null ? xxHjNm : hjNm;
    }

    public void setXxHjNm(String xxHjNm) {
        this.xxHjNm = xxHjNm;
        if (this.hjNm == null) this.hjNm = xxHjNm;
    }

    public String getHjNm() {
        return hjNm != null ? hjNm : xxHjNm;
    }

    public void setHjNm(String hjNm) {
        this.hjNm = hjNm;
        if (this.xxHjNm == null) this.xxHjNm = hjNm;
    }
}
