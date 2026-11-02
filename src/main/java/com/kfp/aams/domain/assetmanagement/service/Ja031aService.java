package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031aDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031aSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031aMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja031aService {

    private final Ja031aMapper mapper;

    /**
     * W_JA031A 선물매매 거래 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja031aDto> list(String corpGr, LocalDate ymd, String trCd) {
        if (corpGr == null || corpGr.isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        if (ymd == null) {
            throw new IllegalArgumentException("영업일자를 입력하십시오.");
        }
        if (trCd == null || trCd.isBlank()) {
            throw new IllegalArgumentException("매매구분을 선택하십시오.");
        }

        List<Ja031aDto> list = mapper.selectList(corpGr.trim(), ymd, trCd.trim());
        for (Ja031aDto dto : list) {
            dto.setIsNew(false);
            dto.setIsUpdated(false);
            dto.setIsDeleted(false);
            dto.setOriginalFundCd(dto.getFundCd());
            dto.setOriginalSjCd(dto.getSjCd());
            dto.setOriginalTrSeqNo(dto.getTrSeqNo());
        }
        return list;
    }

    /**
     * 달력 하이라이트 일자 조회
     */
    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) return List.of();
        return mapper.selectDates(corpGr.trim());
    }

    /**
     * 종목별 단위승수 조회
     */
    @Transactional(readOnly = true)
    public Double getUnitAek(String corpGr, String sjCd) {
        if (corpGr == null || sjCd == null || sjCd.isBlank()) return 1.0;
        return mapper.selectUnitAek(corpGr.trim(), sjCd.trim());
    }

    /**
     * 만기거래생성 프로시저 호출 (KFP.SR_JA031A)
     */
    @Transactional
    public String createExpiry(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        if (ymd == null) {
            throw new IllegalArgumentException("영업일자를 입력하십시오.");
        }

        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr.trim());
        params.put("ymd", Date.valueOf(ymd));
        params.put("pMsg", null);

        mapper.callSrJa031a(params);

        Object outMsg = params.get("pMsg");
        String msgStr = (outMsg != null) ? outMsg.toString().trim() : "";

        if ("Y".equalsIgnoreCase(msgStr)) {
            return "거래내역 생성처리를 완료 했습니다.";
        } else if (!msgStr.isEmpty()) {
            throw new IllegalArgumentException(msgStr);
        } else {
            throw new IllegalArgumentException("만기거래생성 중 응답 메시지가 없습니다.");
        }
    }

    /**
     * W_JA031A 선물매매 거래 일괄 저장 (CUD)
     */
    @Transactional
    public int save(String corpGr, Ja031aSaveRequest request, String userId) {
        if (request == null) {
            throw new IllegalArgumentException("저장할 데이터가 없습니다.");
        }
        LocalDate ymd = request.getYmd();
        String trCd = request.getTrCd();
        if (ymd == null || trCd == null || trCd.isBlank()) {
            throw new IllegalArgumentException("영업일자와 매매구분을 확인하십시오.");
        }

        String safeCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr.trim() : request.getCorpGr();
        if (safeCorpGr == null || safeCorpGr.isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }

        int count = 0;

        // 1. 삭제 대상 처리
        if (request.getDeletedList() != null) {
            for (Ja031aDto dto : request.getDeletedList()) {
                if (dto == null) continue;
                dto.setCorpGr(safeCorpGr);
                if (dto.getTrYmd() == null) dto.setTrYmd(ymd);
                if (dto.getTrCd() == null || dto.getTrCd().isBlank()) dto.setTrCd(trCd);
                count += mapper.deleteSst1kt(dto);
            }
        }

        // 2. 등록 및 수정 대상 처리
        if (request.getItems() != null && !request.getItems().isEmpty()) {
            // 신규 채번을 위한 현재 최대 거래순번 조회
            Long maxSeq = mapper.selectMaxTrSeqNo(safeCorpGr, ymd, trCd);
            if (maxSeq == null) maxSeq = 1000L;

            for (Ja031aDto dto : request.getItems()) {
                if (dto == null) continue;
                dto.setCorpGr(safeCorpGr);
                dto.setTrYmd(ymd);
                dto.setTrCd(trCd);
                dto.setIpUser(userId);

                boolean isNew = Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus());
                boolean isUpdated = Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus());

                if (isNew) {
                    if (dto.getFundCd() == null || dto.getFundCd().isBlank()) {
                        throw new IllegalArgumentException("관리번호를 입력하십시오.");
                    }
                    if (dto.getSjCd() == null || dto.getSjCd().isBlank()) {
                        throw new IllegalArgumentException("선물종목을 입력하십시오.");
                    }

                    maxSeq++;
                    dto.setTrSeqNo(maxSeq);
                    if (dto.getChasu() == null) dto.setChasu(1);

                    count += mapper.insertSst1kt(dto);
                } else if (isUpdated) {
                    count += mapper.updateSst1kt(dto);
                }
            }
        }

        return count;
    }
}

