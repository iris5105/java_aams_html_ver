package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035mDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * W_JA035M 해외보관처수익등록 Mapper (d_ja035m)
 */
@Mapper
public interface Ja035mMapper {

    List<Ja035mDto> selectList(@Param("corpGr") String corpGr,
                               @Param("trYmd") String trYmd,
                               @Param("trCd") String trCd);

    List<Map<String, Object>> selectAutoCreateRows(@Param("corpGr") String corpGr,
                                                   @Param("trYmd") String trYmd,
                                                   @Param("trCd") String trCd);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    String selectTrusteeCurrency(@Param("corpGr") String corpGr,
                                 @Param("trustee") String trustee);

    BigDecimal selectGijunRt(@Param("corpGr") String corpGr,
                             @Param("gijunYmd") String gijunYmd,
                             @Param("currency") String currency);

    int insertSyt0ma(Ja035mDto dto);

    int updateSyt0ma(Ja035mDto dto);

    int deleteSyt0ma(Ja035mDto dto);
}
