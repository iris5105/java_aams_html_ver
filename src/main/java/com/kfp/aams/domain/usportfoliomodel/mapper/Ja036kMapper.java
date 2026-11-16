package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja036kLoadDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja036kMapper {
    List<Ja036kLoadDto> selectStatusList(@Param("corpGr") String corpGr, @Param("ymd") LocalDate ymd);

    List<Ja036kLoadDto> selectTradeLoadList(@Param("corpGr") String corpGr, @Param("ymd") LocalDate ymd);

    List<Ja036kLoadDto> selectBalanceList(@Param("corpGr") String corpGr, @Param("ymd") LocalDate ymd);
}
