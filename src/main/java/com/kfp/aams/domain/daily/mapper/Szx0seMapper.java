package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Szx0seDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Szx0seMapper {
    List<Szx0seDto> selectSzx0seList(@Param("corpGr") String corpGr);
}
