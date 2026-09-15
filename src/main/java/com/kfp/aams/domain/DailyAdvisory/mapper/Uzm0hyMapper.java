package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.GuganDto;
import com.kfp.aams.domain.daily.dto.Uzm0hyDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Uzm0hyMapper {

    List<Uzm0hyDto> selectUzm0hyList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    GuganDto selectGugan(@Param("corpGr") String corpGr, @Param("fundCd") String fundCd, @Param("ymd") String ymd);
}
