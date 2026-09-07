package com.kfp.aams.domain.common.mapper;

import com.kfp.aams.domain.common.dto.DynamicCodeSearchDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface DynamicCodeSearchMapper {

    /**
     * WDCS01M 코드 검색 마스터 메타데이터 조회
     */
    DynamicCodeSearchDto selectCodeSearchMaster(@Param("columnNm") String columnNm,
                                               @Param("columnSeq") Integer columnSeq);

    /**
     * 동적 SELECT 쿼리 실행 (목록 조회)
     */
    List<Map<String, Object>> executeDynamicSelect(@Param("sql") String sql);

    /**
     * 동적 SELECT 쿼리 실행 (단건 조회)
     */
    List<Map<String, Object>> executeDynamicSelectLimited(@Param("sql") String sql);
}
