package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja036j2Dto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja036j2HistoryDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja036j2Mapper {
    List<Ja036j2Dto> selectList(@Param("ymd") LocalDate ymd);

    List<Ja036j2HistoryDto> selectHistory(@Param("ymd") LocalDate ymd, @Param("currency") String currency);

    int mergeRate(Ja036j2Dto dto);

    int deleteRate(@Param("ymd") LocalDate ymd, @Param("currency") String currency);
}
