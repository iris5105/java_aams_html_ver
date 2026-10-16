package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bOptStockDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 기준정보 옵션위험값 일별현황 (W_JA032B_OPT) 매퍼 인터페이스
 */
@Mapper
public interface Ja032bOptMapper {

    /**
     * 조회기준일에 해당하는 포트 시작일(fymd) 조회
     */
    String selectFymd(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 1. 펀드 목록 조회 (d_ja032n1.srd)
     */
    List<Ja032bOptFundDto> selectFundList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 2. 종목 목록 조회 (d_ja032b.srd)
     */
    List<Ja032bOptStockDto> selectStockList(@Param("corpGr") String corpGr,
                                           @Param("fymd") String fymd,
                                           @Param("tymd") String tymd,
                                           @Param("fundCd") String fundCd);

    /**
     * 3-1. 해외 옵션위험값 일별현황 상세 조회 (d_ja032b_opt.srd)
     */
    List<Ja032bOptDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                             @Param("fundCd") String fundCd,
                                             @Param("jmCd") String jmCd,
                                             @Param("fymd") String fymd,
                                             @Param("tymd") String tymd);

    /**
     * 3-2. 국내(KRX) 옵션위험값 일별현황 상세 조회 (d_ja032b_opt_krx.srd)
     */
    List<Ja032bOptDetailDto> selectDetailKrxList(@Param("corpGr") String corpGr,
                                                @Param("fundCd") String fundCd,
                                                @Param("jmCd") String jmCd,
                                                @Param("fymd") String fymd,
                                                @Param("tymd") String tymd);
}
