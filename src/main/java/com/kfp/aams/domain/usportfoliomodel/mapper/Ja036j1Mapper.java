package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja036j1Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja036j1Mapper {
    List<Ja036j1Dto> selectList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    String selectStockCode(@Param("corpGr") String corpGr, @Param("jmCd") String jmCd);

    int mergeClose(Ja036j1Dto dto);

    int deleteClose(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("yjCd") String yjCd);

    int touchSyt0lpLink();
}
