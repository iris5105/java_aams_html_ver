package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Shm1pgDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Shm1pgMapper {

    List<Shm1pgDto> selectShm1pgList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    int updateShm1pg(Shm1pgDto dto);
}
