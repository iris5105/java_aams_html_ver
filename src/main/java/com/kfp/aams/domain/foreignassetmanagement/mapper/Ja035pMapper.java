package com.kfp.aams.domain.foreignassetmanagement.mapper;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pDetailDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * W_JA035P 상환유예 관리 Mapper (d_ja035p1, d_ja035p2)
 */
@Mapper
public interface Ja035pMapper {

    List<Ja035pMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                           @Param("ymd") String ymd);

    List<Ja035pDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("trYmd") String trYmd,
                                           @Param("trCd") String trCd,
                                           @Param("fundCd") String fundCd,
                                           @Param("hjCd") String hjCd,
                                           @Param("trSeq") Long trSeq,
                                           @Param("aekGb") String aekGb);

    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    int insertMaster(Ja035pMasterDto dto);

    int updateMaster(Ja035pMasterDto dto);

    int deleteMaster(Ja035pMasterDto dto);

    int insertDetail(Ja035pDetailDto dto);

    int updateDetail(Ja035pDetailDto dto);

    int deleteDetail(Ja035pDetailDto dto);
}
