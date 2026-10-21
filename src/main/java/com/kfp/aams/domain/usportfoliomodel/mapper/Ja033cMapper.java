package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja033cDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * KRX 통화/금리/상품 선물/옵션 종목 매퍼 (W_JA033C)
 */
@Mapper
public interface Ja033cMapper {

    /**
     * 통화/금리/상품 선물/옵션 종목 목록 조회 (d_ja033c.srd 원본 SQL 100% 보존)
     */
    List<Ja033cDto> selectFoComCodeList(@Param("comType") String comType, @Param("infoType") String infoType);

    /**
     * 통화/금리/상품 선물/옵션 종목 존재 여부 확인
     */
    int existsFoComCode(@Param("comType") String comType,
                        @Param("infoType") String infoType,
                        @Param("stndIscd") String stndIscd);

    /**
     * 통화/금리/상품 선물/옵션 종목 단건 등록 (INSERT)
     */
    int insertFoComCode(Ja033cDto dto);

    /**
     * 통화/금리/상품 선물/옵션 종목 단건 수정 (UPDATE)
     */
    int updateFoComCode(Ja033cDto dto);

    /**
     * 통화/금리/상품 선물/옵션 종목 등록/수정 (MERGE)
     */
    int mergeFoComCode(Ja033cDto dto);

    /**
     * 통화/금리/상품 선물/옵션 종목 삭제 (DELETE)
     */
    int deleteFoComCode(@Param("comType") String comType,
                        @Param("infoType") String infoType,
                        @Param("stndIscd") String stndIscd);
}
