package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.*;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032eCallMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Service for W_JA032E_CALL (USPM 운용지시 CALL배분작업)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032eCallService {

    private final Ja032eCallMapper ja032eCallMapper;

    /**
     * 1. 펀드/포트 목록 조회 (d_ja032e1_call)
     */
    public List<Ja032eCallFundDto> getFundList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja032eCallMapper.selectFundList(corpGr.trim(), ymd);
    }

    /**
     * 2. 포트 내 종목 설정 목록 조회 (d_ja032e2_call)
     */
    public List<Ja032eCallPortDto> getPortList(String corpGr, String fundCd, LocalDate ymd, String portNum) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank() || ymd == null || portNum == null || portNum.isBlank()) {
            return Collections.emptyList();
        }
        return ja032eCallMapper.selectPortList(corpGr.trim(), fundCd.trim(), ymd, portNum.trim());
    }

    /**
     * 3. 해외옵션 상세 시세 및 주문 목록 조회 (d_ja032e3_call)
     * 파워빌더 dw_detail::ue_retrieve의 옵션종목코드 동적 조합 로직 반영 (' C%')
     */
    public List<Ja032eCallDetailDto> getDetailList(String corpGr,
                                                   LocalDate ymd,
                                                   LocalDate mangiYmd,
                                                   String srsCd,
                                                   BigDecimal targetReturnPer,
                                                   BigDecimal jonga) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || mangiYmd == null || srsCd == null || srsCd.isBlank()) {
            return Collections.emptyList();
        }

        // 옵션 종목 접두사 조회 (SZX0YM 테이블 기준)
        String prefix = ja032eCallMapper.selectOptionJmCdPrefix(mangiYmd, srsCd.trim());
        if (prefix == null || prefix.isBlank()) {
            prefix = srsCd.trim();
        }
        String optJmCdPattern = prefix + " C%";
        String mangiStr = mangiYmd.format(DateTimeFormatter.ofPattern("yyyyMMdd"));

        BigDecimal targetPer = targetReturnPer != null ? targetReturnPer : BigDecimal.ZERO;
        BigDecimal jongaVal = jonga != null ? jonga : BigDecimal.ZERO;

        return ja032eCallMapper.selectDetailList(corpGr.trim(), ymd, optJmCdPattern, targetPer, jongaVal, mangiStr);
    }

    /**
     * TT 세부코드명 조회 (헤더 타이틀 변경용)
     */
    public String getTtTitle(String tt) {
        if (tt == null || tt.isBlank()) return "";
        String title = ja032eCallMapper.selectTtTitle(tt.trim());
        return title != null ? title : "";
    }

    /**
     * 4. 설정 일괄 저장 (펀드 만기/설정, 포트 목표수익률 등)
     */
    @Transactional
    public Map<String, Object> saveSettings(Ja032eCallSaveRequestDto req) {
        Map<String, Object> result = new HashMap<>();
        if (req == null) {
            result.put("success", false);
            result.put("message", "요청 데이터가 없습니다.");
            return result;
        }

        int portUpdated = 0;
        int uspmUpdated = 0;

        try {
            if (req.getFundList() != null) {
                for (Ja032eCallFundDto fund : req.getFundList()) {
                    if (Boolean.TRUE.equals(fund.getIsUpdated())) {
                        portUpdated += ja032eCallMapper.updateUspmPort(fund);
                    }
                }
            }

            if (req.getPortList() != null) {
                for (Ja032eCallPortDto port : req.getPortList()) {
                    if (Boolean.TRUE.equals(port.getIsUpdated())) {
                        uspmUpdated += ja032eCallMapper.updateUspm(port);
                    }
                }
            }

            result.put("success", true);
            result.put("message", String.format("정상적으로 저장되었습니다. (펀드설정: %d건, 포트설정: %d건)", portUpdated, uspmUpdated));
            result.put("portUpdated", portUpdated);
            result.put("uspmUpdated", uspmUpdated);
        } catch (Exception e) {
            log.error("[W_JA032E_CALL] saveSettings error: ", e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }

    /**
     * 5. CALL 배분생성 실행
     * 파워빌더 w_ja032e_call cb_syt0mg::clicked 100% 동일 구현
     */
    @Transactional
    public Map<String, Object> createCallOrders(Ja032eCallOrderCreateRequestDto req) {
        Map<String, Object> result = new HashMap<>();
        if (req == null || req.getItems() == null || req.getItems().isEmpty()) {
            result.put("success", false);
            result.put("message", "배분생성 대상 주문 건이 없습니다.");
            return result;
        }

        String corpGr = req.getCorpGr();
        LocalDate ymd = LocalDate.parse(req.getYmd());
        String fundCd = req.getFundCd();
        String portNum = req.getPortNum();
        String trCoCd = req.getTrCoCd();
        String yjCd = req.getYjCd();
        String currency = req.getCurrency() != null ? req.getCurrency() : "USD";
        String trustee = "(" + portNum + ")";

        int createdCount = 0;

        for (Ja032eCallOrderCreateRequestDto.OrderItem item : req.getItems()) {
            String orderGb = item.getOrderGb();
            BigDecimal trSu = item.getTrSu();
            BigDecimal bidAsk = item.getBidAsk();

            if (orderGb == null || trSu == null || trSu.compareTo(BigDecimal.ZERO) <= 0
                    || bidAsk == null || bidAsk.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }

            String trCd = "매수".equals(orderGb) ? "S70" : "S80";
            String optJmCd = item.getOptJmCd();
            BigDecimal hangsaGa = item.getHangsaGa();
            BigDecimal trAek = trSu.multiply(bidAsk);

            // 1) SYT1MG TR_SEQ 채번
            BigDecimal trSeq = ja032eCallMapper.selectNextTrSeq(corpGr, ymd, fundCd, optJmCd, trCd);

            // 2) SYT1MG INSERT
            ja032eCallMapper.insertSyt1mg(corpGr, ymd, trCd, fundCd, trCoCd, trustee, optJmCd, currency,
                    trSeq, trSu, bidAsk, trAek);

            // 3) CALL 종목명 조합 (1 -> (1W) C, 2 -> (2W) C, 4 -> (4W) C, 5 -> (5W) C)
            String jmNm = optJmCd;
            if (optJmCd != null && !optJmCd.isEmpty()) {
                char firstChar = optJmCd.charAt(0);
                String subPart = optJmCd.substring(1);
                switch (firstChar) {
                    case '1':
                        jmNm = subPart.replace(" C", "(1W) C");
                        break;
                    case '2':
                        jmNm = subPart.replace(" C", "(2W) C");
                        break;
                    case '4':
                        jmNm = subPart.replace(" C", "(4W) C");
                        break;
                    case '5':
                        jmNm = subPart.replace(" C", "(5W) C");
                        break;
                    default:
                        jmNm = optJmCd;
                        break;
                }
                if (item.getMm() != null && !item.getMm().isBlank()) {
                    jmNm = jmNm + "-" + item.getMm();
                }
            }

            // 4) API_Q INSERT ('CALL')
            ja032eCallMapper.insertApiQ(corpGr, optJmCd, jmNm, yjCd, hangsaGa);

            createdCount++;
        }

        result.put("success", true);
        result.put("createdCount", createdCount);
        result.put("message", "배분생성을 완료했습니다. (" + createdCount + "건 생성)");
        return result;
    }

    /**
     * 6. 변동성 재계산 프로시저 호출 (cb_recom)
     */
    @Transactional
    public Map<String, Object> recalculateVolatility(String corpGr, String ymd) {
        Map<String, Object> result = new HashMap<>();
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            result.put("success", false);
            result.put("message", "필수 파라미터가 누락되었습니다.");
            return result;
        }

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("corpGr", corpGr.trim());
            params.put("ymd", ymd.replace("-", ".").trim());
            params.put("mode", "ref");
            params.put("outMsg", null);

            ja032eCallMapper.callSrJa032a(params);

            String outMsg = (String) params.get("outMsg");
            if (outMsg == null) outMsg = "N";

            if (outMsg.startsWith("Y")) {
                String detailMsg = outMsg.length() > 2 ? outMsg.substring(2) : "완료";
                result.put("success", true);
                result.put("message", "변경된 조건으로 " + detailMsg + " 완료!!!");
            } else {
                result.put("success", false);
                result.put("message", "변동성 재계산 실행 중 오류가 발생했습니다: " + outMsg);
            }
        } catch (Exception e) {
            log.error("[W_JA032E_CALL] recalculateVolatility error: ", e);
            result.put("success", false);
            result.put("message", "변동성 재계산 중 서버 오류: " + e.getMessage());
        }

        return result;
    }
}
