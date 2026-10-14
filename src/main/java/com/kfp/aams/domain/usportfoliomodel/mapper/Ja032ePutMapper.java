package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032ePutDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032ePutFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032ePutPortDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * MyBatis Mapper for W_JA032E_PUT (USPM 운용지시 PUT배분작업)
 */
@Mapper
public interface Ja032ePutMapper {

    /**
     * 펀드/포트 목록 조회 (d_ja032e1_put.srd)
     */
    List<Ja032ePutFundDto> selectFundList(@Param("corpGr") String corpGr, @Param("ymd") LocalDate ymd);

    /**
     * 포트 내 종목 설정 목록 조회 (d_ja032e2_put.srd)
     */
    List<Ja032ePutPortDto> selectPortList(@Param("corpGr") String corpGr,
                                         @Param("fundCd") String fundCd,
                                         @Param("ymd") LocalDate ymd,
                                         @Param("portNum") String portNum);

    /**
     * 해외옵션 상세 시세 및 주문 목록 조회 (d_ja032e3_put.srd)
     */
    List<Ja032ePutDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                             @Param("ymd") LocalDate ymd,
                                             @Param("jmCd") String jmCd,
                                             @Param("targetReturnPer") BigDecimal targetReturnPer,
                                             @Param("jonga") BigDecimal jonga,
                                             @Param("mangi") String mangi);

    /**
     * 옵션 종목 조립 접두사 조회 (SZX0YM 기반)
     */
    String selectOptionJmCdPrefix(@Param("mangiYmd") LocalDate mangiYmd, @Param("srsCd") String srsCd);

    /**
     * TT 세부코드명 조회 (SZX0GR 기반)
     */
    String selectTtTitle(@Param("tt") String tt);

    /**
     * USPM_PORT 갱신 (tt, instDays, mangi, dt, putZ)
     */
    int updateUspmPort(Ja032ePutFundDto dto);

    /**
     * USPM 갱신 (targetReturnPer)
     */
    int updateUspm(Ja032ePutPortDto dto);

    /**
     * SYT1MG 거래순번(TR_SEQ) 채번
     */
    BigDecimal selectNextTrSeq(@Param("corpGr") String corpGr,
                               @Param("ymd") LocalDate ymd,
                               @Param("fundCd") String fundCd,
                               @Param("jmCd") String jmCd,
                               @Param("trCd") String trCd);

    /**
     * SYT1MG 주문 생성
     */
    int insertSyt1mg(@Param("corpGr") String corpGr,
                     @Param("trYmd") LocalDate trYmd,
                     @Param("trCd") String trCd,
                     @Param("fundCd") String fundCd,
                     @Param("trCoCd") String trCoCd,
                     @Param("trustee") String trustee,
                     @Param("jmCd") String jmCd,
                     @Param("currency") String currency,
                     @Param("trSeq") BigDecimal trSeq,
                     @Param("trJusu") BigDecimal trJusu,
                     @Param("trDanga") BigDecimal trDanga,
                     @Param("trAek") BigDecimal trAek);

    /**
     * API_Q 파생종목 큐 생성
     */
    int insertApiQ(@Param("corpGr") String corpGr,
                   @Param("jmCd") String jmCd,
                   @Param("jmNm") String jmNm,
                   @Param("yjCd") String yjCd,
                   @Param("hangsaGa") BigDecimal hangsaGa);

    /**
     * 변동성재계산 오라클 프로시저 호출 (SR_JA032A)
     */
    void callSrJa032a(Map<String, Object> params);
}
