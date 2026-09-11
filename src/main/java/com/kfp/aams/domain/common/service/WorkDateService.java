package com.kfp.aams.domain.common.service;

import com.kfp.aams.domain.common.mapper.WorkDateMapper;
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
}
