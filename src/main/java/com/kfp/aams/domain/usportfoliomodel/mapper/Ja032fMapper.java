package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface Ja032fMapper {

    /**
     * 해외주식 마스터 및 USPM 등록 종목 목록 조회 (d_ja032f1)
     */
    List<Ja032fMasterDto> selectMasterList(@Param("corpGr") String corpGr);

    /**
     * 종목 일별 시세 내역 조회 (d_ja032f2)
     */
    List<Ja032fDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                          @Param("ymd") String ymd,
                                          @Param("jmCd") String jmCd);

    /**
     * SYM0YA 옵션단위 수정
     */
    int updateSym0ya(Ja032fMasterDto dto);

    /**
     * SYM0YA 신규 등록
     */
    int insertSym0ya(Ja032fMasterDto dto);

    /**
     * SYM0YA 존재 여부 체크
     */
    int countSym0ya(@Param("corpGr") String corpGr,
                    @Param("jmCd") String jmCd,
                    @Param("jasanGb") String jasanGb);

    /**
     * API_Q 등록
     */
    int insertApiQ(@Param("corpGr") String corpGr,
                   @Param("symb") String symb,
                   @Param("key1") String key1,
                   @Param("prdt") String prdt);

    /**
     * USPM_DD 등록
     */
    int insertUspmDd(@Param("corpGr") String corpGr,
                     @Param("ymd") String ymd,
                     @Param("jmCd") String jmCd);

    /**
     * API_13_02_200 프로시저 호출
     */
    void callApi1302200(Map<String, Object> params);

    /**
     * API_GLOBAL_MASTCODE 중복 체크
     */
    int selectGlobalMastcodeCount(@Param("rsym") String rsym);

    /**
     * API_GLOBAL_MASTCODE 등록
     */
    int insertGlobalMastcode(Map<String, Object> params);
}
