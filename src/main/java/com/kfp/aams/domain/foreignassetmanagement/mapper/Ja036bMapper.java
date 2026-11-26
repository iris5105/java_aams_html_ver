package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036bDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA036B 외화배당금 수령등록 Mapper (d_ja036b)
 */
@Mapper
public interface Ja036bMapper {

    List<Ja036bDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") String ymd);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    String selectDefaultGyuljeJmCd(@Param("corpGr") String corpGr,
                                   @Param("currency") String currency);

    int updateSyt0ygPyunga(Ja036bDto dto);

    int updateSyt0ygChuriYmd(@Param("ygRowid") String ygRowid,
                             @Param("churiYmd") String churiYmd);
}
