package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.ApiParamsDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * API_PARAMS 및 API_Q MyBatis 매퍼 (d_api_params.srd 연동)
 */
@Mapper
public interface ApiParamsMapper {

    /**
     * API 파라미터 목록 조회 (d_api_params.srd 복합 조인)
     */
    List<ApiParamsDto> selectApiParamsList(@Param("trCoCd") String trCoCd);

    /**
     * API_Q 요청 레코드 생성 (w_api_params.srw mle_q_value::doubleclicked 연동)
     */
    int insertApiQRequest(@Param("company") String company,
                          @Param("url") String url,
                          @Param("headers") String headers,
                          @Param("qValue") String qValue,
                          @Param("tablename") String tablename,
                          @Param("subtable") String subtable,
                          @Param("keyValue") String keyValue,
                          @Param("subKeyValue") String subKeyValue);
}
