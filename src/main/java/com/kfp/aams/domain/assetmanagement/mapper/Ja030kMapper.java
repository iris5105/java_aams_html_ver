package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030kDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 원리금 상환 명세표 Mapper
 * - 일반 회사: d_ja030k1 (UCS0BH + UHM0HP UNION ALL / SR_JA030K)
 * - 리셋자산운용 (2402): d_ja030k1_2402 (UZM0SH + SZM0IA)
 */
@Mapper
public interface Ja030kMapper {

    /**
     * 일반 회사 원리금 상환 명세표 조회 (d_ja030k1)
     */
    List<Ja030kDto> selectListGeneral(@Param("corpGr") String corpGr,
                                      @Param("fymd") String fymd,
                                      @Param("tymd") String tymd);

    /**
     * 2402 리셋자산운용 원리금 상환 명세표 조회 (d_ja030k1_2402)
     */
    List<Ja030kDto> selectList2402(@Param("corpGr") String corpGr,
                                   @Param("fymd") String fymd,
                                   @Param("tymd") String tymd);

    /**
     * 2402 UZM0SH 수령이자/세금/수령액 업데이트
     */
    int updateUzm0sh(Ja030kDto dto);
}

