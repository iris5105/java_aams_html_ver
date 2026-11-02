package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031dDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * W_JA031D (타사)수익증권 매매내역 등록 MyBatis 매퍼
 */
@Mapper
public interface Ja031dMapper {

    // 1. 목록 조회 (d_ja031d.srd)
    List<Ja031dDto> selectList(@Param("corpGr") String corpGr,
                               @Param("trYmd") LocalDate trYmd,
                               @Param("trCd") String trCd);

    // 2. 달력 하이라이트 일자 조회 (w_ja031d.srw dw_c::ue_getdate)
    List<String> selectDates(@Param("corpGr") String corpGr);

    // 3. 일련번호 최대값 채번 (w_ja031d.srw updatestart)
    Long selectMaxSeqNo(@Param("corpGr") String corpGr,
                        @Param("trYmd") LocalDate trYmd,
                        @Param("trCd") String trCd);

    // 4. 펀드 수탁사 정보 조회 (w_ja031d.srw fund_cd 변경)
    Map<String, Object> selectFundCustodian(@Param("corpGr") String corpGr,
                                            @Param("fundCd") String fundCd);

    // 5. 타사종목 정보 조회 (거래단위, 타사펀드코드, 펀드명)
    Map<String, Object> selectTasaJmInfo(@Param("corpGr") String corpGr,
                                        @Param("tasaJmCd") String tasaJmCd);

    // 6. 기준가/과표가 조회 (sjt0sc 또는 pzm1ti)
    Map<String, Object> selectGijunga(@Param("corpGr") String corpGr,
                                      @Param("ymd") LocalDate ymd,
                                      @Param("jmCd") String jmCd,
                                      @Param("tasaFundCd") String tasaFundCd);

    // 7. 잔여좌수 조회 (전부매도 K61 더블클릭 연동)
    Map<String, Object> selectResidualJwa(@Param("corpGr") String corpGr,
                                         @Param("ymd") LocalDate ymd,
                                         @Param("fundCd") String fundCd,
                                         @Param("tasaJmCd") String tasaJmCd);

    // 8. CUD 작업
    int insertSjt5sg(Ja031dDto dto);

    int updateSjt5sg(Ja031dDto dto);

    int deleteSjt5sg(Ja031dDto dto);
}

