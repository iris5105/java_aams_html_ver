package com.kfp.aams.domain.foreignassetmanagement.service;

import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036kLoadDto;
import com.kfp.aams.domain.foreignassetmanagement.mapper.Ja036kMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class Ja036kService {
    private final Ja036kMapper mapper;

    @Transactional(readOnly = true)
    public List<Ja036kLoadDto> getList(String mode, String corpGr, LocalDate ymd) {
        return switch (mode) {
            case "status" -> mapper.selectStatusList(corpGr, ymd);
            case "trade" -> mapper.selectTradeLoadList(corpGr, ymd);
            case "balance" -> mapper.selectBalanceList(corpGr, ymd);
            default -> throw new IllegalArgumentException("지원하지 않는 조회 구분입니다.");
        };
    }
}
