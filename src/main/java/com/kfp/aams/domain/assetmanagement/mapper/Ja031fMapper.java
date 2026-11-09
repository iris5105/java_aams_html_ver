package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031fDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031fMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * W_JA031F 채권 매매현황 MyBatis Mapper
 * - d_ja031f.srd: 계좌 목록
 * - d_ja031f1.srd: 채권 매매내역 상세 목록
 */
@Mapper
public interface Ja031fMapper {

    List<Ja031fMasterDto> selectFundList(@Param("corpGr") String corpGr,
                                         @Param("fymd") LocalDate fymd,
                                         @Param("tymd") LocalDate tymd);

    List<Ja031fDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("fymd") LocalDate fymd,
                                           @Param("tymd") LocalDate tymd,
                                           @Param("fundCd") String fundCd);
}

