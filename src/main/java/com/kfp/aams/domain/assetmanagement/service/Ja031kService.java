package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031kDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031kSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031kMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA031K 기타수입 입금등록 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja031kService {

    private final Ja031kMapper mapper;

    /**
     * 입금거래 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja031kDto> list(String corpGr, LocalDate trYmd, String trCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trCd == null || trCd.isBlank()) {
            return Collections.emptyList();
        }
        return mapper.selectList(corpGr.trim(), trYmd, trCd.trim());
    }

    /**
     * 달력 하이라이트 일자 목록 조회
     */
    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return mapper.selectHighlightDates(corpGr.trim());
    }

    /**
     * 펀드 및 수탁사 정보 조회
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getFundInfo(String corpGr, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyMap();
        }
        return mapper.selectFundInfo(corpGr.trim(), fundCd.trim());
    }

    /**
     * CUD 일괄 저장 (Insert, Update, Delete)
     */
    @Transactional
    public Map<String, Object> save(Ja031kSaveRequest req) {
        Map<String, Object> result = new HashMap<>();
        if (req == null) {
            result.put("success", false);
            result.put("message", "요청 데이터가 없습니다.");
            return result;
        }

        String corpGr = req.getCorpGr();
        LocalDate ymd = req.getYmd();
        String trCd = req.getTrCd();

        int inserted = 0;
        int updated = 0;
        int deleted = 0;

        // 1. 삭제 대상 행 처리
        if (req.getDeletedRows() != null) {
            for (Ja031kDto row : req.getDeletedRows()) {
                if (row == null || row.getFundCd() == null || row.getFundCd().isBlank()) continue;
                row.setCorpGr(corpGr);
                row.setTrYmd(ymd);
                row.setTrCd(trCd);
                mapper.deleteSkt0hs(row);
                deleted++;
            }
        }

        // 2. 신규 및 수정 대상 행 처리
        if (req.getRows() != null) {
            for (Ja031kDto row : req.getRows()) {
                if (row == null) continue;
                row.setCorpGr(corpGr);
                row.setTrYmd(ymd);
                row.setTrCd(trCd);

                if (Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus())) {
                    if (row.getFundCd() != null && !row.getFundCd().isBlank()) {
                        mapper.deleteSkt0hs(row);
                        deleted++;
                    }
                } else if (Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus())) {
                    if (row.getFundCd() == null || row.getFundCd().isBlank()) {
                        throw new IllegalArgumentException("펀드번호(관리번호)는 필수 입력 항목입니다.");
                    }
                    if (mapper.existsSkt0hs(corpGr, ymd, row.getFundCd().trim(), trCd) > 0) {
                        throw new IllegalArgumentException("이미 등록된 관리번호[" + row.getFundCd() + "]입니다.");
                    }
                    mapper.insertSkt0hs(row);
                    inserted++;
                } else if (Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus())) {
                    if (row.getFundCd() == null || row.getFundCd().isBlank()) {
                        throw new IllegalArgumentException("펀드번호(관리번호)는 필수 입력 항목입니다.");
                    }
                    mapper.updateSkt0hs(row);
                    updated++;
                }
            }
        }

        result.put("success", true);
        result.put("message", String.format("저장되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)", inserted, updated, deleted));
        result.put("inserted", inserted);
        result.put("updated", updated);
        result.put("deleted", deleted);
        return result;
    }
}

