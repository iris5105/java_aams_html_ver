package com.kfp.aams.domain.DailyAdvisory.mapper;

import com.kfp.aams.domain.DailyAdvisory.dto.Ja010dDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010dMapper {

    List<Ja010dDto> selectJa010dList(@Param("corpGr") String corpGr, @Param("trYmd") String trYmd);

    List<String> selectJa010dTrDates(@Param("corpGr") String corpGr);
}
