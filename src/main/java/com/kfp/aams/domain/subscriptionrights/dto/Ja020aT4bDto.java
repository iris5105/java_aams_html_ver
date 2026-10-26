package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA020A 탭2: 배정등록 하단 펀드별 배정내역 DTO (d_ja020a_t4b)
 */
@Getter
@Setter
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020aT4bDto {

    private String corpGr;
    private String jcJoin;
    private String jgTrCoCd;
    private String fundCd;
    private String fundNm;
    private String xxFundCd;

    private BigDecimal sunJasanAek; // 전일순자산
    private BigDecimal scJusu;      // 신청주수
    private BigDecimal scAek;       // 신청금액

    private BigDecimal cyJusu;      // 청약수량 (편집 가능)
    private BigDecimal cyDanga;     // 청약단가 (편집/계산용)
    private BigDecimal cyAek;       // 청약금액 (편집 가능)
    private BigDecimal cyJkm;       // 청약증거금 (편집 가능)
    private BigDecimal cySusu;      // 청약수수료 (편집 가능)
    private BigDecimal cyGyuljeAek; // 청약결제액 (cyAek + cySusu - cyJkm)

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate lockEnd;      // 매도제한일

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate f47Ymd;
    private Integer pVisible;
    private String ipUser;

    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

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
}
