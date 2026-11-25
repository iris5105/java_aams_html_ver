package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036cDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA036C 유상청약납입 Mapper (d_ja036c)
 */
@Mapper
public interface Ja036cMapper {

    List<Ja036cDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") String ymd);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    String selectDefaultGyuljeJmCd(@Param("corpGr") String corpGr,
                                   @Param("currency") String currency);

    int updateSyt0ys(Ja036cDto dto);
}
