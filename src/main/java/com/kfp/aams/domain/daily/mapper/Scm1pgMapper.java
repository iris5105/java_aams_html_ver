package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Scm1pgDetailDto;
import com.kfp.aams.domain.daily.dto.Scm1pgMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Scm1pgMapper {

    List<Scm1pgMasterDto> selectMasterList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    List<Scm1pgDetailDto> selectDetailList(@Param("corpGr") String corpGr, @Param("jmCd") String jmCd);

    int insertDetail(Scm1pgDetailDto dto);

    int updateDetail(Scm1pgDetailDto dto);

    int deleteDetail(@Param("corpGr") String corpGr, @Param("jmCd") String jmCd, @Param("ymd") String ymd);
}
