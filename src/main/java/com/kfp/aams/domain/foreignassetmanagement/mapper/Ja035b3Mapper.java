package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035b3Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * W_JA035B3 해외선물 매매등록 Mapper (d_ja035b3)
 */
@Mapper
public interface Ja035b3Mapper {

    List<Ja035b3Dto> selectList(@Param("corpGr") String corpGr,
                                @Param("ymd") String ymd,
                                @Param("trCd") String trCd);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr,
                                      @Param("trCd") String trCd);

    Long selectMaxTrSeq(@Param("corpGr") String corpGr,
                        @Param("ymd") String ymd,
                        @Param("fundCd") String fundCd);

    BigDecimal selectUnitAek(@Param("corpGr") String corpGr,
                             @Param("jmCd") String jmCd);

    Map<String, Object> selectTrusteeInfo(@Param("corpGr") String corpGr,
                                          @Param("ymd") String ymd,
                                          @Param("trustee") String trustee);

    String selectTrusteeBankCd(@Param("corpGr") String corpGr,
                               @Param("trustee") String trustee);

    String selectSjGb(@Param("trCd") String trCd);

    int insertSyt0mg(Ja035b3Dto dto);

    int updateSyt0mg(Ja035b3Dto dto);

    int deleteSyt0mg(Ja035b3Dto dto);
}
