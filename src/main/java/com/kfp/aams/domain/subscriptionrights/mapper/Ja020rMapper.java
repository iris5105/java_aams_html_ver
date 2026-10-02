package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020rDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020rMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja020rMapper {

    /**
     * 마스터 계좌 목록 조회 (d_ja020r1)
     */
    List<Ja020rMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                          @Param("ymd") LocalDate ymd,
                                          @Param("dw") String dw);

    /**
     * 채권취득액 상세 목록 조회 (d_ja020r2c)
     */
    List<Ja020rDetailDto> selectBondDetailList(@Param("corpGr") String corpGr,
                                              @Param("ymd") LocalDate ymd,
                                              @Param("fundCd") String fundCd);

    /**
     * 현금(전단채)취득액 상세 목록 조회 (d_ja020r2h)
     */
    List<Ja020rDetailDto> selectCashDetailList(@Param("corpGr") String corpGr,
                                              @Param("ymd") LocalDate ymd,
                                              @Param("fundCd") String fundCd);

    /**
     * 주식취득액 상세 목록 조회 (d_ja020r2j)
     */
    List<Ja020rDetailDto> selectStockDetailList(@Param("corpGr") String corpGr,
                                               @Param("ymd") LocalDate ymd,
                                               @Param("fundCd") String fundCd);

    /**
     * 채권 수정취득액 저장 (SCM0CM_CHUI)
     */
    int updateBondAlterAek(Ja020rDetailDto dto);

    /**
     * 현금 수정취득액 저장 (SHM0HM_CHUI)
     */
    int updateCashAlterAek(Ja020rDetailDto dto);

    /**
     * 주식 수정취득액 저장 (SJM0JM_CHUI)
     */
    int updateStockAlterAek(Ja020rDetailDto dto);
}
