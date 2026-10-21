package com.kfp.aams.domain.usportfoliomodel.dto;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * KRX 주식종목정보 (d_ja032f_krx.srd / W_JA032F_KRX) DTO
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja032fKrxDto {

    private String jmCd;          // 종목코드
    private String koscom_cd;     // 단축코드
    private String jjFnm;         // 종목전체명
    private String jjNm;          // 종목한글명
    private String jjEnm;         // 종목영문명
    private String balhCo;        // 발행기관
    private String woosIlbanGb;   // 주권종류
    private String chgGb;         // 전환종류
    private String newOldGb;      // 신주종류
    private String dancGb;        // 시장구분
    private BigDecimal balhGa;    // 발행가
    private String sangjYmd;      // 상장일
    private BigDecimal sangjJusu; // 상장주수
    private String kospigubun;    // KOSPI200 구분
    private String xxBalhNation;  // 발행국가
    private String uspm;          // 등록종목 (1: 등록, 0/null: 미등록)

    // 상태 관리 필드 (규정 02-3)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    public String getKoscomCd() {
        return koscom_cd;
    }

    public void setKoscomCd(String koscomCd) {
        this.koscom_cd = koscomCd;
    }
}
