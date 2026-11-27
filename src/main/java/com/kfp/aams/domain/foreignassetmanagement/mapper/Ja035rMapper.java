package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035rDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA035R 외화주식 종목등록 MyBatis 매퍼
 */
@Mapper
public interface Ja035rMapper {

    List<Ja035rDto> selectList(@Param("corpGr") String corpGr);

    int insertItem(Ja035rDto item);

    int updateItem(Ja035rDto item);

    int deleteItem(@Param("corpGr") String corpGr,
                   @Param("jmCd") String jmCd,
                   @Param("jasanGb") String jasanGb);

    String selectCurrencyByNation(@Param("nationCd") String nationCd);

    String selectNationByCurrency(@Param("currency") String currency);

    String selectNationByStockGb(@Param("sebuCd") String sebuCd);
}
