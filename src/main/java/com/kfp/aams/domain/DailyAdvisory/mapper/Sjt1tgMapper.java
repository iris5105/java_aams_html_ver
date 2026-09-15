package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Sjt1tgDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Sjt1tgMapper {

    List<Sjt1tgDto> selectSjt1tgList(@Param("ymd") String ymd);

    int insertSjt1tg(Sjt1tgDto dto);

    int updateSjt1tg(Sjt1tgDto dto);

    int deleteSjt1tg(@Param("ymd") String ymd, @Param("sjCd") String sjCd);

    List<Sjt1tgDto> selectNewFuturesList(@Param("corpGr") String corpGr,
                                         @Param("ymd") String ymd,
                                         @Param("junilYmd") String junilYmd);

    List<Sjt1tgDto> selectStockIndexList(@Param("corpGr") String corpGr,
                                         @Param("ymd") String ymd);

    List<Sjt1tgDto> selectBondIndexList(@Param("corpGr") String corpGr,
                                        @Param("ymd") String ymd);
}
