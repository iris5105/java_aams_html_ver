package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035nDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * W_JA035N 해외보관처수수료등록 Mapper (d_ja035n)
 */
@Mapper
public interface Ja035nMapper {

    List<Ja035nDto> selectList(@Param("corpGr") String corpGr,
                               @Param("trYmd") String trYmd,
                               @Param("trCd") String trCd);

    List<Map<String, Object>> selectAutoCreateRows(@Param("corpGr") String corpGr,
                                                   @Param("trYmd") String trYmd,
                                                   @Param("trCd") String trCd);

    Map<String, Object> selectHaejiBalance(@Param("corpGr") String corpGr,
                                           @Param("workDate") String workDate,
                                           @Param("fundCd") String fundCd,
                                           @Param("trCd") String trCd,
                                           @Param("trustee") String trustee,
                                           @Param("currency") String currency);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    String selectOpenYmd(@Param("ymd") String ymd,
                         @Param("offset") String offset);

    String selectTrusteeCurrency(@Param("corpGr") String corpGr,
                                 @Param("trustee") String trustee);

    BigDecimal selectGijunRt(@Param("corpGr") String corpGr,
                             @Param("gijunYmd") String gijunYmd,
                             @Param("currency") String currency);

    int insertSyt0ma(Ja035nDto dto);

    int updateSyt0ma(Ja035nDto dto);

    int deleteSyt0ma(Ja035nDto dto);
}
