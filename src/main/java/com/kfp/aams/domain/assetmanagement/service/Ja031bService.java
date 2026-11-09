package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031bDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031bSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031bMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja031bService {

    private final Ja031bMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja031bDto> list(String corpGr) {
        if (isBlank(corpGr)) {
            return Collections.emptyList();
        }
        String cleanCorpGr = corpGr.trim();

        // 1. 기존 등록된 매핑 목록 조회
        List<Ja031bDto> list = new ArrayList<>(mapper.selectList(cleanCorpGr));
        Set<String> existingTrCoCds = new HashSet<>();
        for (Ja031bDto row : list) {
            if (row.getTrCoCd() != null) {
                existingTrCoCds.add(row.getTrCoCd().trim());
            }
        }

        // 2. PB w_ja031b::wue_retrieve: 이번달 선물/옵션 거래 발생 매매처 중 누락된 매매처 자동 병합 (신규 행 생성)
        try {
            List<Ja031bDto> activeList = mapper.selectActiveTradeCompanies(cleanCorpGr);
            for (Ja031bDto act : activeList) {
                if (act.getTrCoCd() != null && !existingTrCoCds.contains(act.getTrCoCd().trim())) {
                    act.setCorpGr(cleanCorpGr);
                    act.setGrCd("PP");
                    act.setIsNew(true);
                    act.setIsUpdated(false);
                    act.setIsDeleted(false);
                    act.setRowStatus("C");
                    act.setPVisible(1);
                    list.add(act);
                    existingTrCoCds.add(act.getTrCoCd().trim());
                }
            }
        } catch (Exception ex) {
            log.warn("[W_JA031B] selectActiveTradeCompanies 병합 중 오류 (기본 조회 결과 유지): {}", ex.getMessage());
        }

        return list;
    }

    @Transactional
    public Map<String, Object> save(Ja031bSaveRequest request) {
        if (request == null || isBlank(request.getCorpGr())) {
            throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
        }

        String corpGr = request.getCorpGr().trim();
        int inserted = 0;
        int updated = 0;
        int deleted = 0;

        // 1. 삭제 대상 처리
        if (request.getDeletedRows() != null) {
            for (Ja031bDto row : request.getDeletedRows()) {
                if (row != null && !isBlank(row.getTrCoCd())) {
                    row.setCorpGr(corpGr);
                    if (isBlank(row.getGrCd())) row.setGrCd("PP");
                    deleted += mapper.delete(row);
                }
            }
        }

        // 2. 신규 및 수정 대상 처리
        if (request.getRows() != null) {
            for (Ja031bDto row : request.getRows()) {
                if (row == null || Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus())) {
                    continue;
                }
                if (isBlank(row.getTrCoCd())) {
                    continue;
                }

                row.setCorpGr(corpGr);
                if (isBlank(row.getGrCd())) row.setGrCd("PP");

                boolean isNew = Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus());
                boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());

                if (isNew) {
                    if (mapper.existsRow(corpGr, row.getGrCd(), row.getTrCoCd().trim()) > 0) {
                        updated += mapper.update(row);
                    } else {
                        inserted += mapper.insert(row);
                    }
                } else if (isUpdated) {
                    if (mapper.existsRow(corpGr, row.getGrCd(), row.getTrCoCd().trim()) > 0) {
                        updated += mapper.update(row);
                    } else {
                        inserted += mapper.insert(row);
                    }
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", String.format("저장되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)", inserted, updated, deleted));
        return result;
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}

