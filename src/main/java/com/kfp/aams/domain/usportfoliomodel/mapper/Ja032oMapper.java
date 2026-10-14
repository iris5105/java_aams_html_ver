package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oFundDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * MyBatis Mapper for W_JA032O (파생 환매수 운용지시)
 */
@Mapper
public interface Ja032oMapper {

    /**
     * 1. 펀드/포트 만기별 목록 조회 (d_ja032o1)
     */
    List<Ja032oFundDto> selectFundList(@Param("corpGr") String corpGr,
                                       @Param("ymd") LocalDate ymd);

    /**
     * 2. 파생상품 보유 내역 및 환매수 주문 생성 목록 조회 (d_ja032o2)
     */
    List<Ja032oDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("ymd") LocalDate ymd,
                                           @Param("fundCd") String fundCd,
                                           @Param("portNum") String portNum);

    /**
     * 다음 거래일련번호(TR_SEQ) 채번
     */
    Long selectNextTrSeq(@Param("corpGr") String corpGr,
                         @Param("trYmd") LocalDate trYmd,
                         @Param("fundCd") String fundCd,
                         @Param("jmCd") String jmCd,
                         @Param("trCd") String trCd);

    /**
     * SYT1MG 운용지시 거래 INSERT
     */
    int insertSyt1mg(@Param("corpGr") String corpGr,
                     @Param("trYmd") LocalDate trYmd,
                     @Param("trCd") String trCd,
                     @Param("fundCd") String fundCd,
                     @Param("trCoCd") String trCoCd,
                     @Param("trustee") String trustee,
                     @Param("jmCd") String jmCd,
                     @Param("currency") String currency,
                     @Param("trSeq") Long trSeq,
                     @Param("trJusu") BigDecimal trJusu,
                     @Param("trDanga") BigDecimal trDanga,
                     @Param("trAek") BigDecimal trAek);
}
