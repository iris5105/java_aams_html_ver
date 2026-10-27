package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021cDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021cMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021cSaveDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja021cMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja021cService {

    private final Ja021cMapper ja021cMapper;
    private final WorkDateService workDateService;

    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 탭 1: 중간배당 마스터 목록
     */
    public List<Ja021cMasterDto> getT1MasterList(String corpGr, String workDate) {
        return ja021cMapper.selectT1MasterList(corpGr, workDate);
    }

    /**
     * 탭 1: 펀드별 배당권리 상세
     */
    public List<Ja021cDetailDto> getT1DetailList(String corpGr, String ymd, String balhCo) {
        return ja021cMapper.selectT1DetailList(corpGr, ymd, balhCo);
    }

    /**
     * 탭 2: 현금중간배당확정 마스터 목록
     */
    public List<Ja021cMasterDto> getT2MasterList(String corpGr, String workDate) {
        return ja021cMapper.selectT2MasterList(corpGr, workDate);
    }

    /**
     * 탭 2: 펀드별 배당권리 상세
     */
    public List<Ja021cDetailDto> getT2DetailList(String corpGr, String ymd, String balhCo) {
        return ja021cMapper.selectT2DetailList(corpGr, ymd, balhCo);
    }

    /**
     * 탭 3: 주식중간배당확정 마스터 목록
     */
    public List<Ja021cMasterDto> getT3MasterList(String corpGr, String workDate) {
        return ja021cMapper.selectT3MasterList(corpGr, workDate);
    }

    /**
     * 탭 3: 펀드별 배당권리 상세
     */
    public List<Ja021cDetailDto> getT3DetailList(String corpGr, String ymd, String brokYmd, String balhCo) {
        return ja021cMapper.selectT3DetailList(corpGr, ymd, brokYmd, balhCo);
    }

    /**
     * 액면가 조회
     */
    public BigDecimal getBalhAekm(String balhCo) {
        return ja021cMapper.selectBalhAekm(balhCo);
    }

    /**
     * 배정방법 기본값 조회
     */
    public String getBaejMthDefault(String balhCo) {
        return ja021cMapper.selectBaejMthDefault(balhCo);
    }

    /**
     * 마스터 일괄 저장
     */
    @Transactional
    public void save(Ja021cSaveDto saveDto) {
        if (saveDto == null || saveDto.getMasterList() == null || saveDto.getMasterList().isEmpty()) {
            return;
        }

        String tabId = saveDto.getTabId();
        String targetTrCd = "t1".equalsIgnoreCase(tabId) ? "G15" : "G23";

        for (Ja021cMasterDto m : saveDto.getMasterList()) {
            if (m.getTrCd() == null || m.getTrCd().isBlank()) {
                m.setTrCd(targetTrCd);
            }

            // 배당율(%)을 소수점 비율(rt)로 동기화
            if (m.getCashIlbanPer() != null) {
                m.setCashIlbanRt(m.getCashIlbanPer().divide(BigDecimal.valueOf(100), 10, java.math.RoundingMode.HALF_UP));
            }
            if (m.getCashWoosPer() != null) {
                m.setCashWoosRt(m.getCashWoosPer().divide(BigDecimal.valueOf(100), 10, java.math.RoundingMode.HALF_UP));
            }
            if (m.getStockIlbanPer() != null) {
                m.setStockIlbanRt(m.getStockIlbanPer().divide(BigDecimal.valueOf(100), 10, java.math.RoundingMode.HALF_UP));
            }
            if (m.getStockWoosPer() != null) {
                m.setStockWoosRt(m.getStockWoosPer().divide(BigDecimal.valueOf(100), 10, java.math.RoundingMode.HALF_UP));
            }

            if (Boolean.TRUE.equals(m.getIsDeleted()) || "D".equalsIgnoreCase(m.getRowStatus())) {
                ja021cMapper.deleteMaster(m);
            } else if (Boolean.TRUE.equals(m.getIsNew()) || "C".equalsIgnoreCase(m.getRowStatus())) {
                ja021cMapper.deleteMaster(m); // 멱등성 보장
                ja021cMapper.insertMaster(m);
            } else if (Boolean.TRUE.equals(m.getIsUpdated()) || "U".equalsIgnoreCase(m.getRowStatus())) {
                int count = ja021cMapper.updateMaster(m);
                if (count == 0) {
                    ja021cMapper.insertMaster(m);
                }
            }
        }
    }
}
