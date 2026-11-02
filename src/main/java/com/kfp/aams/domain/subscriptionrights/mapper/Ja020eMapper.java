package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020eDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja020eMapper {

    List<Ja020eDto> selectList(@Param("corpGr") String corpGr,
                               @Param("balhCo") String balhCo,
                               @Param("krakYmd") LocalDate krakYmd,
                               @Param("chengYmd") LocalDate chengYmd);
}

