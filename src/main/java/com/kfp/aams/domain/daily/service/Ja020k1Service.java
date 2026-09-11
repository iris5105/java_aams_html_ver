package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.GuganDto;
import com.kfp.aams.domain.daily.dto.Uzm0hyDto;
import com.kfp.aams.domain.daily.mapper.Uzm0hyMapper;
import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja020k1Service {

    private final Uzm0hyMapper uzm0hyMapper;
    private final RdReportService rdReportService;

    public List<Uzm0hyDto> selectUzm0hyList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return uzm0hyMapper.selectUzm0hyList(corpGr, ymd);
    }

    @Data
    @Builder
    public static class GuganReportParam {
        private String mrdName;
        private String guganText;
        private String fymd;
        private String tymd;
    }

    public GuganReportParam calculateGuganParam(String corpGr, String fundCd, String ymd, String gugan) {
        GuganDto gu = uzm0hyMapper.selectGugan(corpGr, fundCd, ymd);

        String mrdName;
        String guganText;
        String fymd;
        String tymd;

        String ymdDot = (ymd != null) ? ymd.replace("-", ".") : "";

        if ("1".equals(gugan)) {
            mrdName = "rd_ja020k1w.mrd";
            BigDecimal m3Gu = (gu != null && gu.getM3Gu() != null) ? gu.getM3Gu() : BigDecimal.ZERO;
            if (m3Gu.compareTo(new BigDecimal("2")) <= 0) {
                fymd = ymd;
                tymd = ymd;
                guganText = "설정 후 3개월 미경과 구간 : " + ymdDot;
            } else if (m3Gu.compareTo(new BigDecimal("999")) == 0) {
                fymd = ymd;
                tymd = ymd;
                guganText = "만기3개월 미만 충족구간";
            } else {
                fymd = (gu != null) ? gu.getM3Fymd() : ymd;
                tymd = (gu != null) ? gu.getM3Tymd() : ymd;
                guganText = (gu != null) ? gu.getG1Text() : "";
            }
        } else if ("2".equals(gugan)) {
            mrdName = "rd_ja020k2w.mrd";
            BigDecimal g3Gu = (gu != null && gu.getG3Gu() != null) ? gu.getG3Gu() : BigDecimal.ZERO;
            if (g3Gu.compareTo(BigDecimal.ONE) == 0) {
                fymd = ymd;
                tymd = ymd;
                guganText = "설정 후 분기 3개월 미경과 구간 : " + ymdDot;
            } else if (g3Gu.compareTo(new BigDecimal("999")) == 0) {
                fymd = (gu != null) ? gu.getG3bFymd() : ymd;
                tymd = (gu != null) ? gu.getG3bTymd() : ymd;
                guganText = "만기전 3개월 제외구간 : " + fymd + " - " + tymd;
            } else {
                fymd = (gu != null) ? gu.getG3bFymd() : ymd;
                tymd = (gu != null) ? gu.getG3bTymd() : ymd;
                guganText = (gu != null) ? gu.getG2Text() : "";
            }
        } else {
            mrdName = "rd_ja020k3w.mrd";
            fymd = (gu != null) ? gu.getB3Fymd() : ymd;
            tymd = (gu != null) ? gu.getB3Tymd() : ymd;
            guganText = (gu != null) ? gu.getG3Text() : "";
        }

        return GuganReportParam.builder()
                .mrdName(mrdName)
                .guganText(guganText)
                .fymd(fymd)
                .tymd(tymd)
                .build();
    }

    public RdReportService.ExportResult generateReport(String corpGr, String fundCd, String fundNm,
                                                      String ymd, String gugan, String format) throws Exception {
        GuganReportParam param = calculateGuganParam(corpGr, fundCd, ymd, gugan);
        return rdReportService.generateJa020k1Report(
                param.getMrdName(), fundCd, fundNm, param.getGuganText(), param.getFymd(), param.getTymd(), format);
    }
}
