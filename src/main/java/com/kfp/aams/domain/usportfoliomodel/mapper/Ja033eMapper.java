package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja033eDetailDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * 포트/종목별 종가대비 행사가격 (W_JA033E) MyBatis 매퍼
 */
@Mapper
public interface Ja033eMapper {

    /**
     * 포트/종목별 종가대비 행사가격 상세 목록 조회 (d_ja033e2.srd)
     */
    List<Ja033eDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("ymd") LocalDate ymd,
                                           @Param("fundCd") String fundCd);
}
