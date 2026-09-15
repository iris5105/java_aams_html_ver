package com.kfp.aams.domain.DailyAdvisory.mapper;

import com.kfp.aams.domain.DailyAdvisory.dto.Ja010qDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010qMapper {

    List<Ja010qDto> selectJa010qList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);
}
