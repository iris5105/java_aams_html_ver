package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010hMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * MyBatis Mapper for w_ja010h (d_szm0ia.srd / SZM0IA + UZM0UI UNION SKT0GS)
 */
@Mapper
public interface Ja010hMapper {

    /**
     * 마스터 펀드 목록 조회 (d_szm0ia.srd)
     */
    List<Ja010hMasterDto> selectFundList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 담보 존재 여부 체크 (SJM0JM: coll_pass <> 0 OR coll_up <> 0 OR coll_dw <> 0)
     */
    int checkCollCount(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("fundCd") String fundCd);

    /**
     * 데이터가 존재하는 일자 목록 (캘린더 하이라이트용)
     */
    List<String> selectDistinctDates(@Param("corpGr") String corpGr);

    /**
     * 특정 펀드 단건 조회
     */
    Ja010hMasterDto selectFundInfo(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("fundCd") String fundCd);
}
