package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Scm1smDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Scm1smMapper {

    /**
     * 채권 단가 목록 조회 (d_scm1sm / SCM1SM + SCM0CJ)
     */
    List<Scm1smDto> selectScm1smList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 당일 거래/보유 채권 중 단가 미등록 종목 조회 (파워빌더 retrieveend 연계 / SCM0CM + SCM1SM)
     */
    List<Scm1smDto> selectMissingBondList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 단가 등록
     */
    int insertScm1sm(Scm1smDto dto);

    /**
     * 단가 수정
     */
    int updateScm1sm(Scm1smDto dto);

    /**
     * 단가 삭제
     */
    int deleteScm1sm(Scm1smDto dto);

    /**
     * 단가 Merge (등록 또는 수정)
     */
    int mergeScm1sm(Scm1smDto dto);
}
