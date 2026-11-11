package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031jDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031jGa191Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface Ja031jMapper {

    /**
     * GA 테이블 자료 존재 여부 카운트
     */
    int countGaData(@Param("corpGr") String corpGr, @Param("ym") String ym);

    /**
     * 금감원 보고서 자료생성 프로시저 호출 (KFP.SR_JA031J)
     */
    void callSrJa031j(Map<String, Object> params);

    /**
     * 금감원 보고서 데이터 목록 조회 (d_ja031j.srd)
     */
    List<Ja031jDto> selectGaList(@Param("corpGr") String corpGr, @Param("ym") String ym);

    /**
     * 점검자료 데이터 목록 조회 (d_ja031j_ga191.srd)
     */
    List<Ja031jGa191Dto> selectGa191List(@Param("corpGr") String corpGr, @Param("ym") String ym);

    /**
     * 회사명 조회 (SZX0AA.COMPANY_NAME)
     */
    String selectCorpNm(@Param("corpGr") String corpGr);
}

