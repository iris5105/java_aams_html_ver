package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035hDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * W_JA035H 외화 NOTE이자수령 Mapper (d_ja035h)
 */
@Mapper
public interface Ja035hMapper {

    List<Ja035hDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") String ymd);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    BigDecimal selectCurrencyRt(@Param("corpGr") String corpGr,
                                @Param("ymd") String ymd,
                                @Param("currency") String currency);

    String selectItemCurrency(@Param("corpGr") String corpGr,
                              @Param("jmCd") String jmCd);

    String selectTrusteeCurrency(@Param("corpGr") String corpGr,
                                 @Param("trustee") String trustee);

    String selectDefaultGyuljeJmCd(@Param("corpGr") String corpGr,
                                   @Param("currency") String currency);

    Long selectMaxTrSeq(@Param("corpGr") String corpGr,
                        @Param("ymd") String ymd,
                        @Param("fundCd") String fundCd);

    int insertSyt0ys(Ja035hDto dto);

    int updateSyt0ys(Ja035hDto dto);

    int deleteSyt0ys(Ja035hDto dto);
}
