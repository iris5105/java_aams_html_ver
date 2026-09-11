package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010gDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010gMapper {

    List<Ja010gDto> selectJa010gList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    int updateConfirmYmd(@Param("corpGr") String corpGr, @Param("ymd") String ymd);
}
