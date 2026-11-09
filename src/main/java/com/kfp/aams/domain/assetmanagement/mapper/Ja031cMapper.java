package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031cDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja031cMapper {
    List<Ja031cDto> selectList(@Param("corpGr") String corpGr, @Param("trYmd") LocalDate trYmd,
                               @Param("trCd") String trCd);
    List<String> selectHighlightDates(@Param("corpGr") String corpGr);
    int selectMaxSequence(@Param("corpGr") String corpGr, @Param("trYmd") LocalDate trYmd,
                          @Param("trCd") String trCd);
    int existsRow(@Param("corpGr") String corpGr, @Param("trYmd") LocalDate trYmd,
                  @Param("trCd") String trCd, @Param("fundCd") String fundCd,
                  @Param("trSeqNo") Integer trSeqNo);
    int insert(Ja031cDto dto);
    int update(Ja031cDto dto);
    int delete(Ja031cDto dto);
}
