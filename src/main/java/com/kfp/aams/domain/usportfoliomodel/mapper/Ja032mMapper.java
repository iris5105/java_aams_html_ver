package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032mDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032mFundDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 종목별 위험값 (W_JA032M) MyBatis Mapper
 */
@Mapper
public interface Ja032mMapper {

    /**
     * 1. 펀드 목록 조회 (d_ja032m1.srd)
     */
    List<Ja032mFundDto> selectFundList(@Param("corpGr") String corpGr,
                                       @Param("ymd") String ymd);

    /**
     * 2. 종목별 위험값 상세 목록 조회 (d_ja032m2.srd)
     */
    List<Ja032mDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("ymd") String ymd,
                                           @Param("fundCd") String fundCd);
}
