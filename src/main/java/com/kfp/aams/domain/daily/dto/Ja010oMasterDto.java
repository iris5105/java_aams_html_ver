package com.kfp.aams.domain.daily.dto;

import lombok.*;
import java.math.BigDecimal;

/**
 * Master Grid DTO for w_ja010o (d_ja010o1.srd / SJM0JM + SJM0JM_COLL + SJM0JJ)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010oMasterDto {
    private String corpGr;             // 회사그룹 (t1.corp_gr)
    private String ymd;                // 기준일자 (t1.ymd, yyyymmdd or yyyy-mm-dd)
    private String fundCd;             // 펀드코드 (t1.fund_cd)
    private String jmCd;               // 종목코드 (t1.jm_cd)
    private BigDecimal collJusu;       // 신용/대출 수량 (t1.coll_jusu)
    private BigDecimal collateral;     // 신용/대출 잔액 (t1.collateral)
    private String collStart;          // 신용/대출 시작일자 (t1.coll_start, yyyy.mm.dd or yyyymmdd)
    private String collEnd;            // 신용/대출 만기일자 (t1.coll_end, yyyy.mm.dd or yyyymmdd)
    
    private String jmFundCd;           // 펀드코드 (jm.fund_cd)
    private String jmJmCd;             // 종목코드 (jm.jm_cd)
    private BigDecimal bfilBoyuJusu;   // 전일보유주수 (jm.bfil_boyu_jusu)
    private BigDecimal upJusu;         // 당일매수주수 (jm.up_jusu)
    private BigDecimal dwJusu;         // 당일매도주수 (jm.dw_jusu)
    private String koscom_cd;          // 코스콤 단축코드 (jm.koscom_cd)
    private String balhCo;             // 발행사코드 (jm.balh_co)
    private String jmStart;            // 종목 담보시작일자 (jm.coll_start)
    private String jmEnd;              // 종목 담보만기일자 (jm.coll_end)
    
    private String jjNm;               // 종목명 (jj.jj_nm)
    private Integer pVisible;          // 만기일 존재 여부 (1 or 0)
    private String collStatus;         // 담보 상태 ('jango' or 'new' or 'load')
    
    // 계산 필드: 당일잔고주수 = 전일보유주수 + 당일매수주수 - 당일매도주수
    public BigDecimal getCompute1() {
        BigDecimal bfil = bfilBoyuJusu != null ? bfilBoyuJusu : BigDecimal.ZERO;
        BigDecimal up = upJusu != null ? upJusu : BigDecimal.ZERO;
        BigDecimal dw = dwJusu != null ? dwJusu : BigDecimal.ZERO;
        return bfil.add(up).subtract(dw);
    }
}
