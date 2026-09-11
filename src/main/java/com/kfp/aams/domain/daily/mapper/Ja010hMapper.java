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

    /**
     * 평잔 재계산 프로시저 호출 (SR_PYUNGJAN)
     */
    void callSrPyungjan(@Param("corpGr") String corpGr, @Param("fundCd") String fundCd, @Param("ymd") String ymd);

    /**
     * 회사그룹별 기준일자 조회 (wue_lastopen: corp_gr='2402'이면 junyong_ymd, 그 외는 hyun_ymd)
     */
    String selectWorkDate(@Param("corpGr") String corpGr);

    /**
     * 2402 회사 원장생성 불일치 건수 체크 (UZM0UI NAV vs SKT0GI sun_jasan_aek)
     */
    Integer checkLedgerDiffCount(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 최종 원장작업자 및 작업시간 조회
     */
    java.util.Map<String, Object> selectLastLedgerWorker(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 총 순자산시가액 조회 (w_ja010h1.srw cb_1 종합 엑셀용)
     */
    String selectSunJasanSigaAek(@Param("corpGr") String corpGr, @Param("ymd") String ymd);
}
