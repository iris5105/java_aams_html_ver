package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032gDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032gMasterDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032gMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032gService {

    private final Ja032gMapper ja032gMapper;

    /**
     * 해외 파생종목 목록 조회 (d_ja032g1)
     */
    @Transactional(readOnly = true)
    public List<Ja032gMasterDto> getMasterList(String corpGr, String lsyYmd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja032gMapper.selectMasterList(corpGr, lsyYmd);
    }

    /**
     * 해외옵션 일별 시세 내역 조회 (d_ja032g2)
     */
    @Transactional(readOnly = true)
    public List<Ja032gDetailDto> getDetailList(String corpGr, String ymd, String jmCd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032gMapper.selectDetailList(corpGr, ymd, jmCd);
    }

    /**
     * 마스터 파생종목 CUD 일괄 저장
     */
    @Transactional
    public Map<String, Object> saveMasterList(List<Ja032gMasterDto> list, String corpGr) {
        Map<String, Object> result = new HashMap<>();
        if (list == null || list.isEmpty()) {
            result.put("success", true);
            result.put("message", "저장할 데이터가 없습니다.");
            return result;
        }

        int inserted = 0;
        int updated = 0;
        int deleted = 0;

        for (Ja032gMasterDto dto : list) {
            dto.setCorpGr(corpGr);
            if (dto.getJasanGb() == null || dto.getJasanGb().isBlank()) {
                dto.setJasanGb("A");
            }
            if (dto.getSeqNo() == null) {
                dto.setSeqNo(1);
            }
            if (dto.getSigaAgent() == null || dto.getSigaAgent().isBlank()) {
                dto.setSigaAgent("B");
            }

            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                ja032gMapper.deleteMaster(corpGr, dto.getJmCd(), dto.getJasanGb(), dto.getSedol());
                deleted++;
            } else if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                ja032gMapper.insertMaster(dto);
                inserted++;
            } else if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                ja032gMapper.updateMaster(dto);
                updated++;
            }
        }

        result.put("success", true);
        result.put("message", String.format("정상적으로 저장되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)", inserted, updated, deleted));
        return result;
    }

    /**
     * 디테일 일별 시세 CUD 일괄 저장
     */
    @Transactional
    public Map<String, Object> saveDetailList(List<Ja032gDetailDto> list, String corpGr, String masterJmCd) {
        Map<String, Object> result = new HashMap<>();
        if (list == null || list.isEmpty()) {
            result.put("success", true);
            result.put("message", "저장할 일별 시세 데이터가 없습니다.");
            return result;
        }

        int inserted = 0;
        int updated = 0;
        int deleted = 0;

        for (Ja032gDetailDto dto : list) {
            dto.setCorpGr(corpGr);
            if (dto.getJmCd() == null || dto.getJmCd().isBlank()) {
                dto.setJmCd(masterJmCd);
            }

            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                ja032gMapper.deleteDetail(corpGr, dto.getYmd(), dto.getJmCd());
                deleted++;
            } else if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                ja032gMapper.insertDetail(dto);
                inserted++;
            } else if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                ja032gMapper.updateDetail(dto);
                updated++;
            }
        }

        result.put("success", true);
        result.put("message", String.format("일별 시세가 저장되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)", inserted, updated, deleted));
        return result;
    }

    /**
     * 종목코드 수기 입력 시 국가/통화 자동 연동 조회
     */
    @Transactional(readOnly = true)
    public Map<String, String> getCodeInfo(String stockGb, String balhNation, String currency) {
        Map<String, String> res = new HashMap<>();
        if (stockGb != null && !stockGb.isBlank()) {
            String nation = ja032gMapper.selectNationByStockGb(stockGb);
            res.put("balhNation", nation != null ? nation : "");
            if (nation != null && !nation.isBlank()) {
                String curr = ja032gMapper.selectCurrencyByNation(nation);
                res.put("currency", curr != null ? curr : "");
            }
        } else if (balhNation != null && !balhNation.isBlank()) {
            String curr = ja032gMapper.selectCurrencyByNation(balhNation);
            res.put("currency", curr != null ? curr : "");
        } else if (currency != null && !currency.isBlank()) {
            String nation = ja032gMapper.selectNationByCurrency(currency);
            res.put("balhNation", nation != null ? nation : "");
        }
        return res;
    }
}
