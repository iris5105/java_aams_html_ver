package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja031fDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031fMasterDto;
import com.kfp.aams.domain.assetmanagement.mapper.Ja031fMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja031fService {

    private final Ja031fMapper mapper;

    /**
     * 펀드(계좌) 목록 조회
     * PB w_ja031f dw_list::retrieveend: 맨 앞에 '%' (전체) 행 삽입
     */
    public List<Ja031fMasterDto> getFundList(String corpGr, String fymd, String tymd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }

        LocalDate fromDate = parseDate(fymd);
        LocalDate toDate = parseDate(tymd);

        if (fromDate == null || toDate == null) {
            log.warn("[Ja031fService] Invalid date range: fymd={}, tymd={}", fymd, tymd);
            return Collections.emptyList();
        }

        List<Ja031fMasterDto> list = mapper.selectFundList(corpGr.trim(), fromDate, toDate);
        List<Ja031fMasterDto> result = new ArrayList<>();

        // PB 원본 동일: 첫 번째 행에 '전체(%)' 추가
        result.add(Ja031fMasterDto.builder()
                .fundCd("%")
                .fundNm("전체")
                .build());

        if (list != null && !list.isEmpty()) {
            result.addAll(list);
        }

        return result;
    }

    /**
     * 채권 매매내역 상세 목록 조회
     */
    public List<Ja031fDetailDto> getDetailList(String corpGr, String fymd, String tymd, String fundCd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }

        LocalDate fromDate = parseDate(fymd);
        LocalDate toDate = parseDate(tymd);

        if (fromDate == null || toDate == null) {
            log.warn("[Ja031fService] Invalid date range: fymd={}, tymd={}", fymd, tymd);
            return Collections.emptyList();
        }

        String targetFundCd = (fundCd != null) ? fundCd.trim() : "";
        return mapper.selectDetailList(corpGr.trim(), fromDate, toDate, targetFundCd);
    }

    private LocalDate parseDate(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return null;
        }
        String clean = dateStr.trim().replaceAll("[^0-9]", "");
        if (clean.length() == 8) {
            try {
                return LocalDate.parse(clean, DateTimeFormatter.ofPattern("yyyyMMdd"));
            } catch (Exception e) {
                log.warn("[Ja031fService] Date parsing failed: {}", dateStr, e);
            }
        }
        return null;
    }
}

