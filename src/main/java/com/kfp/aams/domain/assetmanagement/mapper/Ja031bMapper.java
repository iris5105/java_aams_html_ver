package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031bDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja031bMapper {
    List<Ja031bDto> selectList(@Param("corpGr") String corpGr);

    List<Ja031bDto> selectActiveTradeCompanies(@Param("corpGr") String corpGr);

    int existsRow(@Param("corpGr") String corpGr,
                  @Param("grCd") String grCd,
                  @Param("sebuCd") String sebuCd);

    int insert(Ja031bDto dto);

    int update(Ja031bDto dto);

    int delete(Ja031bDto dto);
}

