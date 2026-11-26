package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036eDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA036E 펀드별 배당내역(리포트) Mapper (d_ja036e)
 */
@Mapper
public interface Ja036eMapper {

    List<Ja036eDto> selectList(@Param("corpGr") String corpGr,
                               @Param("mgCd") String mgCd,
                               @Param("ymd") String ymd);
}
