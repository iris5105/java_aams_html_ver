package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Sjt1tgDto;
import com.kfp.aams.domain.dailyadvisory.dto.Sjt1tgSaveDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Sjt1tgMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Sjt1tgService {

    private final Sjt1tgMapper sjt1tgMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Sjt1tgQueryDslRepository sjt1tgQueryDslRepository;

    /**
     * 선물/옵션 종가 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Sjt1tgDto> getSjt1tgList(LocalDate ymd) {
        if (ymd == null) {
            return List.of();
        }
        return sjt1tgMapper.selectSjt1tgList(ymd);
    }

    /**
     * 선물/옵션 종가 일괄 저장 (JPA EntityManager CUD)
     */
    @Transactional
    public void saveSjt1tg(Sjt1tgSaveDto saveDto) {
        if (saveDto == null) return;
        LocalDate ymd = saveDto.getYmd();

        // 1. 삭제 대상
        if (saveDto.getDeletedRows() != null) {
            for (Sjt1tgDto row : saveDto.getDeletedRows()) {
                if (row.getSjCd() != null && !row.getSjCd().isBlank()) {
                    sjt1tgQueryDslRepository.deleteSjt1tg(ymd, row.getSjCd());
                }
            }
        }

        // 2. 신규 생성 대상
        if (saveDto.getCreatedRows() != null) {
            for (Sjt1tgDto row : saveDto.getCreatedRows()) {
                if (row.getSjCd() != null && !row.getSjCd().isBlank()) {
                    row.setYmd(ymd);
                    try {
                        sjt1tgQueryDslRepository.insertSjt1tg(row);
                    } catch (Exception e) {
                        // 이미 존재할 경우 update 시도
                        sjt1tgQueryDslRepository.updateSjt1tg(row);
                    }
                }
            }
        }

        // 3. 수정 대상
        if (saveDto.getUpdatedRows() != null) {
            for (Sjt1tgDto row : saveDto.getUpdatedRows()) {
                if (row.getSjCd() != null && !row.getSjCd().isBlank()) {
                    row.setYmd(ymd);
                    int updated = sjt1tgQueryDslRepository.updateSjt1tg(row);
                    if (updated == 0) {
                        sjt1tgQueryDslRepository.insertSjt1tg(row);
                    }
                }
            }
        }
    }

    /**
     * 신규(결제지수) 생성 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Sjt1tgDto> generateNewFutures(String corpGr, LocalDate ymd) {
        if (ymd == null) return List.of();
        LocalDate junilYmd = ymd.minusDays(1);

        List<Sjt1tgDto> result = new ArrayList<>();
        // 1. 신규 선물
        List<Sjt1tgDto> futures = sjt1tgMapper.selectNewFuturesList(corpGr, ymd, junilYmd);
        if (futures != null) result.addAll(futures);

        // 2. 주식 결제지수
        List<Sjt1tgDto> stockIndex = sjt1tgMapper.selectStockIndexList(corpGr, ymd);
        if (stockIndex != null) result.addAll(stockIndex);

        // 3. 국고채 결제지수
        List<Sjt1tgDto> bondIndex = sjt1tgMapper.selectBondIndexList(corpGr, ymd);
        if (bondIndex != null) result.addAll(bondIndex);

        return result;
    }
}
