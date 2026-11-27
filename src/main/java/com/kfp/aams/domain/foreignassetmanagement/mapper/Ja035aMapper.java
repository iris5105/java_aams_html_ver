package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035aDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA035A 외화 단기유동자산 종목 등록 MyBatis 매퍼
 */
@Mapper
public interface Ja035aMapper {

    List<Ja035aDto> selectList(@Param("corpGr") String corpGr);

    int insertItem(Ja035aDto dto);

    int updateItem(Ja035aDto dto);

    int deleteItem(@Param("corpGr") String corpGr,
                   @Param("jmCd") String jmCd,
                   @Param("jasanGb") String jasanGb);

    String selectCurrencyByNation(@Param("nationCd") String nationCd);

    String selectIdDaeCd(@Param("ymdGb") String ymdGb, @Param("ymdId") String ymdId);
}
