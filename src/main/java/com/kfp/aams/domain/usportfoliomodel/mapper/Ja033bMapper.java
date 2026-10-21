package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja033bDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * KRX 지수 선물/옵션 종목 매퍼 (W_JA033B)
 */
@Mapper
public interface Ja033bMapper {

    /**
     * 지수 선물/옵션 종목 목록 조회 (d_ja033b.srd 원본 SQL 100% 보존)
     */
    List<Ja033bDto> selectFoIdxCodeList(@Param("infoType") String infoType);

    /**
     * 지수 선물/옵션 종목 존재 여부 확인
     */
    int existsFoIdxCode(@Param("infoType") String infoType, @Param("stndIscd") String stndIscd);

    /**
     * 지수 선물/옵션 종목 단건 등록 (INSERT)
     */
    int insertFoIdxCode(Ja033bDto dto);

    /**
     * 지수 선물/옵션 종목 단건 수정 (UPDATE)
     */
    int updateFoIdxCode(Ja033bDto dto);

    /**
     * 지수 선물/옵션 종목 등록/수정 (MERGE)
     */
    int mergeFoIdxCode(Ja033bDto dto);

    /**
     * 지수 선물/옵션 종목 삭제 (DELETE)
     */
    int deleteFoIdxCode(@Param("infoType") String infoType, @Param("stndIscd") String stndIscd);
}
