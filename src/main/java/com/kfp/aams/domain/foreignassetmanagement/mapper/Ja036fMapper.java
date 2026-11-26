package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036fDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA036F 외화자산 조회 MyBatis 매퍼
 */
@Mapper
public interface Ja036fMapper {

    List<Ja036fDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") String ymd,
                               @Param("accountType") String accountType);
}
