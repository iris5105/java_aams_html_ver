package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pDetailDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pMasterDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pSaveRequest;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja035pMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * W_JA035P 상환유예 관리 서비스
 */
@Service
@RequiredArgsConstructor
public class Ja035pService {

    private final Ja035pMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja035pMasterDto> getMasterList(String corpGr, String ymd) {
        return mapper.selectMasterList(corpGr, ymd);
    }

    @Transactional(readOnly = true)
    public List<Ja035pDetailDto> getDetailList(String corpGr, String trYmd, String trCd,
                                               String fundCd, String hjCd, Long trSeq, String aekGb) {
        return mapper.selectDetailList(corpGr, trYmd, trCd, fundCd, hjCd, trSeq, aekGb);
    }

    @Transactional(readOnly = true)
    public List<String> getHighlightDates(String corpGr) {
        return mapper.selectHighlightDates(corpGr);
    }

    @Transactional
    public int save(String corpGr, Ja035pSaveRequest request) {
        if (request == null) {
            return 0;
        }
        int changed = 0;

        if (request.getMasterChanges() != null) {
            for (Ja035pMasterDto row : request.getMasterChanges()) {
                if (row == null) continue;
                row.setCorpGr(corpGr);
                if (row.getTrSeq() == null || row.getTrSeq() <= 0) row.setTrSeq(1L);
                if (row.getAekGb() == null || row.getAekGb().isBlank()) row.setAekGb("1");

                boolean isDeleted = Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus());
                boolean isNew = Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus());
                boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());

                if (isDeleted) {
                    changed += mapper.deleteMaster(row);
                } else if (isNew) {
                    changed += mapper.insertMaster(row);
                } else if (isUpdated) {
                    changed += mapper.updateMaster(row);
                }
            }
        }

        if (request.getDetailChanges() != null) {
            for (Ja035pDetailDto row : request.getDetailChanges()) {
                if (row == null) continue;
                row.setCorpGr(corpGr);
                if (row.getTrSeq() == null || row.getTrSeq() <= 0) row.setTrSeq(1L);
                if (row.getAekGb() == null || row.getAekGb().isBlank()) row.setAekGb("1");

                boolean isDeleted = Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus());
                boolean isNew = Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus());
                boolean isUpdated = Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus());

                if (isDeleted) {
                    changed += mapper.deleteDetail(row);
                } else if (isNew) {
                    changed += mapper.insertDetail(row);
                } else if (isUpdated) {
                    changed += mapper.updateDetail(row);
                }
            }
        }

        return changed;
    }
}
