package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bCorpDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bFundDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bItemDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bSaveDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja021bMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja021bService {

    private final Ja021bMapper ja021bMapper;
    private final WorkDateService workDateService;

    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 좌측 회사 목록 조회 (dl_corp_gr)
     */
    public List<Ja021bCorpDto> getCorpList(String ym, String customerGr, String corpGr) {
        return ja021bMapper.selectCorpList(ym, customerGr, corpGr);
    }

    /**
     * 탭 1: 예상배당공시 마스터 목록 조회 (d_ja021b_t11)
     */
    public List<Ja021bMasterDto> getT1MasterList(String corpGr, String ym, String customerGr) {
        return ja021bMapper.selectT1MasterList(corpGr, ym, customerGr);
    }

    /**
     * 종목별 배당 상세 조회 (d_ja021b_t12, d_ja021b_p1)
     */
    public List<Ja021bItemDto> getItemList(String corpGr, String ymd, String trCd, String balhCo) {
        List<Ja021bItemDto> list = ja021bMapper.selectItemList(corpGr, ymd, trCd, balhCo);
        if ((list == null || list.isEmpty()) && balhCo != null && !balhCo.isBlank()) {
            // 팝업 등의 경우 데이터가 없으면 종목마스터에서 초기 목록 조회
            return ja021bMapper.selectInitialBalhItems(corpGr, balhCo);
        }
        return list;
    }

    /**
     * 탭 2: 운용사별 예상배당 마스터 목록 조회 (d_ja021b_t21)
     */
    public List<Ja021bMasterDto> getT2MasterList(String corpGr, String ym, String workDate) {
        return ja021bMapper.selectT2MasterList(corpGr, ym, workDate);
    }

    /**
     * 탭 2: 펀드별 배당권리 상세 조회 (d_ja021b_t22)
     */
    public List<Ja021bFundDetailDto> getT2DetailList(String corpGr, String ymd, String balhCo) {
        return ja021bMapper.selectT2DetailList(corpGr, ymd, balhCo);
    }

    /**
     * 탭 3: 현금확정배당(G20) 마스터 목록 조회 (d_ja021b_t31)
     */
    public List<Ja021bMasterDto> getT3MasterList(String customerGr, String ym, String workDate) {
        return ja021bMapper.selectT3MasterList(customerGr, ym, workDate);
    }

    /**
     * 탭 3~5: 펀드별 배당권리 상세 조회 (d_ja021b_t32, t42, t52)
     */
    public List<Ja021bFundDetailDto> getT3DetailList(String corpGr, String customerGr, String brokYmd, String balhCo) {
        return ja021bMapper.selectT3DetailList(corpGr, customerGr, brokYmd, balhCo);
    }

    /**
     * 탭 4: 주식확정배당(G20) 마스터 목록 조회 (d_ja021b_t41)
     */
    public List<Ja021bMasterDto> getT4MasterList(String customerGr, String ym, String workDate) {
        return ja021bMapper.selectT4MasterList(customerGr, ym, workDate);
    }

    /**
     * 탭 5: 2차(주총)확정(G25) 마스터 목록 조회 (d_ja021b_t51)
     */
    public List<Ja021bMasterDto> getT5MasterList(String customerGr, String ym, String workDate) {
        return ja021bMapper.selectT5MasterList(customerGr, ym, workDate);
    }

    /**
     * 발행사 액면가 조회
     */
    public BigDecimal getBalhAekm(String balhCo) {
        return ja021bMapper.selectBalhAekm(balhCo);
    }

    /**
     * 일괄 저장 (Master / Item)
     */
    @Transactional
    public void save(Ja021bSaveDto saveDto) {
        if (saveDto == null) return;

        // 1. 마스터 목록 CUD
        if (saveDto.getMasterList() != null) {
            for (Ja021bMasterDto m : saveDto.getMasterList()) {
                if (Boolean.TRUE.equals(m.getIsDeleted()) || "D".equals(m.getRowStatus())) {
                    ja021bMapper.deleteItemsByMaster(m);
                    ja021bMapper.deleteMaster(m);
                } else if (Boolean.TRUE.equals(m.getIsNew()) || "C".equals(m.getRowStatus())) {
                    ja021bMapper.insertMaster(m);
                } else if (Boolean.TRUE.equals(m.getIsUpdated()) || "U".equals(m.getRowStatus())) {
                    ja021bMapper.updateMaster(m);
                }
            }
        }

        // 2. 종목별 목록 CUD
        if (saveDto.getItemList() != null) {
            for (Ja021bItemDto item : saveDto.getItemList()) {
                if (Boolean.TRUE.equals(item.getIsDeleted()) || "D".equals(item.getRowStatus())) {
                    ja021bMapper.deleteItem(item);
                } else if (Boolean.TRUE.equals(item.getIsNew()) || "C".equals(item.getRowStatus())) {
                    ja021bMapper.insertItem(item);
                } else if (Boolean.TRUE.equals(item.getIsUpdated()) || "U".equals(item.getRowStatus())) {
                    ja021bMapper.updateItem(item);
                }
            }
        }
    }
}
