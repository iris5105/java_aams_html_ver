package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032bYaStockDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 관심종목 변동성 추이 (W_JA032B_YA) 매퍼
 */
@Mapper
public interface Ja032bYaMapper {

    /**
     * 포트 정보(FYMD, TT) 조회
     */
    Map<String, Object> selectPortInfo(@Param("corpGr") String corpGr,
                                       @Param("fundCd") String fundCd,
                                       @Param("portNum") String portNum,
                                       @Param("ymd") String ymd);

    /**
     * 포트 번호 목록 조회 (USPM_PORT)
     */
    List<String> selectPortList(@Param("corpGr") String corpGr,
                                @Param("fundCd") String fundCd,
                                @Param("ymd") String ymd);

    /**
     * 관심종목 변동성 추이 목록 조회 (d_ja032b_ya.srd)
     */
    List<Ja032bYaStockDto> selectStockList(@Param("corpGr") String corpGr,
                                           @Param("fymd") String fymd,
                                           @Param("tymd") String tymd,
                                           @Param("tt") String tt);

    /**
     * 포트 내 종목 최대 순번(COL) 조회
     */
    Integer selectMaxCol(@Param("corpGr") String corpGr,
                         @Param("fundCd") String fundCd,
                         @Param("ymd") String ymd,
                         @Param("portNum") String portNum);

    /**
     * 포트 내 특정 종목 등록 여부 확인
     */
    int countUspm(@Param("corpGr") String corpGr,
                  @Param("fundCd") String fundCd,
                  @Param("ymd") String ymd,
                  @Param("portNum") String portNum,
                  @Param("jmCd") String jmCd);

    /**
     * USPM 종목 신규 등록
     */
    int insertUspm(@Param("corpGr") String corpGr,
                   @Param("ymd") String ymd,
                   @Param("fundCd") String fundCd,
                   @Param("portNum") String portNum,
                   @Param("jmCd") String jmCd,
                   @Param("col") Integer col,
                   @Param("ovrsExcgCd") String ovrsExcgCd);
}
