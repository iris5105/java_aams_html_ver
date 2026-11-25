package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035cDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface Ja035cMapper {
    List<Ja035cDto> selectList(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("trCd") String trCd);
    Long selectMaxTrSeq(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("trCd") String trCd);
    BigDecimal selectCurrencyRate(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("currency") String currency);
    String selectTrusteeCurrency(@Param("corpGr") String corpGr, @Param("trustee") String trustee);
    String selectTrusteeBankCurrency(@Param("corpGr") String corpGr, @Param("trustee") String trustee);
    int insert(Ja035cDto dto);
    int update(Ja035cDto dto);
    int delete(Ja035cDto dto);
}
