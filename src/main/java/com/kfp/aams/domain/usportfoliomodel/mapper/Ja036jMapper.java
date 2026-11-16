package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja036jDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja036jMapper {
    List<Ja036jDto> selectList(@Param("corpGr") String corpGr, @Param("ymd") String ymd,
                               @Param("jasanGb") String jasanGb);

    String selectSecurityCode(@Param("corpGr") String corpGr, @Param("yjCd") String yjCd,
                              @Param("jasanGb") String jasanGb);

    int mergeClose(Ja036jDto dto);

    int deleteClose(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("yjCd") String yjCd);
}
