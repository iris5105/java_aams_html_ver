package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Sjt0tgDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Sjt0tgMapper {

    /**
     * 주식 종가 목록 조회 (d_sjt0tg)
     */
    List<Sjt0tgDto> selectSjt0tgList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 당일 종목 중 종가 미등록 종목 조회 (파워빌더 retrieveend 연계)
     */
    List<Sjt0tgDto> selectMissingKoscomList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 종가 등록
     */
    int insertSjt0tg(Sjt0tgDto dto);

    /**
     * 종가 수정
     */
    int updateSjt0tg(Sjt0tgDto dto);

    /**
     * 종가 삭제
     */
    int deleteSjt0tg(Sjt0tgDto dto);

    /**
     * 종가 Merge (등록 또는 수정)
     */
    int mergeSjt0tg(Sjt0tgDto dto);
}
