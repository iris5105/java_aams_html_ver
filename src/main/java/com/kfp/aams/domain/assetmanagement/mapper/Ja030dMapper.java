package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030dDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja030dMapper {
    List<Ja030dDto> selectList(@Param("corpGr") String corpGr, @Param("trYmd") LocalDate trYmd, @Param("trCd") String trCd);
}
