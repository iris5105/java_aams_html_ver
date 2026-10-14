package com.kfp.aams.common.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WorkDateMapper {

    /**
     * 회사그룹별 기준 작업일자 조회 (SZX0AA.HYUN_YMD)
     */
    String selectWorkDate(@Param("corpGr") String corpGr);

    /**
     * 회사그룹별 전영업일 조회 (SZX0AA.JUNYONG_YMD)
     */
    String selectJunyongDate(@Param("corpGr") String corpGr);
}
