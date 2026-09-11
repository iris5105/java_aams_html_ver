package com.kfp.aams.domain.common.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WorkDateMapper {

    /**
     * 회사그룹별 기준 작업일자 조회 (파워빌더 wue_lastopen 명세: corp_gr='2402'이면 NVL(junyong_ymd, hyun_ymd), 그 외는 hyun_ymd)
     */
    String selectWorkDate(@Param("corpGr") String corpGr);
}
