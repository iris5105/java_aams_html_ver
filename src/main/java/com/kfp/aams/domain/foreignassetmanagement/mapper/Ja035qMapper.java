package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035qDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA035Q 미지급/미수금 이월내역 관리 Mapper (d_ja035q)
 */
@Mapper
public interface Ja035qMapper {

    List<Ja035qDto> selectList(@Param("corpGr") String corpGr,
                               @Param("trYmd") String trYmd,
                               @Param("workdate") String workdate);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    int updateSyt0mc(Ja035qDto dto);

    int deleteSyt0mc(Ja035qDto dto);
}
