package com.kfp.aams.common.service;

import com.kfp.aams.common.mapper.WorkDateMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

/**
 * 회사그룹별 기준 작업일자 공통 서비스
 * (파워빌더 wue_lastopen 명세: SZX0AA.JUNYONG_YMD(2402) 또는 HYUN_YMD(기타))
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class WorkDateService {

    private final WorkDateMapper workDateMapper;

    /**
     * 회사그룹별 기준 작업일자 조회 (YYYY-MM-DD)
     * 파워빌더 idt_workdate 표준: 모든 회사의 현재 작업일자(HYUN_YMD)를 조회한다.
     * 일반 화면들(w_ja031a, w_ja031d 등)의 기본 작업일자에 적용된다.
     */
    public String getWorkDate(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return null;
        }
        return workDateMapper.selectWorkDate(corpGr.trim());
    }

    /**
     * 기준일자 조회 시 null/blank인 경우 오늘 날짜(YYYY-MM-DD)로 대체 반환
     */
    public String getWorkDateOrDefault(String corpGr) {
        String workDate = getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            return LocalDate.now().toString();
        }
        return workDate;
    }

    /**
     * PB wue_lastopen에서 corp_gr='2402'인 경우 JUNYONG_YMD, 그 외 회사는 HYUN_YMD를 사용하는 화면 전용 조회
     * (적용 화면: w_ja010f, w_ja010g, w_ja010h1, w_ja020n, w_ja020r)
     */
    public String getWorkDateFor2402Junyong(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return null;
        }
        return workDateMapper.selectWorkDateFor2402Junyong(corpGr.trim());
    }

    /**
     * PB 2402 JUNYONG_YMD 화면 전용 조회 (null/blank 시 오늘 날짜 대체)
     */
    public String getWorkDateFor2402JunyongOrDefault(String corpGr) {
        String workDate = getWorkDateFor2402Junyong(corpGr);
        if (workDate == null || workDate.isBlank()) {
            return LocalDate.now().toString();
        }
        return workDate;
    }

    /**
     * 회사그룹별 전영업일 조회 (YYYY-MM-DD)
     */
    public String getJunyongDate(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return null;
        }
        return workDateMapper.selectJunyongDate(corpGr.trim());
    }

    /**
     * 전영업일 조회 시 null/blank인 경우 오늘 날짜(YYYY-MM-DD)로 대체 반환
     */
    public String getJunyongDateOrDefault(String corpGr) {
        String jDate = getJunyongDate(corpGr);
        if (jDate == null || jDate.isBlank()) {
            return LocalDate.now().toString();
        }
        return jDate;
    }
}
