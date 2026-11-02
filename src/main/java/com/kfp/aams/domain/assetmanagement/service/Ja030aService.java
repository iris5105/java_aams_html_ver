package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030aDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030aSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030aMapper;
import com.kfp.aams.domain.assetmanagement.mapper.querydsl.Ja030aLedgerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja030aService {
    private final Ja030aMapper mapper;
    private final Ja030aLedgerRepository ledgerRepository;

    public List<Ja030aDto> list(String corpGr, LocalDate trYmd, String trCd, String jmCd) {
        if (blank(corpGr) || trYmd == null || blank(trCd) || blank(jmCd)) return Collections.emptyList();
        return mapper.selectList(corpGr, trYmd, trCd, jmCd);
    }

    public List<LocalDate> dates(String corpGr) {
        return blank(corpGr) ? Collections.emptyList() : ledgerRepository.findTransactionDates(corpGr);
    }

    @Transactional
    public int save(String corpGr, Ja030aSaveRequest request) {
        if (request == null || blank(corpGr) || request.getTrYmd() == null || blank(request.getTrCd())
                || blank(request.getJmCd()) || blank(request.getBalhCo())) return 0;

        int affected = 0;
        if (request.getDeletedList() != null) {
            for (Ja030aDto item : request.getDeletedList()) {
                if (item == null) continue;
                prepare(item, corpGr, request);
                if (ledgerRepository.delete(item)) affected++;
            }
        }
        if (request.getItems() != null) {
            for (Ja030aDto item : request.getItems()) {
                if (item == null || blank(item.getFundCd())) continue;
                prepare(item, corpGr, request);
                if (Boolean.TRUE.equals(item.getIsNew())) {
                    ledgerRepository.insert(item);
                    affected++;
                } else if (Boolean.TRUE.equals(item.getIsUpdated()) && ledgerRepository.update(item)) {
                    affected++;
                }
            }
        }
        return affected;
    }

    private void prepare(Ja030aDto item, String corpGr, Ja030aSaveRequest request) {
        item.setCorpGr(corpGr);
        item.setTrYmd(request.getTrYmd());
        item.setTrCd(request.getTrCd());
        item.setJmCd(request.getJmCd());
        // d_ja030a1은 BALH_CO를 조회 컬럼으로 포함한다. 기존 행의 복합키는 유지하고,
        // 신규 행에만 dw_c에서 선택한 발행처를 기본값으로 적용한다.
        if (blank(item.getBalhCo())) item.setBalhCo(request.getBalhCo());
        if (blank(item.getTypeTrench())) item.setTypeTrench("00:");
        if (item.getBsType() == null) item.setBsType(BigDecimal.ZERO);
        if (item.getTrJusu() == null) item.setTrJusu(BigDecimal.ZERO);
        if (item.getTrDanga() == null) item.setTrDanga(BigDecimal.ZERO);
        if (item.getSusu() == null) item.setSusu(BigDecimal.ZERO);
    }

    private boolean blank(String value) { return value == null || value.isBlank(); }
}
