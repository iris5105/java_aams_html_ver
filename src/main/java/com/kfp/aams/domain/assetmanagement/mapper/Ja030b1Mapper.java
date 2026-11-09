package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030b1Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * d_ja030b1.srd (SJT0JG + SZM0IA 조인 조회)
 */
@Mapper
public interface Ja030b1Mapper {

    List<Ja030b1Dto> selectFundList(@Param("corpGr") String corpGr,
                                    @Param("fymd") LocalDate fymd,
                                    @Param("tymd") LocalDate tymd);
}

