package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036j2Dto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036j2HistoryDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036j2SaveRequest;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036j2Mapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class Ja036j2Service {

    private final Ja036j2Mapper ja036j2Mapper;

    @Transactional(readOnly = true)
    public List<Ja036j2Dto> getList(LocalDate ymd) {
        return ymd == null ? List.of() : ja036j2Mapper.selectList(ymd);
    }

    @Transactional(readOnly = true)
    public List<Ja036j2HistoryDto> getHistory(LocalDate ymd, String currency) {
        if (ymd == null || currency == null || currency.isBlank()) {
            return List.of();
        }
        return ja036j2Mapper.selectHistory(ymd, currency.trim());
    }

    @Transactional
    public int save(Ja036j2SaveRequest request) {
        if (request == null || request.getYmd() == null || request.getRows() == null) {
            return 0;
        }

        int changed = 0;
        for (Ja036j2Dto row : request.getRows()) {
            if (row == null || row.getCurrency() == null || row.getCurrency().isBlank()) {
                throw new IllegalArgumentException("통화를 입력해주세요.");
            }
            row.setGijunYmd(request.getYmd());
            row.setCurrency(row.getCurrency().trim().toUpperCase());
            if (row.getCurrency().length() != 3) {
                throw new IllegalArgumentException("통화는 3자리 코드로 입력해주세요.");
            }
            if (Boolean.TRUE.equals(row.getIsDeleted()) || "D".equalsIgnoreCase(row.getRowStatus())) {
                changed += ja036j2Mapper.deleteRate(request.getYmd(), row.getCurrency());
            } else if (Boolean.TRUE.equals(row.getIsNew())
                    || Boolean.TRUE.equals(row.getIsUpdated())
                    || "C".equalsIgnoreCase(row.getRowStatus())
                    || "U".equalsIgnoreCase(row.getRowStatus())) {
                if (row.getGijunRt() == null || row.getTransRt() == null) {
                    throw new IllegalArgumentException("재정환율과 거래환율을 입력해주세요.");
                }
                changed += ja036j2Mapper.mergeRate(row);
            }
        }
        return changed;
    }
}
