package com.kfp.aams.domain.dailyadvisory.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Sjt0scDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Sjt0scMapper {

    List<Sjt0scDto> selectSjt0scList(@Param("corpGr") String corpGr, @Param("ymd") LocalDate ymd);
}
