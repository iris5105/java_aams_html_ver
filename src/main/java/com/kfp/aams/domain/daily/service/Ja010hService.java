package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010hMasterDto;
import com.kfp.aams.domain.daily.mapper.Ja010hMapper;
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
}
