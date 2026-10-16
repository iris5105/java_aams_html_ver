package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pDayDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032pFundDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 기준정보 옵션종목 일별현황 (W_JA032P) MyBatis 매퍼 인터페이스
 */
@Mapper
public interface Ja032pMapper {

    /**
     * 1. 펀드 목록 조회 (d_ja032m1.srd)
     */
    List<Ja032pFundDto> selectFundList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 2. 옵션종목 보유현황 조회 (d_ja032p2.srd)
     */
    List<Ja032pDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("ymd") String ymd,
                                           @Param("fundCd") String fundCd);

    /**
     * 3. 옵션종목 일별추이 조회 (d_ja032p3.srd)
     */
    List<Ja032pDayDto> selectDayList(@Param("corpGr") String corpGr,
                                     @Param("ymd") String ymd,
                                     @Param("fundCd") String fundCd,
                                     @Param("jmCd") String jmCd,
                                     @Param("trustee") String trustee);
}
