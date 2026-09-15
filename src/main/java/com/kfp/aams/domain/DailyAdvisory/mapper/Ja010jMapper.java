package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010jDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010jMapper {

    List<Ja010jDto> selectJa010jList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);
}
