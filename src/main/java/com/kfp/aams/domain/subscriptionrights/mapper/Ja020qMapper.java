package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Uzm0hyDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020qGuganRawDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja020qMapper {

    /**
     * 계좌(종목)별 주간 운용현황 펀드 목록 (d_uzm0hy)
     */
    List<Uzm0hyDto> selectFundList(@Param("corpGr") String corpGr, @Param("ymd") LocalDate ymd);

    /**
     * TABLE(F_GUGAN) 함수 결과 조회
     */
    Ja020qGuganRawDto selectGuganRaw(@Param("corpGr") String corpGr, @Param("fundCd") String fundCd, @Param("ymd") LocalDate ymd);

    /**
     * SZM0IA 최초설정일자(fst_seolj_ymd) 조회 (전구간 탭용)
     */
    LocalDate selectFstSeoljYmd(@Param("corpGr") String corpGr, @Param("fundCd") String fundCd);
}
