package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032kFundDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032kMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 자산현황 (W_JA032K) 서비스
 */
@Service
@Transactional(readOnly = true)
public class Ja032kService {

    private static final Logger log = LoggerFactory.getLogger(Ja032kService.class);

    private final Ja032kMapper ja032kMapper;
    private final WorkDateService workDateService;

    public Ja032kService(Ja032kMapper ja032kMapper, WorkDateService workDateService) {
        this.ja032kMapper = ja032kMapper;
        this.workDateService = workDateService;
    }

    /**
     * w_ja032k 자산현황 펀드 목록 조회 (d_ja036e.srd)
     *
     * @param corpGr 회사그룹코드
     * @param ymd    조회일자
     * @param mgCd   증권사코드 (기본 '%')
     * @return 펀드 목록
     */
    public List<Ja032kFundDto> getFundList(String corpGr, String ymd, String mgCd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        String searchYmd = (ymd != null && !ymd.isBlank())
                ? ymd
                : workDateService.getWorkDateOrDefault(corpGr);

        String searchMgCd = (mgCd != null && !mgCd.isBlank()) ? mgCd : "%";

        try {
            return ja032kMapper.selectFundList(corpGr, searchYmd, searchMgCd);
        } catch (Exception e) {
            log.error("[Ja032kService] selectFundList error: corpGr={}, ymd={}, mgCd={}", corpGr, searchYmd, searchMgCd, e);
            throw e;
        }
    }

    /**
     * 증권사 선택 드롭다운 목록 조회
     *
     * @param corpGr 회사그룹코드
     * @return 증권사 목록
     */
    public List<Map<String, String>> getBrokerList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        try {
            return ja032kMapper.selectBrokerList(corpGr);
        } catch (Exception e) {
            log.error("[Ja032kService] selectBrokerList error: corpGr={}", corpGr, e);
            return Collections.emptyList();
        }
    }
}
