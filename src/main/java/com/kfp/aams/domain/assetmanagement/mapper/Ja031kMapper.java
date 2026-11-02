package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031kDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * W_JA031K MyBatis 매퍼 인터페이스 (d_ja031k.srd 1:1)
 */
@Mapper
public interface Ja031kMapper {

    /**
     * 입금거래 목록 조회 (d_ja031k.srd)
     */
    List<Ja031kDto> selectList(@Param("corpGr") String corpGr,
                               @Param("trYmd") LocalDate trYmd,
                               @Param("trCd") String trCd);

    /**
     * 달력 하이라이트 일자 조회 (w_ja031k.srw dw_c::ue_getdate)
     */
    List<String> selectHighlightDates(@Param("corpGr") String corpGr);

    /**
     * 펀드 및 수탁사 정보 조회
     */
    Map<String, Object> selectFundInfo(@Param("corpGr") String corpGr,
                                       @Param("fundCd") String fundCd);

    /**
     * 단건 존재 여부 확인
     */
    int existsSkt0hs(@Param("corpGr") String corpGr,
                     @Param("trYmd") LocalDate trYmd,
                     @Param("fundCd") String fundCd,
                     @Param("trCd") String trCd);

    /**
     * CUD - 등록
     */
    int insertSkt0hs(Ja031kDto dto);

    /**
     * CUD - 수정
     */
    int updateSkt0hs(Ja031kDto dto);

    /**
     * CUD - 삭제
     */
    int deleteSkt0hs(Ja031kDto dto);
}

