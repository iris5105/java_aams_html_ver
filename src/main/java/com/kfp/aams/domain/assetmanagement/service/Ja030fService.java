package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030fDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030fSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030fMapper;
import com.kfp.aams.domain.assetmanagement.mapper.querydsl.Ja030fLedgerRepository;
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
public class Ja030fService {
    private static final String TRADE_CODE = "J32";

    private final Ja030fMapper mapper;
    private final Ja030fLedgerRepository ledgerRepository;

    public List<Ja030fDto> list(String corpGr, LocalDate trYmd) {
        return blank(corpGr) || trYmd == null ? Collections.emptyList() : mapper.selectList(corpGr, trYmd);
    }

    @Transactional
    public int save(String corpGr, Ja030fSaveRequest request) {
        if (blank(corpGr) || request == null || request.getTrYmd() == null) return 0;
        int affected = 0;
        if (request.getDeletedList() != null) {
            for (Ja030fDto item : request.getDeletedList()) {
                if (item == null) continue;
                prepare(item, corpGr, request.getTrYmd());
                if (ledgerRepository.delete(item)) affected++;
            }
        }
        if (request.getItems() != null) {
            for (Ja030fDto item : request.getItems()) {
                if (item == null || blank(item.getFundCd()) || blank(item.getHjCd())) continue;
                prepare(item, corpGr, request.getTrYmd());
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

    private void prepare(Ja030fDto item, String corpGr, LocalDate trYmd) {
        item.setCorpGr(corpGr);
        item.setTrYmd(trYmd);
        item.setTrCd(TRADE_CODE);
        if (item.getAekm() == null) item.setAekm(BigDecimal.ZERO);
        if (item.getDanga() == null) item.setDanga(BigDecimal.ZERO);
    }

    private boolean blank(String value) { return value == null || value.isBlank(); }
}
