package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010hMasterDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010hMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja010h (Asset Statement / 자산명세표)
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010hService {

    private final Ja010hMapper ja010hMapper;
    private final RdReportService rdReportService;
    private final com.kfp.aams.common.service.WorkDateService workDateService;

    /**
     * 펀드 목록 조회 (d_szm0ia.srd)
     */
    public List<Ja010hMasterDto> getFundList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja010hMapper.selectFundList(corpGr, ymd);
    }

    /**
     * 캘린더 데이터 존재 일자 조회
     */
    public List<String> getDates(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja010hMapper.selectDistinctDates(corpGr);
    }

    /**
     * 평잔 재계산
     */
    @Transactional
    public void executePyungjan(String corpGr, String fundCd, String ymd) {
        ja010hMapper.callSrPyungjan(corpGr, fundCd, ymd);
    }

    /**
     * 자산명세표 리포트 내보내기 (PDF, Excel, Word, PPT, HWP)
     * 파워빌더 ole_rd::ue_retrieve 비즈니스 로직 적용:
     * SJM0JM 테이블에서 담보 건수(coll_pass, coll_up, coll_dw)를 확인하여
     * coll > 0 이면 rd_ja010h_coll.mrd, 아니면 rd_ja010h.mrd 리포트 실행
     */
    public RdReportService.ExportResult exportReport(String corpGr, String ymd, String fundCd, String format) throws Exception {
        int collCount = ja010hMapper.checkCollCount(corpGr, ymd, fundCd);
        boolean isColl = collCount > 0;
        log.info("자산명세표 리포트 분기 판정 - corpGr: {}, ymd: {}, fundCd: {}, collCount: {}, isColl: {}",
                corpGr, ymd, fundCd, collCount, isColl);

        // 펀드 정보 조회 (bfYmd, fundNm 등)
        Ja010hMasterDto fundInfo = ja010hMapper.selectFundInfo(corpGr, ymd, fundCd);
        String bfYmd = (fundInfo != null && fundInfo.getBfYmd() != null) ? fundInfo.getBfYmd() : "";
        String fundNm = (fundInfo != null && fundInfo.getFundNm() != null) ? fundInfo.getFundNm() : "자산명세표";

        return rdReportService.generateJa010hReport(isColl, corpGr, ymd, bfYmd, fundCd, fundNm, format);
    }

    /**
     * PDF 미리보기 스트림 생성
     */
    public RdReportService.ExportResult previewReport(String corpGr, String ymd, String fundCd) throws Exception {
        return exportReport(corpGr, ymd, fundCd, "pdf");
    }

    /**
     * 회사그룹별 기준일자 조회 (공통 WorkDateService 위임)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDate(corpGr);
    }

    /**
     * 2402 회사 전용일자 조회 (SZX0AA.JUNYONG_YMD)
     */
    public String getJunyongYmd(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return null;
        }
        return ja010hMapper.selectJunyongYmd(corpGr.trim());
    }

    /**
     * 파워빌더 w_ja010h1.srw wue_lastopen 명세:
     * IF gaa.corp_gr='2402' Then
     *     SELECT JUNYONG_YMD INTO :ldt FROM SZX0AA aa WHERE aa.corp_gr = :gaa.corp_gr;
     *     dw_c.object.ymd [1] = SQLCA.getitemdatetime (1)
     * Else
     *     dw_c.object.ymd [1] = idt_workdate (엑세스 쿠키 / 현재 영업일)
     * End IF
     */
    public String getInitialWorkDate(String corpGr, String cookieWorkDate) {
        if ("2402".equals(corpGr)) {
            String junyongYmd = getJunyongYmd("2402");
            if (junyongYmd != null && !junyongYmd.isBlank()) {
                return normalizeYmd(junyongYmd);
            }
        }
        // 그 외의 경우: 엑세스 쿠키에 있는 현재 영업일 사용
        if (cookieWorkDate != null && !cookieWorkDate.isBlank()) {
            return normalizeYmd(cookieWorkDate);
        }
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    private String normalizeYmd(String ymd) {
        if (ymd == null || ymd.isBlank()) return ymd;
        String clean = ymd.replaceAll("[^0-9]", "");
        if (clean.length() == 8) {
            return clean.substring(0, 4) + "-" + clean.substring(4, 6) + "-" + clean.substring(6, 8);
        }
        return ymd;
    }

    /**
     * 2402 회사 원장생성 검증 (w_ja010h1.srw ole_rd::ue_retrieve)
     * 불일치 발생 시 작업자 및 작업시간을 담은 경고 메시지 반환, 정상일 경우 null 반환
     */
    public String checkLedgerValidation(String corpGr, String ymd) {
        if (!"2402".equals(corpGr) || ymd == null || ymd.isBlank()) {
            return null;
        }
        String cleanYmd = ymd.replace("-", "").replace(".", "");
        if (cleanYmd.compareTo("20241230") <= 0) {
            return null;
        }

        Integer diffCount = ja010hMapper.checkLedgerDiffCount(corpGr, ymd);
        if (diffCount != null && diffCount > 0) {
            java.util.Map<String, Object> worker = ja010hMapper.selectLastLedgerWorker(corpGr, ymd);
            String userNm = (worker != null && worker.get("USER_NM") != null) ? String.valueOf(worker.get("USER_NM")) : "담당자";
            String runDt = (worker != null && worker.get("RUN_DT") != null) ? String.valueOf(worker.get("RUN_DT")) : "";
            return "최종작업자 " + userNm + "(이)가 원장생성을 " + runDt + "에 작업했습니다.\n최종 LOAD자료 반영을 위해 원장생성 작업을 다시 하십시오.";
        }
        return null;
    }

    /**
     * 보유자산 종합 엑셀 리포트 생성 (w_ja010h1.srw cb_1)
     */
    public RdReportService.ExportResult exportTotalExcel(String corpGr, String ymd) throws Exception {
        String sunJasan = ja010hMapper.selectSunJasanSigaAek(corpGr, ymd);
        return rdReportService.generateJa010hTotalReport(corpGr, ymd, sunJasan, "excel");
    }
}
