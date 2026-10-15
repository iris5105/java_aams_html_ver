package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bFundDetailDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * 기준정보 펀드 일별현황 (W_JA032B_FUND) MyBatis 매퍼
 */
@Mapper
public interface Ja032bFundMapper {

    /**
     * 펀드별 일별현황 상세 목록 조회 (d_ja032b_fund2.srd)
     */
    List<Ja032bFundDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                               @Param("ymd") LocalDate ymd,
                                               @Param("fundCd") String fundCd);
}
