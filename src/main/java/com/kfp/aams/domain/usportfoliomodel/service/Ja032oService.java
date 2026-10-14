package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oFundDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032oOrderCreateRequestDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032oMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Service for W_JA032O (파생 환매수 운용지시)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032oService {

    private final Ja032oMapper ja032oMapper;

    /**
     * 1. 펀드/포트 만기별 목록 조회 (d_ja032o1)
     */
    @Transactional(readOnly = true)
    public List<Ja032oFundDto> getFundList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return List.of();
        }
        return ja032oMapper.selectFundList(corpGr.trim(), ymd);
    }

    /**
     * 2. 파생상품 보유 내역 및 환매수 주문 생성 목록 조회 (d_ja032o2)
     */
    @Transactional(readOnly = true)
    public List<Ja032oDetailDto> getDetailList(String corpGr, LocalDate ymd, String fundCd, String portNum) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank() || portNum == null || portNum.isBlank()) {
            return List.of();
        }
        return ja032oMapper.selectDetailList(corpGr.trim(), ymd, fundCd.trim(), portNum.trim());
    }

    /**
     * 3. 환매수 주문생성 실행 (cb_syt0mg::clicked 100% 동일 구현)
     */
    @Transactional
    public Map<String, Object> createRepurchaseOrders(Ja032oOrderCreateRequestDto req) {
        Map<String, Object> result = new HashMap<>();

        if (req == null || req.getItems() == null || req.getItems().isEmpty()) {
            result.put("success", false);
            result.put("message", "주문생성 대상 데이터가 없습니다.");
            return result;
        }

        String corpGr = req.getCorpGr();
        LocalDate ymd = (req.getYmd() != null && !req.getYmd().isBlank())
                ? LocalDate.parse(req.getYmd())
                : LocalDate.now();
        String trCoCd = req.getTrCoCd();
        String fundCd = req.getFundCd();
        String trustee = "(" + (req.getPortNum() != null ? req.getPortNum().trim() : "") + ")";

        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank()) {
            result.put("success", false);
            result.put("message", "필수 파라미터(회사그룹, 펀드코드)가 누락되었습니다.");
            return result;
        }

        int createdCount = 0;
        try {
            for (Ja032oOrderCreateRequestDto.OrderItem item : req.getItems()) {
                if (item.getOrderSu() == null || item.getOrderSu().compareTo(BigDecimal.ZERO) <= 0
                        || item.getOrderAek() == null || item.getOrderAek().compareTo(BigDecimal.ZERO) <= 0) {
                    continue;
                }

                String jmCd = item.getJmCd();
                String trCd = (item.getTrCd() != null && !item.getTrCd().isBlank()) ? item.getTrCd().trim() : "S71";
                String currency = (item.getCurrency() != null && !item.getCurrency().isBlank()) ? item.getCurrency().trim() : "USD";
                BigDecimal su = item.getOrderSu();
                BigDecimal aek = item.getOrderAek();
                BigDecimal trAek = su.multiply(aek);

                // 1) TR_SEQ 채번
                Long trSeq = ja032oMapper.selectNextTrSeq(corpGr, ymd, fundCd, jmCd, trCd);

                // 2) SYT1MG 환매수 거래 INSERT
                ja032oMapper.insertSyt1mg(corpGr, ymd, trCd, fundCd, trCoCd, trustee, jmCd, currency, trSeq, su, aek, trAek);

                createdCount++;
            }

            if (createdCount > 0) {
                result.put("success", true);
                result.put("count", createdCount);
                result.put("message", "환매수 생성을 완료 했습니다. (생성건수: " + createdCount + "건)");
            } else {
                result.put("success", false);
                result.put("message", "유효한 주문수량/주문단가가 입력된 행이 없습니다.");
            }
        } catch (Exception e) {
            log.error("[W_JA032O] createRepurchaseOrders error: ", e);
            result.put("success", false);
            result.put("message", "환매수 주문생성 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }
}
