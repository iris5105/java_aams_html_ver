package com.kfp.aams.common.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface WorkDateMapper {

    /**
     * 회사그룹별 기준 작업일자 조회 (SZX0AA.HYUN_YMD)
     * 파워빌더 idt_workdate 표준: 모든 회사의 현재 작업일자(HYUN_YMD)를 조회한다.
     */
    String selectWorkDate(@Param("corpGr") String corpGr);

    /**
     * PB wue_lastopen에서 corp_gr='2402'인 경우 JUNYONG_YMD, 그 외 회사는 HYUN_YMD를 사용하는 화면 전용 조회
     */
    String selectWorkDateFor2402Junyong(@Param("corpGr") String corpGr);

    /**
     * 회사그룹별 전영업일 조회 (SZX0AA.JUNYONG_YMD)
     */
    String selectJunyongDate(@Param("corpGr") String corpGr);
}
