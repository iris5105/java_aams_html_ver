package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.*;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032ePutMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja032ePutService {

    private final Ja032ePutMapper ja032ePutMapper;

    /**
     * 1. 펀드/포트 목록 조회 (d_ja032e1_put)
     */
    public List<Ja032ePutFundDto> getFundList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja032ePutMapper.selectFundList(corpGr.trim(), ymd);
    }

    /**
     * 2. 포트 내 종목 설정 목록 조회 (d_ja032e2_put)
     */
    public List<Ja032ePutPortDto> getPortList(String corpGr, String fundCd, LocalDate ymd, String portNum) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank() || ymd == null || portNum == null) {
            return Collections.emptyList();
        }
        return ja032ePutMapper.selectPortList(corpGr.trim(), fundCd.trim(), ymd, portNum.trim());
    }

    /**
     * 3. 해외옵션 상세 시세 및 주문 목록 조회 (d_ja032e3_put)
     * 파워빌더 dw_detail::ue_retrieve의 옵션종목코드 동적 조합 로직 반영
     */
    public List<Ja032ePutDetailDto> getDetailList(String corpGr,
                                                 LocalDate ymd,
                                                 LocalDate mangiYmd,
                                                 String srsCd,
                                                 BigDecimal targetReturnPer,
                                                 BigDecimal jonga) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || mangiYmd == null || srsCd == null || srsCd.isBlank()) {
            return Collections.emptyList();
        }

        // 옵션 종목 접두사 조회 (SZX0YM 테이블 기준)
        String prefix = ja032ePutMapper.selectOptionJmCdPrefix(mangiYmd, srsCd.trim());
        if (prefix == null || prefix.isBlank()) {
            prefix = srsCd.trim();
        }
        String optJmCdPattern = prefix + " P%";
        String mangiStr = mangiYmd.format(DateTimeFormatter.ofPattern("yyyyMMdd"));

        BigDecimal targetPer = targetReturnPer != null ? targetReturnPer : BigDecimal.ZERO;
        BigDecimal jongaVal = jonga != null ? jonga : BigDecimal.ZERO;

        return ja032ePutMapper.selectDetailList(corpGr.trim(), ymd, optJmCdPattern, targetPer, jongaVal, mangiStr);
    }

    /**
     * TT 세부코드명 조회 (헤더 타이틀 변경용)
     */
    public String getTtTitle(String tt) {
        if (tt == null || tt.isBlank()) return "";
        String title = ja032ePutMapper.selectTtTitle(tt.trim());
        return title != null ? title : "";
    }

    /**
     * 4. USPM_PORT 및 USPM 설정 일괄 저장
     */
    @Transactional
    public Map<String, Object> saveSettings(Ja032ePutSaveRequestDto req) {
        Map<String, Object> result = new HashMap<>();
        if (req == null) {
            result.put("success", false);
            result.put("message", "요청 데이터가 없습니다.");
            return result;
        }

        int portUpdated = 0;
        int uspmUpdated = 0;

        // 1) 펀드/포트 목록 (USPM_PORT) 갱신
        if (req.getFundList() != null) {
            for (Ja032ePutFundDto fund : req.getFundList()) {
                if (Boolean.TRUE.equals(fund.getIsUpdated())) {
                    portUpdated += ja032ePutMapper.updateUspmPort(fund);
                }
            }
        }

        // 2) 포트 내 종목 설정 (USPM) 갱신
        if (req.getPortList() != null) {
            for (Ja032ePutPortDto port : req.getPortList()) {
                if (Boolean.TRUE.equals(port.getIsUpdated()) && !Boolean.TRUE.equals(port.getIsSummaryRow())) {
                    uspmUpdated += ja032ePutMapper.updateUspm(port);
                }
            }
        }

        result.put("success", true);
        result.put("message", "정상적으로 저장되었습니다. (포트설정: " + portUpdated + "건, 종목설정: " + uspmUpdated + "건)");
        return result;
    }

    /**
     * 5. PUT 배분생성 (SYT1MG 주문 생성 + API_Q 파생종목 큐 생성)
     * 파워빌더 w_ja032e_put cb_syt0mg::clicked 100% 동일 구현
     */
    @Transactional
    public Map<String, Object> createPutOrders(Ja032ePutOrderCreateRequestDto req) {
        Map<String, Object> result = new HashMap<>();
        if (req == null || req.getItems() == null || req.getItems().isEmpty()) {
            result.put("success", false);
            result.put("message", "배분 생성할 주문 데이터가 없습니다.");
            return result;
        }

        String corpGr = req.getCorpGr();
        LocalDate ymd = LocalDate.parse(req.getYmd());
        String trCoCd = req.getTrCoCd() != null ? req.getTrCoCd().trim() : "00003";
        String fundCd = req.getFundCd() != null ? req.getFundCd().trim() : "";
        String trustee = "(" + (req.getPortNum() != null ? req.getPortNum().trim() : "") + ")";
        String yjCd = req.getYjCd() != null ? req.getYjCd().trim() : "";
        String currency = req.getCurrency() != null ? req.getCurrency().trim() : "USD";

        int createdCount = 0;

        for (Ja032ePutOrderCreateRequestDto.OrderItem item : req.getItems()) {
            BigDecimal trSu = item.getTrSu();
            BigDecimal bidAsk = item.getBidAsk();

            if (trSu != null && trSu.compareTo(BigDecimal.ZERO) > 0
                    && bidAsk != null && bidAsk.compareTo(BigDecimal.ZERO) > 0) {

                String optJmCd = item.getOptJmCd() != null ? item.getOptJmCd().trim() : "";
                BigDecimal hangsaGa = item.getHangsaGa() != null ? item.getHangsaGa() : BigDecimal.ZERO;
                String trCd = "매수".equals(item.getOrderGb()) ? "S90" : "SA0"; // 매도: SA0, 매수: S90

                BigDecimal trAek = trSu.multiply(bidAsk);

                // 1) TR_SEQ 채번
                BigDecimal trSeq = ja032ePutMapper.selectNextTrSeq(corpGr, ymd, fundCd, optJmCd, trCd);

                // 2) SYT1MG 매매 주문 INSERT
                ja032ePutMapper.insertSyt1mg(corpGr, ymd, trCd, fundCd, trCoCd, trustee, optJmCd, currency,
                        trSeq, trSu, bidAsk, trAek);

                // 3) 종목명 치환 (1~5주차 옵션 명칭 규격)
                String jmNm;
                if (optJmCd.startsWith("1")) {
                    jmNm = optJmCd.substring(1).replace(" P", "(1W) P");
                } else if (optJmCd.startsWith("2")) {
                    jmNm = optJmCd.substring(1).replace(" P", "(2W) P");
                } else if (optJmCd.startsWith("4")) {
                    jmNm = optJmCd.substring(1).replace(" P", "(4W) P");
                } else if (optJmCd.startsWith("5")) {
                    jmNm = optJmCd.substring(1).replace(" P", "(5W) P");
                } else {
                    jmNm = optJmCd;
                }
                if (item.getMm() != null && !item.getMm().isBlank()) {
                    jmNm = jmNm + "-" + item.getMm().trim();
                }

                // 4) API_Q 파생종목 정보 큐 INSERT
                ja032ePutMapper.insertApiQ(corpGr, optJmCd, jmNm, yjCd, hangsaGa);

                createdCount++;
            }
        }

        result.put("success", true);
        result.put("createdCount", createdCount);
        result.put("message", "PUT 배분생성을 완료했습니다. (총 " + createdCount + "건 생성)");
        return result;
    }

    /**
     * 6. 변동성재계산 오라클 프로시저 호출 (SR_JA032A)
     */
    @Transactional
    public Map<String, Object> recalculateVolatility(String corpGr, String ymd) {
        Map<String, Object> result = new HashMap<>();
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            result.put("success", false);
            result.put("message", "회사그룹 또는 기준일자가 누락되었습니다.");
            return result;
        }

        String ymdDot = ymd.trim().replace("-", ".");
        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr.trim());
        params.put("ymd", ymdDot);
        params.put("mode", "ref");
        params.put("outMsg", "");

        try {
            ja032ePutMapper.callSrJa032a(params);
            String outMsg = (String) params.get("outMsg");
            if (outMsg != null && outMsg.startsWith("Y")) {
                result.put("success", true);
                result.put("message", "변경된 조건으로 " + (outMsg.length() > 2 ? outMsg.substring(2) : "변동성 재계산") + " 완료!");
            } else {
                result.put("success", false);
                result.put("message", outMsg != null ? outMsg : "변동성 재계산 실행 중 오류가 발생했습니다.");
            }
        } catch (Exception e) {
            log.error("변동성 재계산 프로시저 오류:", e);
            result.put("success", false);
            result.put("message", "프로시저 호출 오류: " + e.getMessage());
        }
        return result;
    }
}
