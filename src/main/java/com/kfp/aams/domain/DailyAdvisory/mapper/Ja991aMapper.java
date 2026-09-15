package com.kfp.aams.domain.DailyAdvisory.mapper;

import com.kfp.aams.domain.DailyAdvisory.dto.Ja991aDetailDto;
import com.kfp.aams.domain.DailyAdvisory.dto.Ja991aMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja991aMapper {
    List<Ja991aMasterDto> selectMasterList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);
    List<Ja991aDetailDto> selectDetailList(@Param("koscomCd") String koscomCd, @Param("ymd") String ymd);
}
