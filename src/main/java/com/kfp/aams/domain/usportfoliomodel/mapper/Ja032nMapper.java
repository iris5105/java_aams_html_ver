package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nJisuDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * 포트별 옵션수익실현현황 (W_JA032N) MyBatis 매퍼
 */
@Mapper
public interface Ja032nMapper {

    /**
     * 1. 좌측 마스터 펀드 목록 조회 (d_ja032n1.srd)
     */
    List<Ja032nMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                           @Param("ymd") LocalDate ymd);

    /**
     * 2. 우측 상단 지수 및 펀드 수익률 요약 조회 (d_ja032n3.srd - F_JA032N 함수 호출)
     */
    Ja032nJisuDto selectJisuSummary(@Param("corpGr") String corpGr,
                                    @Param("ymd") LocalDate ymd,
                                    @Param("fundCd") String fundCd);

    /**
     * 3. 우측 하단 상세 목록 조회 (d_ja032n2.srd)
     */
    List<Ja032nDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("ymd") LocalDate ymd,
                                           @Param("fundCd") String fundCd);
}
