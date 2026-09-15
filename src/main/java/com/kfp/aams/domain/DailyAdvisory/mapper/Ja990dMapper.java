package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja990dDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja990dMapper {

    List<Ja990dDto> selectStockList(@Param("searchKeyword") String searchKeyword);

    List<Ja990dDto> selectRightList(@Param("searchKeyword") String searchKeyword);

    int checkJmCdExists(@Param("jmCd") String jmCd);

    int insertJm(Ja990dDto dto);

    int updateJm(Ja990dDto dto);

    int deleteJm(@Param("jmCd") String jmCd);
}
