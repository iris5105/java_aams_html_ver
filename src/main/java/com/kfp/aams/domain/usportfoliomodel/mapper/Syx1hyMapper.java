package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Syx1hyDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

/**
 * 환율등록 MyBatis 매퍼 (d_syx1hy_2501.srd)
 */
@Mapper
public interface Syx1hyMapper {

    /**
     * 통화별 기준환율 목록 조회 (최근 1년)
     */
    List<Syx1hyDto> selectExchangeRateList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * SYX1HY 환율 UPSERT (MERGE INTO)
     */
    int mergeExchangeRate(@Param("corpGr") String corpGr,
                          @Param("ymd") String ymd,
                          @Param("currency") String currency,
                          @Param("gijunRt") BigDecimal gijunRt);
}
