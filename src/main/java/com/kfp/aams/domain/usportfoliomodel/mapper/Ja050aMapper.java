package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja050aFundDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja050aMapper {

    /**
     * w_ja050a 고객(펀드) 목록 조회 (d_ja050a1.srd 매핑)
     *
     * @param corpGr 회사그룹코드
     * @param ymd    조회일자 (YYYY-MM-DD 또는 YYYYMMDD)
     * @param mgCd   증권사코드 (기본값 '%')
     * @return 펀드 목록
     */
    List<Ja050aFundDto> selectFundList(@Param("corpGr") String corpGr,
                                       @Param("ymd") String ymd,
                                       @Param("mgCd") String mgCd);
}
