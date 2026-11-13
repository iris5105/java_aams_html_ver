package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030mDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030mCopyDateDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030mSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030mMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class Ja030mService {
    private final Ja030mMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja030mDto> list(String corpGr, LocalDate workDate, boolean allCorp) {
        return mapper.selectList(corpGr, workDate, allCorp);
    }

    @Transactional
    public Map<String, Object> save(Ja030mSaveRequest request) {
        int inserted = 0, updated = 0, deleted = 0;
        if (request.getDeletedRows() != null) for (Ja030mDto row : request.getDeletedRows()) {
            if (row != null && hasKey(row)) {
                mapper.delete(row.getCorpGr(), row.getJmCd());
                deleted++;
            }
        }
        if (request.getRows() != null) for (Ja030mDto row : request.getRows()) {
            if (row == null || Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus())) continue;
            validate(row);
            if (Boolean.TRUE.equals(row.getIsNew()) || "C".equalsIgnoreCase(row.getRowStatus())) {
                if (row.getJmCd() == null || row.getJmCd().isBlank()) row.setJmCd(mapper.selectNextJmCd(row.getCorpGr(), row.getBalhYmd(), row.getCashCd()));
                mapper.insert(row); inserted++;
            } else if (Boolean.TRUE.equals(row.getIsUpdated()) || "U".equalsIgnoreCase(row.getRowStatus())) {
                mapper.update(row); updated++;
            }
        }
        return Map.of("success", true, "inserted", inserted, "updated", updated, "deleted", deleted,
                "message", "저장되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)".formatted(inserted, updated, deleted));
    }

    private boolean hasKey(Ja030mDto row) { return row.getCorpGr() != null && !row.getCorpGr().isBlank() && row.getJmCd() != null && !row.getJmCd().isBlank(); }

    public LocalDate getSanghwYmdForBalhYmd(LocalDate balhYmd) {
        if (balhYmd == null) throw new IllegalArgumentException("발행일자를 입력하십시오.");
        return mapper.selectSanghwYmdForBalhYmd(balhYmd);
    }

    public Ja030mCopyDateDto getCopyDates(LocalDate balhYmd, LocalDate sanghwYmd) {
        if (balhYmd == null || sanghwYmd == null) throw new IllegalArgumentException("복사할 발행일자와 만기인출일을 확인하십시오.");
        return mapper.selectCopyDates(balhYmd, sanghwYmd);
    }

    private void validate(Ja030mDto row) {
        if (row.getCorpGr() == null || row.getCorpGr().isBlank() || row.getCashCd() == null || row.getCashCd().isBlank()
                || row.getSutakCd() == null || row.getSutakCd().isBlank() || row.getBalhYmd() == null || row.getSanghwYmd() == null) {
            throw new IllegalArgumentException("운용사, 자산종류, 증권(수탁)사, 발행일자, 만기인출일은 필수입니다.");
        }
        BigDecimal rate = row.getPyomIyulPer() == null ? BigDecimal.ZERO : row.getPyomIyulPer();
        row.setPyomIyul(rate.movePointLeft(2));
        row.setMeibSuikRt(row.getPyomIyul());
        if (row.getHjNm() == null || row.getHjNm().isBlank()) row.setHjNm("예금(" + rate.stripTrailingZeros().toPlainString() + "%)");
    }
}
