package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036gDetailDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036gMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA036G 외화자산 보유현황(종목/기간별) MyBatis 매퍼
 */
@Mapper
public interface Ja036gMapper {

    List<Ja036gMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                           @Param("fYmd") String fYmd,
                                           @Param("tYmd") String tYmd);

    List<Ja036gDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("fYmd") String fYmd,
                                           @Param("tYmd") String tYmd,
                                           @Param("fundCd") String fundCd,
                                           @Param("jmCd") String jmCd);
}
