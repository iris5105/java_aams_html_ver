package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aPortDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aSaveRequestDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032aMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032aService {

    private final Ja032aMapper ja032aMapper;
    private final com.kfp.aams.domain.usportfoliomodel.repository.Ja032aJpaRepository ja032aJpaRepository;
    private final WorkDateService workDateService;

    /**
     * 회사그룹별 기준 작업일자 조회
     */
    @Transactional(readOnly = true)
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 마스터 펀드 목록 조회 (d_ja032a1 - SZT0IA_V + SZM0IA 복합 조인 via MyBatis)
     */
    @Transactional(readOnly = true)
    public List<Ja032aMasterDto> getMasterList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja032aMapper.selectMasterList(corpGr.trim(), ymd);
    }

    /**
     * 포트 목록 조회 (d_ja032a2 - USPM_PORT + 오라클 함수 via MyBatis)
     */
    @Transactional(readOnly = true)
    public List<Ja032aPortDto> getPortList(String corpGr, String fundCd, LocalDate trYmd, BigDecimal fundJmPer) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank() || trYmd == null) {
            return Collections.emptyList();
        }
        return ja032aMapper.selectPortList(corpGr.trim(), fundCd.trim(), trYmd, fundJmPer != null ? fundJmPer : BigDecimal.ZERO);
    }

    /**
     * 종목 상세 목록 조회 (d_ja032a3 / d_ja032a3a - USPM + SYM0YA + SJM0JJ + USPM_OPT 복합 조인 via MyBatis)
     */
    @Transactional(readOnly = true)
    public List<Ja032aDetailDto> getDetailList(String corpGr, LocalDate ymd, String fundCd, String portNum) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank() || portNum == null || portNum.isBlank()) {
            return Collections.emptyList();
        }
        return ja032aMapper.selectDetailList(corpGr.trim(), ymd, fundCd.trim(), portNum.trim());
    }

    /**
     * 환율 조회 (SYX1HY)
     */
    @Transactional(readOnly = true)
    public BigDecimal getUsdExchangeRate(String corpGr, LocalDate trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal rate = ja032aMapper.selectUsdExchangeRate(corpGr.trim(), trYmd);
        return rate != null ? rate : BigDecimal.ZERO;
    }

    /**
     * 잔존일수 계산
     */
    public Long calculateDays(LocalDate fromDate, LocalDate toDate) {
        if (fromDate == null || toDate == null) {
            return 0L;
        }
        return ChronoUnit.DAYS.between(fromDate, toDate);
    }

    /**
     * 일괄 CUD 저장 (마스터: MyBatis, 포트/종목 상세: JPA EntityManager CUD)
     */
    @Transactional
    public Map<String, Object> saveAll(Ja032aSaveRequestDto req) {
        Map<String, Object> result = new HashMap<>();
        if (req == null || req.getCorpGr() == null || req.getCorpGr().isBlank()) {
            result.put("success", false);
            result.put("message", "회사그룹 정보가 누락되었습니다.");
            return result;
        }

        String corpGr = req.getCorpGr().trim();

        // 1. 마스터 업데이트 (SZT0IA_V 뷰 테이블)
        if (req.getMasterList() != null) {
            for (Ja032aMasterDto master : req.getMasterList()) {
                if (Boolean.TRUE.equals(master.getIsUpdated())) {
                    master.setCorpGr(corpGr);
                    ja032aMapper.updateMaster(master);
                }
            }
        }

        // 2. 포트 목록 저장 (USPM_PORT 단일 테이블 CUD -> JPA EntityManager)
        if (req.getPortList() != null) {
            for (Ja032aPortDto port : req.getPortList()) {
                port.setCorpGr(corpGr);
                if (Boolean.TRUE.equals(port.getIsDeleted())) {
                    // 포트 삭제 시 해당 포트의 종목 상세도 함께 삭제
                    if (port.getTymd() != null && port.getFundCd() != null && port.getPortNum() != null) {
                        LocalDate tymd = LocalDate.parse(port.getTymd().replace(".", "-"));
                        ja032aJpaRepository.deleteDetailByPort(corpGr, tymd, port.getFundCd().trim(), port.getPortNum().trim());
                    }
                    ja032aJpaRepository.deletePort(port);
                } else if (Boolean.TRUE.equals(port.getIsNew())) {
                    ja032aJpaRepository.insertPort(port);
                } else if (Boolean.TRUE.equals(port.getIsUpdated())) {
                    ja032aJpaRepository.updatePort(port);
                }
            }
        }

        // 3. 종목 상세 목록 저장 (USPM 단일 테이블 CUD -> JPA EntityManager)
        if (req.getDetailList() != null) {
            for (Ja032aDetailDto detail : req.getDetailList()) {
                detail.setCorpGr(corpGr);
                if (Boolean.TRUE.equals(detail.getIsDeleted())) {
                    ja032aJpaRepository.deleteDetail(detail);
                } else if (Boolean.TRUE.equals(detail.getIsNew())) {
                    ja032aJpaRepository.insertDetail(detail);
                } else if (Boolean.TRUE.equals(detail.getIsUpdated())) {
                    ja032aJpaRepository.updateDetail(detail);
                }
            }
        }

        result.put("success", true);
        result.put("message", "정상적으로 저장되었습니다.");
        return result;
    }

    /**
     * 마스터 펀드 및 관련 데이터 일괄 삭제
     */
    @Transactional
    public Map<String, Object> deleteMaster(String corpGr, LocalDate ymd, String fundCd) {
        Map<String, Object> result = new HashMap<>();
        if (corpGr == null || corpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank()) {
            result.put("success", false);
            result.put("message", "삭제 필수 파라미터가 누락되었습니다.");
            return result;
        }

        String safeCorpGr = corpGr.trim();
        String safeFundCd = fundCd.trim();

        // USPM 상세 삭제 (JPA QueryDSL)
        ja032aJpaRepository.deleteDetailAll(safeCorpGr, ymd, safeFundCd);
        // USPM_PORT 포트 삭제 (JPA QueryDSL)
        ja032aJpaRepository.deletePortAll(safeCorpGr, ymd, safeFundCd);
        // SZT0IA_V DEL='Y' 플래그 업데이트 (MyBatis)
        ja032aMapper.deleteMasterFlag(safeCorpGr, ymd, safeFundCd);

        result.put("success", true);
        result.put("message", "선택된 펀드 및 포트/종목 정보가 삭제되었습니다.");
        return result;
    }

    /**
     * 변동성재계산 프로시저 호출 (SR_JA032A)
     */
    @Transactional
    public Map<String, Object> recalculateVolatility(String corpGr, String ymd) {
        Map<String, Object> result = new HashMap<>();
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            result.put("success", false);
            result.put("message", "회사그룹 또는 기준일자가 누락되었습니다.");
            return result;
        }

        // ymd 형식 정규화 (YYYY.MM.DD)
        String formattedYmd = ymd.trim().replace("-", ".");

        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr.trim());
        params.put("ymd", formattedYmd);
        params.put("pMsg", "ref");

        try {
            ja032aMapper.callSrJa032a(params);
            String pMsg = (String) params.get("pMsg");
            if (pMsg != null && pMsg.startsWith("Y")) {
                result.put("success", true);
                String msgDetail = pMsg.length() > 2 ? pMsg.substring(2) : "변동성 재계산";
                result.put("message", "변경된 조건으로 " + msgDetail + " 완료!!!");
            } else {
                result.put("success", false);
                result.put("message", pMsg != null ? pMsg : "변동성 재계산 실행 중 오류가 발생하였습니다.");
            }
        } catch (Exception e) {
            log.error("SR_JA032A 실행 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "변동성 재계산 실행 중 예외가 발생하였습니다: " + e.getMessage());
        }

        return result;
    }
}
