package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031aDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface Ja031aMapper {

    /**
     * W_JA031A 선물매매 거래 목록 조회 (d_ja031a1.srd)
     */
    List<Ja031aDto> selectList(@Param("corpGr") String corpGr,
                               @Param("trYmd") LocalDate trYmd,
                               @Param("trCd") String trCd);

    /**
     * 달력 하이라이트 일자 조회 (dw_c::ue_getdate)
     */
    List<String> selectDates(@Param("corpGr") String corpGr);

    /**
     * 거래순번 최대값 채번 (w_ja031a.srw updatestart)
     */
    Long selectMaxTrSeqNo(@Param("corpGr") String corpGr,
                          @Param("trYmd") LocalDate trYmd,
                          @Param("trCd") String trCd);

    /**
     * 선물종목 단위승수 조회 (SSX0KJ.UNIT_AEK)
     */
    Double selectUnitAek(@Param("corpGr") String corpGr,
                         @Param("sjCd") String sjCd);

    /**
     * 만기거래생성 프로시저 호출 (KFP.SR_JA031A)
     */
    void callSrJa031a(Map<String, Object> params);

    /**
     * SST1KT 신규 등록
     */
    int insertSst1kt(Ja031aDto dto);

    /**
     * SST1KT 수정
     */
    int updateSst1kt(Ja031aDto dto);

    /**
     * SST1KT 삭제
     */
    int deleteSst1kt(Ja031aDto dto);
}

