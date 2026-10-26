package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020hDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020hSaveDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja020hMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

/**
 * W_JA020H (채권 펀드/종목별 시가등록) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja020hService {

    private final Ja020hMapper ja020hMapper;
    private final WorkDateService workDateService;

    /**
     * 회사그룹별 기준 작업일자 조회 (SZX0AA.HYUN_YMD 연동)
     */
    @Transactional(readOnly = true)
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 채권 펀드/종목별 시가 목록 조회 (d_ja020h.srd)
     */
    @Transactional(readOnly = true)
    public List<Ja020hDto> getList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja020hMapper.selectJa020hList(corpGr.trim(), ymd);
    }

    /**
     * 채권 시가평가액 일괄 저장 처리
     */
    @Transactional
    public int save(Ja020hSaveDto saveDto, String loginUser) {
        if (saveDto == null || saveDto.getUpdatedList() == null || saveDto.getUpdatedList().isEmpty()) {
            return 0;
        }

        String corpGr = saveDto.getCorpGr();
        LocalDate ymd = saveDto.getYmd();
        String operator = (loginUser != null && !loginUser.isBlank()) ? loginUser : "admin";
        int updatedCount = 0;

        for (Ja020hDto item : saveDto.getUpdatedList()) {
            if (item.getCorpGr() == null || item.getCorpGr().isBlank()) {
                item.setCorpGr(corpGr);
            }
            if (item.getYmd() == null) {
                item.setYmd(ymd);
            }
            item.setIpUser(operator);

            updatedCount += ja020hMapper.updateSigaAek(item);
        }

        log.info("W_JA020H 시가평가액 저장 완료 - corpGr: {}, ymd: {}, 건수: {}", corpGr, ymd, updatedCount);
        return updatedCount;
    }
}
