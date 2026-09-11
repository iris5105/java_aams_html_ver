package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010nDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010nMapper {

    List<Ja010nDto> selectJa010nList();

    int insertJa010n(Ja010nDto dto);

    int updateJa010n(Ja010nDto dto);

    int deleteJa010n(@Param("ymd") String ymd);
}
