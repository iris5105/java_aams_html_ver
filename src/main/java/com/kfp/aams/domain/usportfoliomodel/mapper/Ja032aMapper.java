package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aPortDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface Ja032aMapper {

    /**
     * 마스터 펀드 목록 조회 (d_ja032a1.srd)
     */
    List<Ja032aMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                          @Param("ymd") LocalDate ymd);

    /**
     * 포트 목록 조회 (d_ja032a2.srd)
     */
    List<Ja032aPortDto> selectPortList(@Param("corpGr") String corpGr,
                                      @Param("fundCd") String fundCd,
                                      @Param("trYmd") LocalDate trYmd,
                                      @Param("fundJmPer") BigDecimal fundJmPer);

    /**
     * 종목 상세 목록 조회 (d_ja032a3.srd / d_ja032a3a.srd)
     */
    List<Ja032aDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                          @Param("ymd") LocalDate ymd,
                                          @Param("fundCd") String fundCd,
                                          @Param("portNum") String portNum);

    /**
     * 환율 조회 (SYX1HY)
     */
    BigDecimal selectUsdExchangeRate(@Param("corpGr") String corpGr,
                                     @Param("trYmd") LocalDate trYmd);

    /**
     * 잔존일수 계산 (f_days 또는 오라클 날짜차이)
     */
    Long calculateDays(@Param("fromDate") LocalDate fromDate,
                       @Param("toDate") LocalDate toDate);

    /**
     * 마스터 수정 (SZT0IA_V)
     */
    int updateMaster(Ja032aMasterDto dto);

    /**
     * 마스터 삭제 플래그 처리 (SZT0IA_V DEL='Y')
     */
    int deleteMasterFlag(@Param("corpGr") String corpGr,
                         @Param("trYmd") LocalDate trYmd,
                         @Param("fundCd") String fundCd);

    /**
     * 변동성재계산 프로시저 호출 (SR_JA032A)
     */
    void callSrJa032a(Map<String, Object> params);
}
