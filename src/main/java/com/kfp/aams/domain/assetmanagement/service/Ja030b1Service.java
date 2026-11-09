package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030b1Dto;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030b1Mapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja030b1Service {

    private final Ja030b1Mapper mapper;

    public List<Ja030b1Dto> getFundList(String corpGr, String fymd, String tymd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }

        LocalDate fromDate = parseDate(fymd);
        LocalDate toDate = parseDate(tymd);

        if (fromDate == null || toDate == null) {
            log.warn("[Ja030b1Service] Invalid date range: fymd={}, tymd={}", fymd, tymd);
            return Collections.emptyList();
        }

        return mapper.selectFundList(corpGr.trim(), fromDate, toDate);
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
                log.warn("[Ja030b1Service] Date parsing failed: {}", dateStr, e);
            }
        }
        return null;
    }
}

