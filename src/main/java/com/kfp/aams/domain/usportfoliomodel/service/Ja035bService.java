package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035bDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja035bMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA035B 해외주식 매매내역 비즈니스 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja035bService {

    private final Ja035bMapper ja035bMapper;

    /**
     * 해외주식 매매내역 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja035bDto> getList(String corpGr, String ymd, String trCd, String fundCd) {
        return ja035bMapper.selectList(corpGr, ymd, trCd, fundCd);
    }

    /**
     * 해외주식 잔고 목록 조회 (매도 시 보유종목 자동 불러오기용)
     */
    @Transactional(readOnly = true)
    public List<Ja035bDto> getBalanceList(String corpGr, String ymd, String fundCd) {
        return ja035bMapper.selectBalanceList(corpGr, ymd, fundCd);
    }

    /**
     * 최대 TR_SEQ 조회
     */
    @Transactional(readOnly = true)
    public Long getMaxTrSeq(String corpGr, String ymd, String fundCd) {
        return ja035bMapper.selectMaxTrSeq(corpGr, ymd, fundCd);
    }

    /**
     * 통화별 환율 조회 (F_CURRENCY_RT)
     */
    @Transactional(readOnly = true)
    public BigDecimal getCurrencyRate(String corpGr, String ymd, String currency) {
        return ja035bMapper.selectCurrencyRate(corpGr, ymd, currency);
    }

    /**
     * 보관처 기본 통화 조회
     */
    @Transactional(readOnly = true)
    public String getTrusteeCurrency(String corpGr, String trustee) {
        return ja035bMapper.selectTrusteeCurrency(corpGr, trustee);
    }

    /**
     * 펀드 매매처코드 조회
     */
    @Transactional(readOnly = true)
    public String getFundTrCoCd(String corpGr, String fundCd) {
        return ja035bMapper.selectFundTrCoCd(corpGr, fundCd);
    }

    /**
     * 종목 정보 단건 조회
     */
    @Transactional(readOnly = true)
    public Map<String, Object> getItemInfo(String corpGr, String jmCd) {
        return ja035bMapper.selectItemInfo(corpGr, jmCd);
    }

    /**
     * 해외주식 매매내역 CUD 일괄 저장
     */
    @Transactional
    public Map<String, Object> saveList(String corpGr, List<Ja035bDto> dtoList) {
        int inserted = 0;
        int updated = 0;
        int deleted = 0;

        if (dtoList == null || dtoList.isEmpty()) {
            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("message", "저장할 변경 내역이 없습니다.");
            res.put("inserted", 0);
            res.put("updated", 0);
            res.put("deleted", 0);
            return res;
        }

        // 펀드/일자별 maxSeq 캐시
        Map<String, Long> seqCache = new HashMap<>();

        for (Ja035bDto dto : dtoList) {
            // Zero-Hardcoding: corpGr 설정
            if (dto.getCorpGr() == null || dto.getCorpGr().trim().isEmpty()) {
                dto.setCorpGr(corpGr);
            }

            // 삭제 처리
            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                deleted += ja035bMapper.deleteSyt0mg(dto);
                continue;
            }

            // 신규 등록
            if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                String cacheKey = (dto.getTrYmd() != null ? dto.getTrYmd().replaceAll("[^0-9]", "") : "")
                        + "_" + (dto.getFundCd() != null ? dto.getFundCd().trim() : "");

                Long currentSeq = seqCache.get(cacheKey);
                if (currentSeq == null) {
                    currentSeq = ja035bMapper.selectMaxTrSeq(dto.getCorpGr(), dto.getTrYmd(), dto.getFundCd());
                    if (currentSeq == null) currentSeq = 0L;
                }
                currentSeq++;
                seqCache.put(cacheKey, currentSeq);
                dto.setTrSeq(currentSeq);

                // 매매처코드 누락 시 펀드 기본 매매처 조회 세팅
                if (dto.getTrCoCd() == null || dto.getTrCoCd().trim().isEmpty()) {
                    dto.setTrCoCd(ja035bMapper.selectFundTrCoCd(dto.getCorpGr(), dto.getFundCd()));
                }

                inserted += ja035bMapper.insertSyt0mg(dto);
                continue;
            }

            // 수정
            if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                updated += ja035bMapper.updateSyt0mg(dto);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", String.format("정상적으로 저장되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)", inserted, updated, deleted));
        result.put("inserted", inserted);
        result.put("updated", updated);
        result.put("deleted", deleted);
        return result;
    }
}
