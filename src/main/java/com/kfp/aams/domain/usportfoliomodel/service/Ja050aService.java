package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja050aFundDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja050aMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * 손익현황(원장) / 가격대장 (W_JA050A) 서비스
 */
@Service
@Transactional(readOnly = true)
public class Ja050aService {

    private static final Logger log = LoggerFactory.getLogger(Ja050aService.class);

    private final Ja050aMapper ja050aMapper;
    private final WorkDateService workDateService;

    public Ja050aService(Ja050aMapper ja050aMapper, WorkDateService workDateService) {
        this.ja050aMapper = ja050aMapper;
        this.workDateService = workDateService;
    }

    /**
     * w_ja050a 고객(펀드) 목록 조회 (d_ja050a1.srd)
     *
     * @param corpGr 회사그룹코드
     * @param ymd    조회일자
     * @param mgCd   증권사코드
     * @return 펀드 목록
     */
    public List<Ja050aFundDto> getFundList(String corpGr, String ymd, String mgCd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        String searchYmd = (ymd != null && !ymd.isBlank())
                ? ymd
                : workDateService.getWorkDateOrDefault(corpGr);

        String searchMgCd = (mgCd != null && !mgCd.isBlank()) ? mgCd : "%";

        try {
            return ja050aMapper.selectFundList(corpGr, searchYmd, searchMgCd);
        } catch (Exception e) {
            log.error("[Ja050aService] selectFundList error: corpGr={}, ymd={}, mgCd={}", corpGr, searchYmd, searchMgCd, e);
            throw e;
        }
    }
}
