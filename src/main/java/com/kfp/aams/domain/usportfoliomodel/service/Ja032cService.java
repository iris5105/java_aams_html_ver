package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cBetaDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cGreeksDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cPortDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cUpDownDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032cVolatilityDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032cMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

/**
 * USPM 포트폴리오 모델 변동성분석 (W_JA032C) 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja032cService {

    private final Ja032cMapper ja032cMapper;
    private final WorkDateService workDateService;

    /**
     * 작업기준일 조회 (Zero-Hardcoding 원칙: WorkDateService 연동)
     */
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 1. 펀드/포트 목록 조회 (d_ja032c1.srd)
     */
    public List<Ja032cPortDto> getPortList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032cMapper.selectPortList(corpGr, ymd);
    }

    /**
     * 2. 포트 내 종목 상세 현황 (d_ja032c2.srd / d_ja032c2_krx.srd)
     */
    public List<Ja032cDetailDto> getDetailList(String corpGr, String ymd, String fundCd, String portNum, String tt) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()
                || fundCd == null || fundCd.isBlank() || portNum == null || portNum.isBlank()) {
            return Collections.emptyList();
        }

        if ("A".equalsIgnoreCase(tt)) {
            // 국내 주식
            return ja032cMapper.selectDetailListDomestic(corpGr, ymd, fundCd, portNum);
        } else {
            // 해외 주식
            return ja032cMapper.selectDetailListForeign(corpGr, ymd, fundCd, portNum);
        }
    }

    /**
     * 3. 변동수준 / 괴리율 분석 조회 (d_ja032c3.srd)
     */
    public List<Ja032cVolatilityDto> getVolatilityList(String corpGr, String jmCd, String fymd, String tymd, String type) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()
                || fymd == null || fymd.isBlank() || tymd == null || tymd.isBlank()) {
            return Collections.emptyList();
        }
        String searchType = (type != null && !type.isBlank()) ? type.trim() : "변동수준";
        return ja032cMapper.selectVolatilityList(corpGr, jmCd, fymd, tymd, searchType);
    }

    /**
     * 4. 베타 분석 조회 (d_ja032c3_beta.srd / d_ja032c3_beta_krx.srd)
     */
    public List<Ja032cBetaDto> getBetaList(String corpGr, String tt, String jmCd, String fymd, String tymd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()
                || fymd == null || fymd.isBlank() || tymd == null || tymd.isBlank()) {
            return Collections.emptyList();
        }

        if ("A".equalsIgnoreCase(tt)) {
            return ja032cMapper.selectBetaDomestic(corpGr, "kospi_jisu", jmCd, fymd, tymd);
        } else {
            return ja032cMapper.selectBetaForeign(corpGr, "S&P500", jmCd, fymd, tymd);
        }
    }

    /**
     * 5. 상승/하락일수 분석 조회 (d_ja032c3_ud.srd / d_ja032c3_ud_krx.srd)
     */
    public List<Ja032cUpDownDto> getUpDownList(String corpGr, String tt, String jmCd, String fymd, String tymd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()
                || fymd == null || fymd.isBlank() || tymd == null || tymd.isBlank()) {
            return Collections.emptyList();
        }

        if ("A".equalsIgnoreCase(tt)) {
            return ja032cMapper.selectUpDownDomestic(corpGr, jmCd, fymd, tymd);
        } else {
            return ja032cMapper.selectUpDownForeign(corpGr, jmCd, fymd, tymd);
        }
    }

    /**
     * 6. 델타/감마/세타/베가/로 (Option Greeks) 분석 조회 및 근접 옵션 자동 산출
     * (w_ja032c.srw 원본 로직 100% 충실 반영)
     */
    public Ja032cGreeksDto getOptionGreeks(String corpGr, String ymd, String fundCd, String portNum,
                                          String jmCd, String srsCd, String mangi) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()
                || fundCd == null || fundCd.isBlank() || portNum == null || portNum.isBlank()
                || jmCd == null || jmCd.isBlank()) {
            return null;
        }

        List<Ja032cGreeksDto> list = ja032cMapper.selectGreeks(corpGr, ymd, fundCd, portNum, jmCd);
        if (list == null || list.isEmpty()) {
            return null;
        }

        Ja032cGreeksDto dto = list.get(0);

        // 옵션 탐색 및 내재변동성/그릭스 계산
        try {
            if (srsCd != null && !srsCd.isBlank() && mangi != null && !mangi.isBlank() && dto.getK() != null) {
                String putJmCd = ja032cMapper.selectClosestPutOptionJmCd(mangi, srsCd, dto.getK());
                if (putJmCd != null && !putJmCd.isBlank()) {
                    dto.setPutJmCd(putJmCd);

                    BigDecimal optionJonga = ja032cMapper.selectOptionJonga(corpGr, ymd, putJmCd);
                    if (optionJonga != null) {
                        dto.setMarketPrice(optionJonga);

                        BigDecimal impVol = ja032cMapper.selectImpVolatility(dto.getS(), dto.getK(), dto.getT(), dto.getR(), optionJonga);
                        if (impVol != null && impVol.compareTo(BigDecimal.ZERO) > 0) {
                            dto.setImpVolatility(impVol);

                            // Greeks 재계산
                            Ja032cGreeksDto com = ja032cMapper.selectGreeksCom(dto.getS(), dto.getT(), dto.getK(), dto.getR(), impVol);
                            if (com != null) {
                                dto.setCallDelta(com.getCallDelta());
                                dto.setPutDelta(com.getPutDelta());
                                dto.setGamma(com.getGamma());
                                dto.setVega(com.getVega());
                                dto.setCallTheta(com.getCallTheta());
                                dto.setPutTheta(com.getPutTheta());
                                dto.setCallRho(com.getCallRho());
                                dto.setPutRho(com.getPutRho());
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            log.warn("W_JA032C option greeks auto calculation notice: {}", e.getMessage());
        }

        return dto;
    }

    /**
     * 7. 사용자가 입력값(행사가, 시장가, 무위험이자율, 내재변동성) 변경 시 동적 실시간 재계산
     */
    public Ja032cGreeksDto recalcGreeks(BigDecimal s, BigDecimal t, BigDecimal k, BigDecimal r,
                                        BigDecimal marketPrice, BigDecimal impVolatility, boolean isPriceChanged) {
        Ja032cGreeksDto result = new Ja032cGreeksDto();
        result.setS(s);
        result.setT(t);
        result.setK(k);
        result.setR(r);
        result.setMarketPrice(marketPrice);

        BigDecimal sigmaToUse = impVolatility;

        if (isPriceChanged && marketPrice != null && marketPrice.compareTo(BigDecimal.ZERO) > 0) {
            try {
                BigDecimal calculatedImpVol = ja032cMapper.selectImpVolatility(s, k, t, r, marketPrice);
                if (calculatedImpVol != null && calculatedImpVol.compareTo(BigDecimal.ZERO) > 0) {
                    sigmaToUse = calculatedImpVol;
                }
            } catch (Exception e) {
                log.warn("selectImpVolatility error: {}", e.getMessage());
            }
        }

        result.setImpVolatility(sigmaToUse);

        if (sigmaToUse != null && sigmaToUse.compareTo(BigDecimal.ZERO) > 0) {
            try {
                Ja032cGreeksDto com = ja032cMapper.selectGreeksCom(s, t, k, r, sigmaToUse);
                if (com != null) {
                    result.setCallDelta(com.getCallDelta());
                    result.setPutDelta(com.getPutDelta());
                    result.setGamma(com.getGamma());
                    result.setVega(com.getVega());
                    result.setCallTheta(com.getCallTheta());
                    result.setPutTheta(com.getPutTheta());
                    result.setCallRho(com.getCallRho());
                    result.setPutRho(com.getPutRho());
                }
            } catch (Exception e) {
                log.warn("selectGreeksCom error: {}", e.getMessage());
            }
        }

        return result;
    }
}
