package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cBetaDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cGreeksDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cPortDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cUpDownDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cVolatilityDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C) MyBatis 매퍼 인터페이스
 */
@Mapper
public interface Ja032cMapper {

    /**
     * 1. 펀드/포트 목록 조회 (d_ja032c1.srd)
     */
    List<Ja032cPortDto> selectPortList(@Param("corpGr") String corpGr,
                                       @Param("ymd") String ymd);

    /**
     * 2-1. 포트 내 종목 상세 현황 (해외, d_ja032c2.srd)
     */
    List<Ja032cDetailDto> selectDetailListForeign(@Param("corpGr") String corpGr,
                                                  @Param("ymd") String ymd,
                                                  @Param("fundCd") String fundCd,
                                                  @Param("portNum") String portNum);

    /**
     * 2-2. 포트 내 종목 상세 현황 (국내, d_ja032c2_krx.srd)
     */
    List<Ja032cDetailDto> selectDetailListDomestic(@Param("corpGr") String corpGr,
                                                   @Param("ymd") String ymd,
                                                   @Param("fundCd") String fundCd,
                                                   @Param("portNum") String portNum);

    /**
     * 3. 변동수준 / 괴리율 분석 조회 (d_ja032c3.srd)
     */
    List<Ja032cVolatilityDto> selectVolatilityList(@Param("corpGr") String corpGr,
                                                   @Param("jmCd") String jmCd,
                                                   @Param("fymd") String fymd,
                                                   @Param("tymd") String tymd,
                                                   @Param("type") String type);

    /**
     * 4-1. 베타 분석 (해외, d_ja032c3_beta.srd)
     */
    List<Ja032cBetaDto> selectBetaForeign(@Param("corpGr") String corpGr,
                                          @Param("jisuJm") String jisuJm,
                                          @Param("jmCd") String jmCd,
                                          @Param("fymd") String fymd,
                                          @Param("tymd") String tymd);

    /**
     * 4-2. 베타 분석 (국내, d_ja032c3_beta_krx.srd)
     */
    List<Ja032cBetaDto> selectBetaDomestic(@Param("corpGr") String corpGr,
                                           @Param("jisuJm") String jisuJm,
                                           @Param("jmCd") String jmCd,
                                           @Param("fymd") String fymd,
                                           @Param("tymd") String tymd);

    /**
     * 5-1. 상승/하락일수 (해외, d_ja032c3_ud.srd)
     */
    List<Ja032cUpDownDto> selectUpDownForeign(@Param("corpGr") String corpGr,
                                              @Param("jmCd") String jmCd,
                                              @Param("fymd") String fymd,
                                              @Param("tymd") String tymd);

    /**
     * 5-2. 상승/하락일수 (국내, d_ja032c3_ud_krx.srd)
     */
    List<Ja032cUpDownDto> selectUpDownDomestic(@Param("corpGr") String corpGr,
                                               @Param("jmCd") String jmCd,
                                               @Param("fymd") String fymd,
                                               @Param("tymd") String tymd);

    /**
     * 6. 델타/감마/세타/베가/로 기초 조회 (d_ja032c3_dgtvr.srd)
     */
    List<Ja032cGreeksDto> selectGreeks(@Param("corpGr") String corpGr,
                                       @Param("ymd") String ymd,
                                       @Param("fundCd") String fundCd,
                                       @Param("portNum") String portNum,
                                       @Param("jmCd") String jmCd);

    /**
     * 7. 가장 근접한 PUT 옵션 종목코드 조회 (w_ja032c.srw 로직)
     */
    String selectClosestPutOptionJmCd(@Param("mangi") String mangi,
                                      @Param("srsCd") String srsCd,
                                      @Param("hangsaGa") BigDecimal hangsaGa);

    /**
     * 8. 옵션 종가 조회 (SYT0LP)
     */
    BigDecimal selectOptionJonga(@Param("corpGr") String corpGr,
                                 @Param("ymd") String ymd,
                                 @Param("jmCd") String jmCd);

    /**
     * 9. 내재변동성 단일 계산 (F_IMP_VOLATILITY)
     */
    BigDecimal selectImpVolatility(@Param("s") BigDecimal s,
                                   @Param("k") BigDecimal k,
                                   @Param("t") BigDecimal t,
                                   @Param("r") BigDecimal r,
                                   @Param("marketPrice") BigDecimal marketPrice);

    /**
     * 10. 그릭스(Delta, Gamma, Vega, Theta, Rho) 단일 계산 (F_DGTVR_COM)
     */
    Ja032cGreeksDto selectGreeksCom(@Param("s") BigDecimal s,
                                    @Param("t") BigDecimal t,
                                    @Param("k") BigDecimal k,
                                    @Param("r") BigDecimal r,
                                    @Param("sigma") BigDecimal sigma);
}
