package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja030cDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * MyBatis Mapper for w_ja030c (Multi-table join: SCT0CG + SZM0IA + SCM0CJ)
 * Adheres to Guideline 4.
 */
@Mapper
public interface Ja030cMapper {
    List<Ja030cDto> selectJa030cList(@Param("corpGr") String corpGr, @Param("trYmd") String trYmd);
}
