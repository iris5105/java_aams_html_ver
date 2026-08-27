package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010bDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010bIoDto;
import com.kfp.aams.domain.daily.dto.Ja010bMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010bMapper {

    List<Ja010bMasterDto> selectJa010bMasterList(@Param("corpGr") String corpGr);

    List<Ja010bDetailDto> selectJa010bDetailList(@Param("corpGr") String corpGr, @Param("fundCd") String fundCd);

    List<Ja010bIoDto> selectJa010bIoList(@Param("corpGr") String corpGr, @Param("fundCd") String fundCd);
}
