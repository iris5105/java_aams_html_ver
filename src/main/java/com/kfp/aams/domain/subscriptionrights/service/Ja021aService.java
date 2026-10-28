package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021aDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021aMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021aSaveDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja021aMapper;
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
public class Ja021aService {

    private final Ja021aMapper ja021aMapper;
    private final WorkDateService workDateService;

    /**
     * 작업일자 조회 (SZX0AA.HYUN_YMD)
     */
    @Transactional(readOnly = true)
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 마스터 목록 조회 (d_ja021a1)
     */
    @Transactional(readOnly = true)
    public List<Ja021aMasterDto> getMasterList(String corpGr, String ymd, String trCd) {
        if (ymd == null || ymd.isBlank() || trCd == null || trCd.isBlank()) {
            return Collections.emptyList();
        }
        String workDate = getWorkDate(corpGr);
        String queryCorpGr = (corpGr != null && !corpGr.isBlank() && !"%".equals(corpGr.trim())) ? corpGr.trim() : null;
        return ja021aMapper.selectMasterList(queryCorpGr, ymd, trCd, workDate);
    }

    /**
     * 디테일 목록 조회 (d_ja021a2)
     */
    @Transactional(readOnly = true)
    public List<Ja021aDetailDto> getDetailList(String corpGr, String ymd, String trCd, String balhCo) {
        if (ymd == null || ymd.isBlank() || trCd == null || trCd.isBlank() || balhCo == null || balhCo.isBlank()) {
            return Collections.emptyList();
        }
        String workDate = getWorkDate(corpGr);
        String queryCorpGr = (corpGr != null && !corpGr.isBlank() && !"%".equals(corpGr.trim())) ? corpGr.trim() : null;
        return ja021aMapper.selectDetailList(queryCorpGr, ymd, trCd, balhCo, workDate);
    }

    /**
     * 발행기관 액면가 조회
     */
    @Transactional(readOnly = true)
    public BigDecimal getBalhAekm(String balhCo) {
        if (balhCo == null || balhCo.isBlank()) {
            return BigDecimal.ZERO;
        }
        BigDecimal aekm = ja021aMapper.selectBalhAekm(balhCo);
        return aekm != null ? aekm : BigDecimal.ZERO;
    }

    /**
     * 우선주 구분 조회 (3 or 1)
     */
    @Transactional(readOnly = true)
    public String getWoosStockMethod(String balhCo) {
        if (balhCo == null || balhCo.isBlank()) {
            return "1";
        }
        String result = ja021aMapper.selectWoosStockMethod(balhCo);
        return (result != null && !result.isBlank()) ? result : "1";
    }

    /**
     * 일괄 CUD 저장
     */
    @Transactional
    public void save(Ja021aSaveDto saveDto) {
        if (saveDto == null) return;

        String corpGr = saveDto.getCorpGr();
        String ymd = saveDto.getYmd();
        String trCd = saveDto.getTrCd();

        // 1. 마스터 저장 처리
        if (saveDto.getMasterList() != null) {
            for (Ja021aMasterDto m : saveDto.getMasterList()) {
                if (m.getCorpGr() == null || m.getCorpGr().isBlank()) m.setCorpGr(corpGr);
                if (m.getTrYmd() == null || m.getTrYmd().isBlank()) m.setTrYmd(ymd);
                if (m.getTrCd() == null || m.getTrCd().isBlank()) m.setTrCd(trCd);

                if (Boolean.TRUE.equals(m.getIsDeleted()) || "D".equalsIgnoreCase(m.getRowStatus())) {
                    ja021aMapper.deleteDetailsByMaster(m);
                    ja021aMapper.deleteMaster(m);
                } else if (Boolean.TRUE.equals(m.getIsNew()) || "C".equalsIgnoreCase(m.getRowStatus())) {
                    ja021aMapper.insertMaster(m);
                } else if (Boolean.TRUE.equals(m.getIsUpdated()) || "U".equalsIgnoreCase(m.getRowStatus())) {
                    ja021aMapper.updateMaster(m);
                }
            }
        }

        // 2. 디테일 저장 처리
        if (saveDto.getDetailList() != null) {
            for (Ja021aDetailDto d : saveDto.getDetailList()) {
                if (d.getCorpGr() == null || d.getCorpGr().isBlank()) d.setCorpGr(corpGr);
                if (d.getTrYmd() == null || d.getTrYmd().isBlank()) d.setTrYmd(ymd);
                if (d.getTrCd() == null || d.getTrCd().isBlank()) d.setTrCd(trCd);

                if (Boolean.TRUE.equals(d.getIsDeleted()) || "D".equalsIgnoreCase(d.getRowStatus())) {
                    ja021aMapper.deleteDetail(d);
                } else if (Boolean.TRUE.equals(d.getIsNew()) || "C".equalsIgnoreCase(d.getRowStatus())) {
                    ja021aMapper.insertDetail(d);
                } else if (Boolean.TRUE.equals(d.getIsUpdated()) || "U".equalsIgnoreCase(d.getRowStatus())) {
                    ja021aMapper.updateDetail(d);
                }
            }
        }
    }

    /**
     * 운용사명 조회 (SZX0AA.COMPANY_NAME)
     */
    @Transactional(readOnly = true)
    public String getCompanyName(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return "";
        }
        String name = ja021aMapper.selectCompanyName(corpGr.trim());
        return name != null ? name.trim() : "";
    }
}
