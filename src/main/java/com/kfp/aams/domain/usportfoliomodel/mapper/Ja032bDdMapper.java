package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bDdStockDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 기준정보 종목 일별현황 (W_JA032B_DD) 매퍼 인터페이스
 */
@Mapper
public interface Ja032bDdMapper {

    /**
     * 조회기준일에 해당하는 포트 시작일(fymd) 조회
     */
    String selectFymd(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 1. 펀드 목록 조회 (d_ja032n1.srd)
     */
    List<Ja032bDdFundDto> selectFundList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 2. 종목 목록 조회 (d_ja032b.srd)
     */
    List<Ja032bDdStockDto> selectStockList(@Param("corpGr") String corpGr,
                                          @Param("fymd") String fymd,
                                          @Param("tymd") String tymd,
                                          @Param("fundCd") String fundCd);

    /**
     * 3-1. 해외 종목 일별현황 조회 (d_ja032b_dd.srd)
     */
    List<Ja032bDdDetailDto> selectOverseasDetailList(@Param("corpGr") String corpGr,
                                                    @Param("jmCd") String jmCd,
                                                    @Param("fymd") String fymd,
                                                    @Param("tymd") String tymd);

    /**
     * 3-2. 국내(KRX) 종목 일별현황 조회 (d_ja032b_dd_krx.srd)
     */
    List<Ja032bDdDetailDto> selectKrxDetailList(@Param("corpGr") String corpGr,
                                               @Param("jmCd") String jmCd,
                                               @Param("fymd") String fymd,
                                               @Param("tymd") String tymd);

    /**
     * 영업일(기본 작업일자) 조회
     */
    String selectWorkDate(@Param("corpGr") String corpGr);
}
