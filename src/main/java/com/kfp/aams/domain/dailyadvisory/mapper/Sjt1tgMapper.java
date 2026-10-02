package com.kfp.aams.domain.dailyadvisory.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Sjt1tgDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Sjt1tgMapper {

    List<Sjt1tgDto> selectSjt1tgList(@Param("ymd") LocalDate ymd);

    List<Sjt1tgDto> selectNewFuturesList(@Param("corpGr") String corpGr,
                                         @Param("ymd") LocalDate ymd,
                                         @Param("junilYmd") LocalDate junilYmd);

    List<Sjt1tgDto> selectStockIndexList(@Param("corpGr") String corpGr,
                                         @Param("ymd") LocalDate ymd);

    List<Sjt1tgDto> selectBondIndexList(@Param("corpGr") String corpGr,
                                        @Param("ymd") LocalDate ymd);
}
