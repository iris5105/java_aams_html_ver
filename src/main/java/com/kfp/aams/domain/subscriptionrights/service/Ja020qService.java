package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.dailyadvisory.dto.Uzm0hyDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020qGuganRawDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020qReportParamDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja020qMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

/**
 * W_JA020Q 수요예측 참여자료 비즈니스 로직 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja020qService {

    private final Ja020qMapper ja020qMapper;
    private final WorkDateService workDateService;

    private static final DateTimeFormatter DOT_FORMATTER = DateTimeFormatter.ofPattern("yyyy.MM.dd");
    private static final DateTimeFormatter YYYYMM_FORMATTER = DateTimeFormatter.ofPattern("yyyyMM");

    /**
     * DB 기준 영업일자 조회 (SZX0AA.HYUN_YMD)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * DB 기준 전영업일자 조회
     */
    public String getJunyongDate(String corpGr) {
        String junyong = workDateService.getJunyongDate(corpGr);
        if (junyong != null && !junyong.isBlank()) {
            return junyong;
        }
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 계좌(펀드) 목록 조회 (d_uzm0hy)
     */
    @Transactional(readOnly = true)
    public List<Uzm0hyDto> getFundList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja020qMapper.selectFundList(corpGr.trim(), ymd);
    }

    /**
     * 하단 탭별 MRD 리포트 파라미터 산출 (w_ja020q.srw ue_subpage_selected 로직 100% 반영)
     */
    @Transactional(readOnly = true)
    public Ja020qReportParamDto getReportParams(String corpGr, String fundCd, String fundNm, String gugan, LocalDate ymd, String tabId) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank() || ymd == null) {
            return null;
        }

        String safeTab = (tabId != null && !tabId.isBlank()) ? tabId : "tab1";
        String safeGugan = (gugan != null) ? gugan.trim() : "";
        LocalDate ldtF = ymd;
        LocalDate ldtT = ymd;
        String lsG = "";
        String mrdPath = "rd_ja020q.mrd";
        String tabTitle = "수요예측 참여자료";

        if ("tab1".equals(safeTab)) {
            // [탭 1] 비율보고구간
            tabTitle = "비율보고구간";
            Ja020qGuganRawDto raw = ja020qMapper.selectGuganRaw(corpGr.trim(), fundCd.trim(), ymd);
            if (raw != null) {
                LocalDate ldt1f = (raw.getS3Fymd() != null) ? raw.getS3Fymd() : ymd;
                LocalDate ldt1t = (raw.getS3Tymd() != null) ? raw.getS3Tymd() : ymd;
                LocalDate ldt2f = (raw.getG3bFymd() != null) ? raw.getG3bFymd() : ymd;
                LocalDate ldt2t = (raw.getG3bTymd() != null) ? raw.getG3bTymd() : ymd;
                LocalDate ldt3f = (raw.getB3Fymd() != null) ? raw.getB3Fymd() : ymd;
                LocalDate ldt3t = (raw.getB3Tymd() != null) ? raw.getB3Tymd() : ymd;

                int s3Ilsu = (raw.getS3Ilsu() != null) ? raw.getS3Ilsu() : 0;
                int g3bIlsu = (raw.getG3bIlsu() != null) ? raw.getG3bIlsu() : 0;
                int b3Ilsu = (raw.getB3Ilsu() != null) ? raw.getB3Ilsu() : 0;

                String lsG1 = "평균비율구간 : " + formatDot(ldt1f) + " - " + formatDot(ldt1t) + " ( " + s3Ilsu + " 일)";
                String lsG2 = "평균비율구간 : " + formatDot(ldt2f) + " - " + formatDot(ldt2t) + " ( " + g3bIlsu + " 일)";
                String lsG3 = "평균비율구간 : " + formatDot(ldt3f) + " - " + formatDot(ldt3t) + " ( " + b3Ilsu + " 일)";

                double m3Gu = (raw.getM3Gu() != null) ? raw.getM3Gu().doubleValue() : 0;
                double g3Gu = (raw.getG3Gu() != null) ? raw.getG3Gu().doubleValue() : 0;

                if ("1".equals(safeGugan)) {
                    if (m3Gu <= 2) {
                        ldtF = ymd;
                        ldtT = ymd;
                        lsG = "설정 후 3개월 미경과 구간 : " + formatDot(ymd);
                    } else if (m3Gu == 999) {
                        ldtF = ymd;
                        ldtT = ymd;
                        lsG = "만기3개월 미만 충족구간";
                    } else {
                        ldtF = ldt1f;
                        ldtT = ldt1t;
                        lsG = lsG1;
                    }
                } else if ("2".equals(safeGugan)) {
                    if (g3Gu == 1) {
                        ldtF = ymd;
                        ldtT = ymd;
                        lsG = "설정 후 분기 3개월 미경과 구간 : " + formatDot(ymd);
                    } else if (g3Gu == 999) {
                        ldtF = ldt2f;
                        ldtT = ldt2t;
                        lsG = "만기전 3개월 제외구간 : " + formatDot(ldtF) + " - " + formatDot(ldtT);
                    } else {
                        ldtF = ldt2f;
                        ldtT = ldt2t;
                        lsG = lsG2;
                    }
                } else {
                    ldtF = ldt3f;
                    ldtT = ldt3t;
                    lsG = lsG3;
                }
            } else {
                lsG = "평균비율구간 : " + formatDot(ymd) + " - " + formatDot(ymd);
            }
            mrdPath = "rd_ja020q.mrd";

        } else if ("tab2".equals(safeTab)) {
            // [탭 2] 금투협구간
            tabTitle = "금투협구간";
            Ja020qGuganRawDto raw = ja020qMapper.selectGuganRaw(corpGr.trim(), fundCd.trim(), ymd);
            if (raw != null) {
                LocalDate ldt1f = (raw.getM3Fymd() != null) ? raw.getM3Fymd() : ymd;
                LocalDate ldt1t = (raw.getM3Tymd() != null) ? raw.getM3Tymd() : ymd;
                LocalDate ldt2f = (raw.getG3bFymd() != null) ? raw.getG3bFymd() : ymd;
                LocalDate ldt2t = (raw.getG3bTymd() != null) ? raw.getG3bTymd() : ymd;
                LocalDate ldt3f = (raw.getB3Fymd() != null) ? raw.getB3Fymd() : ymd;
                LocalDate ldt3t = (raw.getB3Tymd() != null) ? raw.getB3Tymd() : ymd;

                int m3Ilsu = (raw.getM3Ilsu() != null) ? raw.getM3Ilsu() : 0;
                int g3bIlsu = (raw.getG3bIlsu() != null) ? raw.getG3bIlsu() : 0;
                int b3Ilsu = (raw.getB3Ilsu() != null) ? raw.getB3Ilsu() : 0;

                String lsG1 = "평균비율구간 : " + formatDot(ldt1f) + " - " + formatDot(ldt1t) + " ( " + m3Ilsu + " 일)";
                String lsG2 = "평균비율구간 : " + formatDot(ldt2f) + " - " + formatDot(ldt2t) + " ( " + g3bIlsu + " 일)";
                String lsG3 = "평균비율구간 : " + formatDot(ldt3f) + " - " + formatDot(ldt3t) + " ( " + b3Ilsu + " 일)";

                double m3Gu = (raw.getM3Gu() != null) ? raw.getM3Gu().doubleValue() : 0;
                double g3Gu = (raw.getG3Gu() != null) ? raw.getG3Gu().doubleValue() : 0;

                if ("1".equals(safeGugan)) {
                    if (m3Gu <= 2) {
                        ldtF = ymd;
                        ldtT = ymd;
                        lsG = "설정 후 3개월 미경과 구간 : " + formatDot(ymd);
                    } else {
                        ldtF = ldt1f;
                        ldtT = ldt1t;
                        lsG = lsG1;
                    }
                } else if ("2".equals(safeGugan)) {
                    if (g3Gu == 1) {
                        ldtF = ymd;
                        ldtT = ymd;
                        lsG = "설정 후 분기 3개월 미경과 구간 : " + formatDot(ymd);
                    } else if (g3Gu == 999) {
                        ldtF = ldt3f;
                        ldtT = ldt3t;
                        lsG = lsG3;
                    } else {
                        ldtF = ldt3f;
                        ldtT = ldt3t;
                        lsG = lsG3;
                    }
                } else {
                    ldtF = ldt3f;
                    ldtT = ldt3t;
                    lsG = lsG3;
                }
            } else {
                lsG = "평균비율구간 : " + formatDot(ymd) + " - " + formatDot(ymd);
            }

            // 202506 이상인 경우 rd_ja020q_202506.mrd 분기
            String yyyymm = (ldtT != null) ? ldtT.format(YYYYMM_FORMATTER) : "";
            if (yyyymm.compareTo("202506") >= 0) {
                mrdPath = "rd_ja020q_202506.mrd";
            } else {
                mrdPath = "rd_ja020q.mrd";
            }

        } else if ("tab3".equals(safeTab)) {
            // [탭 3] 주금납입능력(3개월)
            tabTitle = "주금납입능력(3개월)";
            ldtF = ymd.minusMonths(3).plusDays(1);
            ldtT = ymd;
            lsG = "3개월구간 : " + formatDot(ldtF) + " - " + formatDot(ldtT);
            mrdPath = "rd_ja020q.mrd";

        } else if ("tab4".equals(safeTab)) {
            // [탭 4] 전구간
            tabTitle = "전구간";
            LocalDate fstSeolj = ja020qMapper.selectFstSeoljYmd(corpGr.trim(), fundCd.trim());
            ldtF = (fstSeolj != null) ? fstSeolj : ymd;
            ldtT = ymd;
            lsG = "전구간 : " + formatDot(ldtF) + " - " + formatDot(ldtT);
            mrdPath = "rd_ja020q.mrd";
        }

        String displayName = (fundNm != null && !fundNm.isBlank()) ? fundNm : fundCd;
        String statusText = String.format("구간: %s | %s ~ %s", lsG, formatDot(ldtF), formatDot(ldtT));

        return Ja020qReportParamDto.builder()
                .mrdPath(mrdPath)
                .fundCd(fundCd)
                .fundNm(fundNm)
                .gugan(lsG)
                .fymd(formatDot(ldtF))
                .tymd(formatDot(ldtT))
                .reportTitle(displayName + " (" + fundCd + ") " + tabTitle)
                .statusText(statusText)
                .build();
    }

    private String formatDot(LocalDate date) {
        return (date != null) ? date.format(DOT_FORMATTER) : "";
    }
}
