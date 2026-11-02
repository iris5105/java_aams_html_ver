package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030fDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja030fMapper {
    List<Ja030fDto> selectList(@Param("corpGr") String corpGr, @Param("trYmd") LocalDate trYmd);
}
