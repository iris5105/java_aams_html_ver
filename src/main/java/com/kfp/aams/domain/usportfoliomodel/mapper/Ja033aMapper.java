package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja033aDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * KRX 주식 선물/옵션 종목 매퍼 (W_JA033A)
 */
@Mapper
public interface Ja033aMapper {

    /**
     * 주식 선물/옵션 종목 목록 조회 (d_ja033a.srd 원본 SQL 100% 보존)
     */
    List<Ja033aDto> selectFoStkCodeList(@Param("infoType") String infoType);

    /**
     * 주식 선물/옵션 종목 존재 여부 확인
     */
    int existsFoStkCode(@Param("infoType") String infoType, @Param("stndIscd") String stndIscd);

    /**
     * 주식 선물/옵션 종목 단건 등록 (INSERT)
     */
    int insertFoStkCode(Ja033aDto dto);

    /**
     * 주식 선물/옵션 종목 단건 수정 (UPDATE)
     */
    int updateFoStkCode(Ja033aDto dto);

    /**
     * 주식 선물/옵션 종목 등록/수정 (MERGE)
     */
    int mergeFoStkCode(Ja033aDto dto);

    /**
     * 주식 선물/옵션 종목 삭제 (DELETE)
     */
    int deleteFoStkCode(@Param("infoType") String infoType, @Param("stndIscd") String stndIscd);
}
