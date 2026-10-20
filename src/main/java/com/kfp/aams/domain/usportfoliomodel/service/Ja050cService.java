package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja050cFundDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja050cMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * 손익 상세현황(분개장) (W_JA050C) 서비스
 */
@Service
public class Ja050cService {

    private static final Logger log = LoggerFactory.getLogger(Ja050cService.class);

    private final Ja050cMapper ja050cMapper;
    private final WorkDateService workDateService;

    public Ja050cService(Ja050cMapper ja050cMapper, WorkDateService workDateService) {
        this.ja050cMapper = ja050cMapper;
        this.workDateService = workDateService;
    }

    /**
     * DB 기준 영업일자 조회
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 고객(펀드) 목록 조회 (d_fund_select)
     *
     * @param corpGr 회사그룹
     * @param ymd 기준일자
     * @param procStep 구분 ('1': 일반, '9': 수기)
     * @return 펀드 목록
     */
    @Transactional(readOnly = true)
    public List<Ja050cFundDto> getFundList(String corpGr, String ymd, String procStep) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }

        List<Ja050cFundDto> list = ja050cMapper.selectFundList(corpGr, ymd, procStep);
        return list != null ? list : Collections.emptyList();
    }
}
