package com.kfp.aams.domain.dailyadvisory.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Scm1pgDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Scm1pgMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Scm1pgMapper {

    List<Scm1pgMasterDto> selectMasterList(@Param("corpGr") String corpGr, @Param("ymd") LocalDate ymd);

    List<Scm1pgDetailDto> selectDetailList(@Param("corpGr") String corpGr, @Param("jmCd") String jmCd);
}
