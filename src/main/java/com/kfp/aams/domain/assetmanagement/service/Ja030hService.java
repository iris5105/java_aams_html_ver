package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030hDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030hSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030hMapper;
import com.kfp.aams.domain.assetmanagement.mapper.querydsl.Ja030hLedgerRepository;
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
public class Ja030hService {
    private final Ja030hMapper mapper;
    private final Ja030hLedgerRepository ledgerRepository;

    public List<Ja030hDto> list(String corpGr, LocalDate trYmd, String trCd, String fundCd) {
        if (blank(corpGr) || trYmd == null || blank(trCd)) return Collections.emptyList();
        String queryFundCd = blank(fundCd) ? "%" : fundCd;
        List<Ja030hDto> rows = mapper.selectList(corpGr, trYmd, trCd, queryFundCd);
        if (!rows.isEmpty() || blank(fundCd)) return rows;
        return mapper.selectInitialHoldings(corpGr, trYmd, trCd, fundCd);
    }

    @Transactional
    public int save(String corpGr, Ja030hSaveRequest request) {
        if (blank(corpGr) || request == null || request.getTrYmd() == null || blank(request.getTrCd())) return 0;
        int affected = 0;
        if (request.getDeletedList() != null) {
            for (Ja030hDto item : request.getDeletedList()) {
                if (item == null) continue;
                prepare(item, corpGr, request);
                if (ledgerRepository.delete(item)) affected++;
            }
        }
        if (request.getItems() != null) {
            for (Ja030hDto item : request.getItems()) {
                if (item == null || blank(item.getFundCd()) || blank(item.getJmCd())) continue;
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

    private void prepare(Ja030hDto item, String corpGr, Ja030hSaveRequest request) {
        item.setCorpGr(corpGr);
        item.setTrYmd(request.getTrYmd());
        item.setTrCd(request.getTrCd());
        item.setAekm(zero(item.getAekm()));
        item.setTrAek(zero(item.getTrAek()));
        item.setMijigubTax(zero(item.getMijigubTax()));
        if (blank(item.getJajunGb())) item.setJajunGb("3");
    }

    private BigDecimal zero(BigDecimal value) { return value == null ? BigDecimal.ZERO : value; }
    private boolean blank(String value) { return value == null || value.isBlank(); }
}
