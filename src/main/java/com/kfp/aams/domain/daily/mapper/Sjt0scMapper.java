package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Sjt0scDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Sjt0scMapper {

    List<Sjt0scDto> selectSjt0scList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    int insertSjt0sc(Sjt0scDto dto);

    int updateSjt0sc(Sjt0scDto dto);

    int deleteSjt0sc(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("jmCd") String jmCd);
}
