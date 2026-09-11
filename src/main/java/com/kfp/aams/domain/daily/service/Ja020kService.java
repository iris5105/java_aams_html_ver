package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.common.service.WorkDateService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja020kService {

    private final WorkDateService workDateService;

    /**
     * 회사그룹별 기준일자 조회 (공통 WorkDateService 위임)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDate(corpGr);
    }
}
