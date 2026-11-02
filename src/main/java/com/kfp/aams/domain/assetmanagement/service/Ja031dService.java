package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031dDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031dSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031dMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja031dService {

    private final Ja031dMapper mapper;

    /**
     * W_JA031D (타사)수익증권 매매내역 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja031dDto> list(String corpGr, LocalDate ymd, String trCd) {
        if (corpGr == null || corpGr.isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        if (ymd == null) {
            throw new IllegalArgumentException("영업일자를 입력하십시오.");
        }
        if (trCd == null || trCd.isBlank()) {
            throw new IllegalArgumentException("거래코드를 선택하십시오.");
        }

        List<Ja031dDto> list = mapper.selectList(corpGr.trim(), ymd, trCd.trim());
        for (Ja031dDto dto : list) {
            dto.setIsNew(false);
            dto.setIsUpdated(false);
            dto.setIsDeleted(false);
            dto.setOriginalFundCd(dto.getFundCd());
            dto.setOriginalTasaJmCd(dto.getTasaJmCd());
            dto.setOriginalSeqNo(dto.getSeqNo());
            dto.setOriginalTrCoCd(dto.getTrCoCd());
            dto.setOriginalSudoYmd(dto.getSudoYmd());
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
     * 펀드 수탁사 정보 조회
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getFundCustodian(String corpGr, String fundCd) {
        if (corpGr == null || fundCd == null || fundCd.isBlank()) return Map.of();
        Map<String, Object> res = mapper.selectFundCustodian(corpGr.trim(), fundCd.trim());
        return res != null ? res : Map.of();
    }

    /**
     * 타사종목 정보 조회
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getTasaJmInfo(String corpGr, String tasaJmCd) {
        if (corpGr == null || tasaJmCd == null || tasaJmCd.isBlank()) return Map.of();
        Map<String, Object> res = mapper.selectTasaJmInfo(corpGr.trim(), tasaJmCd.trim());
        return res != null ? res : Map.of();
    }

    /**
     * 기준가/과표가 조회
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getGijunga(String corpGr, LocalDate ymd, String jmCd, String tasaFundCd) {
        if (corpGr == null || ymd == null || jmCd == null || jmCd.isBlank()) return Map.of();
        Map<String, Object> res = mapper.selectGijunga(corpGr.trim(), ymd, jmCd.trim(), tasaFundCd != null ? tasaFundCd.trim() : "");
        return res != null ? res : Map.of();
    }

    /**
     * 잔여좌수 조회 (전부매도 K61 더블클릭 연동)
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getResidualJwa(String corpGr, LocalDate ymd, String fundCd, String tasaJmCd) {
        if (corpGr == null || ymd == null || fundCd == null || tasaJmCd == null) return Map.of();
        Map<String, Object> res = mapper.selectResidualJwa(corpGr.trim(), ymd, fundCd.trim(), tasaJmCd.trim());
        return res != null ? res : Map.of();
    }

    /**
     * 일괄 저장 (CUD 트랜잭션, w_ja031d.srw updatestart 반영)
     */
    @Transactional
    public Map<String, Object> save(Ja031dSaveRequest request, String userId) {
        if (request == null) {
            throw new IllegalArgumentException("저장 요청 데이터가 없습니다.");
        }
        String corpGr = request.getCorpGr();
        LocalDate ymd = request.getYmd();
        String trCd = request.getTrCd();

        if (corpGr == null || corpGr.isBlank() || ymd == null || trCd == null || trCd.isBlank()) {
            throw new IllegalArgumentException("필수 파라미터(회사그룹, 영업일자, 거래코드)가 누락되었습니다.");
        }

        // 1. 삭제 처리
        int deletedCount = 0;
        if (request.getDeletedRows() != null) {
            for (Ja031dDto delDto : request.getDeletedRows()) {
                delDto.setCorpGr(corpGr);
                delDto.setTrYmd(ymd);
                delDto.setTrCd(trCd);
                deletedCount += mapper.deleteSjt5sg(delDto);
            }
        }

        // 2. 신규/수정 처리
        int insertedCount = 0;
        int updatedCount = 0;

        List<Ja031dDto> rows = request.getRows();
        if (rows != null && !rows.isEmpty()) {
            // PB w_ja031d.srw updatestart 유효성 검사:
            // IF f_num (Object.tr_jwa [lRow])=0 And Object.tr_ymd [lRow]=Object.gijunga_ymd [lRow] And f_nvl (Object.tasa_seolj_ymd [lRow],Object.gijunga_ymd [lRow])<>Object.tr_ymd [lRow]
            for (int i = 0; i < rows.size(); i++) {
                Ja031dDto row = rows.get(i);
                BigDecimal jwa = row.getTrJwa() != null ? row.getTrJwa() : BigDecimal.ZERO;
                LocalDate rowTrYmd = row.getTrYmd() != null ? row.getTrYmd() : ymd;
                LocalDate gijunYmd = row.getGijungaYmd() != null ? row.getGijungaYmd() : ymd;
                LocalDate seoljYmd = row.getTasaSeoljYmd() != null ? row.getTasaSeoljYmd() : gijunYmd;

                if (jwa.compareTo(BigDecimal.ZERO) == 0 && rowTrYmd.equals(gijunYmd) && !seoljYmd.equals(rowTrYmd)) {
                    throw new IllegalStateException((i + 1) + " 행에서 매매좌수 오류 (좌수가 0입니다)");
                }
            }

            // 시퀀스 최대값 채번
            Long maxSeqNo = mapper.selectMaxSeqNo(corpGr, ymd, trCd);
            if (maxSeqNo == null) maxSeqNo = 0L;

            for (Ja031dDto row : rows) {
                row.setCorpGr(corpGr);
                row.setTrYmd(ymd);
                row.setTrCd(trCd);
                row.setUpdJwa(userId);

                if (Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus())) {
                    maxSeqNo++;
                    row.setSeqNo(maxSeqNo);
                    insertedCount += mapper.insertSjt5sg(row);
                } else if (Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus())) {
                    updatedCount += mapper.updateSjt5sg(row);
                }
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("insertedCount", insertedCount);
        result.put("updatedCount", updatedCount);
        result.put("deletedCount", deletedCount);
        result.put("message", "저장되었습니다. (등록: " + insertedCount + "건, 수정: " + updatedCount + "건, 삭제: " + deletedCount + "건)");
        return result;
    }
}

