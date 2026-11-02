package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030hDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja030hMapper {
    List<Ja030hDto> selectList(@Param("corpGr") String corpGr, @Param("trYmd") LocalDate trYmd,
                               @Param("trCd") String trCd, @Param("fundCd") String fundCd);

    List<Ja030hDto> selectInitialHoldings(@Param("corpGr") String corpGr, @Param("trYmd") LocalDate trYmd,
                                          @Param("trCd") String trCd, @Param("fundCd") String fundCd);
}
