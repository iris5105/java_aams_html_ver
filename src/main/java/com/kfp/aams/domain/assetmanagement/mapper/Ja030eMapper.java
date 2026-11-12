package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030eDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030eMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * W_JA030E 채권 종목정보 및 보유현황 MyBatis 매퍼 인터페이스 (Rule 03)
 */
@Mapper
public interface Ja030eMapper {

    /**
     * 상단 보유 채권 종목 목록 조회 (d_ja030e1 원본 쿼리)
     */
    List<Ja030eMasterDto> selectJa030eMasterList(@Param("corpGr") String corpGr,
                                                 @Param("ymd") String ymd);

    /**
     * 채권 종목 기본 헤더 정보 조회 (단건)
     */
    Ja030eDetailDto selectJa030eHeaderInfo(@Param("corpGr") String corpGr,
                                          @Param("jmCd") String jmCd,
                                          @Param("ymd") String ymd);

    /**
     * 하단 펀드별 보유현황 목록 조회 (프로시저 Fallback 직결 쿼리)
     */
    List<Ja030eDetailDto> selectJa030eDetailList(@Param("corpGr") String corpGr,
                                                 @Param("jmCd") String jmCd,
                                                 @Param("ymd") String ymd);

    /**
     * 운용사명 조회 (SZX0AA)
     */
    String selectCompanyName(@Param("corpGr") String corpGr);
}

