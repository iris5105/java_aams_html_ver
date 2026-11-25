package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035kDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * W_JA035K 해외수익증권 매매내역 Mapper (d_ja035k)
 */
@Mapper
public interface Ja035kMapper {

    List<Ja035kDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") String ymd,
                               @Param("trCd") String trCd);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    Long selectMaxTrSeq(@Param("corpGr") String corpGr,
                        @Param("ymd") String ymd,
                        @Param("fundCd") String fundCd);

    Map<String, Object> selectTrusteeInfo(@Param("corpGr") String corpGr,
                                          @Param("ymd") String ymd,
                                          @Param("trustee") String trustee);

    BigDecimal selectCurrencyRate(@Param("corpGr") String corpGr,
                                  @Param("ymd") String ymd,
                                  @Param("currency") String currency);

    int insertSyt0mg(Ja035kDto dto);

    int updateSyt0mg(Ja035kDto dto);

    int deleteSyt0mg(Ja035kDto dto);
}
