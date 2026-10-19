package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035bDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * W_JA035B 해외주식 매매내역 MyBatis 매퍼
 */
@Mapper
public interface Ja035bMapper {

    /**
     * 해외주식 매매내역 목록 조회 (d_ja035b)
     */
    List<Ja035bDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") String ymd,
                               @Param("trCd") String trCd,
                               @Param("fundCd") String fundCd);

    /**
     * 해외주식 잔고 목록 조회 (매도 시 보유종목 자동 불러오기용: SYM0YZ + SYM0YA)
     */
    List<Ja035bDto> selectBalanceList(@Param("corpGr") String corpGr,
                                      @Param("ymd") String ymd,
                                      @Param("fundCd") String fundCd);

    /**
     * 당일 펀드별 최대 TR_SEQ 조회
     */
    Long selectMaxTrSeq(@Param("corpGr") String corpGr,
                        @Param("ymd") String ymd,
                        @Param("fundCd") String fundCd);

    /**
     * SYT0MG 신규 등록
     */
    int insertSyt0mg(Ja035bDto dto);

    /**
     * SYT0MG 수정
     */
    int updateSyt0mg(Ja035bDto dto);

    /**
     * SYT0MG 삭제
     */
    int deleteSyt0mg(Ja035bDto dto);

    /**
     * 통화별 환율 조회 (F_CURRENCY_RT)
     */
    BigDecimal selectCurrencyRate(@Param("corpGr") String corpGr,
                                  @Param("ymd") String ymd,
                                  @Param("currency") String currency);

    /**
     * 해외보관처 기본 통화 조회 (SYX2MM)
     */
    String selectTrusteeCurrency(@Param("corpGr") String corpGr,
                                 @Param("trustee") String trustee);

    /**
     * 펀드 매매처코드 조회 (SZM0IA.mg_cd)
     */
    String selectFundTrCoCd(@Param("corpGr") String corpGr,
                            @Param("fundCd") String fundCd);

    /**
     * 종목 정보 단건 조회 (SYM0YA)
     */
    Map<String, Object> selectItemInfo(@Param("corpGr") String corpGr,
                                       @Param("jmCd") String jmCd);
}
