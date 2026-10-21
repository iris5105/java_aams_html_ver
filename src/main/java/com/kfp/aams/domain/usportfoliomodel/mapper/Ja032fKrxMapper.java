package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fKrxDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja991a2Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * KRX 주식종목정보 매퍼 (W_JA032F_KRX)
 */
@Mapper
public interface Ja032fKrxMapper {

    /**
     * KRX 주식 종목정보 목록 조회 (d_ja032f_krx.srd 원본 SQL 보존)
     */
    List<Ja032fKrxDto> selectKrxStockList();

    /**
     * 특정 종목의 일별 시세 목록 조회 (d_ja991a2.srd 원본 SQL 보존, 최근 1년)
     */
    List<Ja991a2Dto> selectDailyPriceList(@Param("koscomCd") String koscomCd,
                                          @Param("ymd") String ymd);

    /**
     * SJM0JJ 등록종목(USPM) 플래그 갱신
     */
    int updateSjm0jjUspm(@Param("jmCd") String jmCd,
                         @Param("uspm") String uspm);

    /**
     * USPM_DD 종목 등록 (w_ja032f_krx.srw::itemchanged 로직)
     */
    int insertUspmDd(@Param("corpGr") String corpGr,
                     @Param("ymd") String ymd,
                     @Param("jmCd") String jmCd,
                     @Param("ovrsExcgCd") String ovrsExcgCd);

    /**
     * USPM_DD 종목 삭제 (해제 시)
     */
    int deleteUspmDd(@Param("corpGr") String corpGr,
                     @Param("ymd") String ymd,
                     @Param("jmCd") String jmCd,
                     @Param("ovrsExcgCd") String ovrsExcgCd);

    /**
     * SJT1TG 일별 시세 업데이트 (d_ja991a2.srd 인라인 편집 저장)
     */
    int updateDailyPrice(Ja991a2Dto dto);
}
