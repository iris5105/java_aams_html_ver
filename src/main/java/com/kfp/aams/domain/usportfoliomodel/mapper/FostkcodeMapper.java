package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.FostkcodeDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 해외파생 종목코드 매퍼 (W_FOSTKCODE)
 */
@Mapper
public interface FostkcodeMapper {

    /**
     * 해외파생 종목코드 목록 조회 (d_fostkcode.srd 원본 SQL 보존)
     *
     * @param corpGr 회사그룹 코드
     * @param ym     만기월 (YYYYMM)
     * @param symbol 옵션구분 (C: CALL, P: PUT, 빈값/null: 전체)
     * @return 종목코드 목록
     */
    List<FostkcodeDto> selectFostkcodeList(@Param("corpGr") String corpGr,
                                           @Param("ym") String ym,
                                           @Param("symbol") String symbol);

    /**
     * 해외파생 종목코드 단건 등록/수정 (UPSERT)
     *
     * @param dto 종목코드 DTO
     * @return 반영 건수
     */
    int mergeFostkcode(FostkcodeDto dto);

    /**
     * 종목코드 존재 여부 확인
     *
     * @param srscd 종목코드
     * @return 건수
     */
    int existsBySrscd(@Param("srscd") String srscd);
}
