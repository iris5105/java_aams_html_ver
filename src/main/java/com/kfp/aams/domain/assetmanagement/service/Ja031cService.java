package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031cDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031cSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031cMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class Ja031cService {

    private final Ja031cMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja031cDto> list(String corpGr, LocalDate ymd, String trCd) {
        if (isBlank(corpGr) || ymd == null || isBlank(trCd)) {
            return Collections.emptyList();
        }
        return mapper.selectList(corpGr.trim(), ymd, trCd.trim());
    }

    @Transactional(readOnly = true)
    public List<String> highlightDates(String corpGr) {
        return isBlank(corpGr) ? Collections.emptyList() : mapper.selectHighlightDates(corpGr.trim());
    }

    @Transactional(readOnly = true)
    public int nextSequence(String corpGr, LocalDate ymd, String trCd) {
        return mapper.selectMaxSequence(corpGr.trim(), ymd, trCd.trim()) + 1;
    }

    @Transactional
    public Map<String, Object> save(Ja031cSaveRequest request) {
        if (request == null || isBlank(request.getCorpGr()) || request.getYmd() == null || isBlank(request.getTrCd())) {
            throw new IllegalArgumentException("회사그룹, 영업일자, 거래구분은 필수입니다.");
        }

        String corpGr = request.getCorpGr().trim();
        String trCd = request.getTrCd().trim();
        int inserted = 0;
        int updated = 0;
        int deleted = 0;

        if (request.getDeletedRows() != null) {
            for (Ja031cDto row : request.getDeletedRows()) {
                if (isUsableRow(row)) {
                    applyKeys(row, corpGr, request.getYmd(), trCd);
                    deleted += mapper.delete(row);
                }
            }
        }

        if (request.getRows() != null) {
            for (Ja031cDto row : request.getRows()) {
                if (row == null || Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus())) {
                    continue;
                }
                applyKeys(row, corpGr, request.getYmd(), trCd);
                if (Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus())) {
                    requireFund(row);
                    if (row.getTrSeqNo() == null || row.getTrSeqNo() < 1) {
                        row.setTrSeqNo(nextSequence(corpGr, request.getYmd(), trCd));
                    }
                    if (mapper.existsRow(corpGr, request.getYmd(), trCd, row.getFundCd(), row.getTrSeqNo()) > 0) {
                        throw new IllegalArgumentException("이미 등록된 순번입니다.");
                    }
                    inserted += mapper.insert(row);
                } else if (Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus())) {
                    requireFund(row);
                    updated += mapper.update(row);
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", String.format("저장되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)", inserted, updated, deleted));
        return result;
    }

    private void applyKeys(Ja031cDto row, String corpGr, LocalDate ymd, String trCd) {
        row.setCorpGr(corpGr);
        row.setTrYmd(ymd);
        row.setTrCd(trCd);
        row.setTrustee("KRW");
        row.setCurrency("KRW");
    }

    private void requireFund(Ja031cDto row) {
        if (isBlank(row.getFundCd())) {
            throw new IllegalArgumentException("관리번호는 필수입니다.");
        }
        row.setFundCd(row.getFundCd().trim());
    }

    private boolean isUsableRow(Ja031cDto row) {
        return row != null && !isBlank(row.getFundCd()) && row.getTrSeqNo() != null;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
