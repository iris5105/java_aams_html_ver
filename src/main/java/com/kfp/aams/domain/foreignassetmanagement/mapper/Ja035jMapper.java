package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035jDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA035J 수도결제 등록 Mapper (d_ja035j)
 */
@Mapper
public interface Ja035jMapper {

    List<Ja035jDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") String ymd);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    String selectDefaultGyuljeJmCd(@Param("corpGr") String corpGr,
                                   @Param("currency") String currency);

    int updateSyt0ys(Ja035jDto dto);
}
