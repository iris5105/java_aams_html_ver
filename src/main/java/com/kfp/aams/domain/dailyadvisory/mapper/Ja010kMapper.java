package com.kfp.aams.domain.dailyadvisory.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010kDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010kMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja010kMapper {

    List<Ja010kMasterDto> selectMasterList(@Param("corpGr") String corpGr, @Param("tymd") LocalDate tymd);

    List<Ja010kDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("fymd") LocalDate fymd,
                                           @Param("tymd") LocalDate tymd,
                                           @Param("fundCd") String fundCd);
}
