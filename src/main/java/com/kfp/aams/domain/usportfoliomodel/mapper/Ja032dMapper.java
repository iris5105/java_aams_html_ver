package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dColumnDataDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dStatusDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * W_JA032D (API 자료요청 현황) MyBatis Mapper
 */
@Mapper
public interface Ja032dMapper {

    /**
     * d_ja032d1 (API 요청 현황 마스터 목록) 조회
     */
    List<Ja032dMasterDto> selectMasterList(@Param("ymd") String ymd);

    /**
     * d_ja032d2 (API 요청 상세 건별 목록) 조회
     */
    List<Ja032dDetailDto> selectDetailList(@Param("company") String company,
                                          @Param("url") String url,
                                          @Param("dt") String dt);

    /**
     * d_ja032d3 (API 처리상태 요약) 조회
     */
    Ja032dStatusDto selectStatus(@Param("apiKey") String apiKey);

    /**
     * d_ja032d4 (테이블 컬럼 메타정보) 조회
     */
    List<Ja032dColumnDataDto> selectColumnsByTableName(@Param("tableName") String tableName);

    /**
     * SR_JA032D 프로시저 호출 (한투파생시가)
     */
    void callSrJa032d(Map<String, Object> params);

    /**
     * API_KSE 프로시저 호출 (국내주식요청)
     */
    void callApiKse(Map<String, Object> params);

    /**
     * API_13_02 프로시저 호출 (해외주식신규)
     */
    void callApi1302(Map<String, Object> params);

    /**
     * API_17_16 프로시저 호출 (한투파생종가)
     */
    void callApi1716(Map<String, Object> params);

    /**
     * NEW_13_02 프로시저 호출 (해외일괄재신청)
     */
    void callNew1302(Map<String, Object> params);
}
