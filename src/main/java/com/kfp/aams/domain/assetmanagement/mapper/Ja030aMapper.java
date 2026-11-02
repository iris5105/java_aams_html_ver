package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030aDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/** d_ja030a1.srd의 SJT5J1 + SZM0IA 조인 조회. */
@Mapper
public interface Ja030aMapper {
    List<Ja030aDto> selectList(@Param("corpGr") String corpGr,
                               @Param("trYmd") LocalDate trYmd,
                               @Param("trCd") String trCd,
                               @Param("jmCd") String jmCd);
}
