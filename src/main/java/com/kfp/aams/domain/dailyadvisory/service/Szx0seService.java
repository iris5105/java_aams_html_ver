package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Szx0seDto;
import com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Szx0seQueryDslRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_szx0se (계좌관리그룹/상품그룹)
 * - Single-table query on SZX0SE via QueryDSL (Guideline 4)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Szx0seService {

    private final Szx0seQueryDslRepository szx0seQueryDslRepository;

    public List<Szx0seDto> getSzx0seList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return szx0seQueryDslRepository.findSzx0seList(corpGr.trim());
    }

    @Transactional
    public void saveSzx0se(com.kfp.aams.domain.dailyadvisory.dto.Szx0seSaveRequestDto saveDto) {
        if (saveDto == null) return;
        String corpGr = saveDto.getCorpGr();

        // 1. 삭제
        if (saveDto.getDeleteList() != null) {
            for (Szx0seDto dto : saveDto.getDeleteList()) {
                String targetCorpGr = (dto.getCorpGr() != null && !dto.getCorpGr().isBlank()) ? dto.getCorpGr() : corpGr;
                String seriesGb = dto.getSeriesGb();
                if (seriesGb == null || seriesGb.isBlank()) {
                    seriesGb = (dto.getSeriesG1() != null ? dto.getSeriesG1().trim() : "") +
                               (dto.getSeriesG2() != null ? dto.getSeriesG2().trim() : "");
                }
                if (targetCorpGr != null && !targetCorpGr.isBlank() && seriesGb != null && !seriesGb.isBlank()) {
                    szx0seQueryDslRepository.deleteEntity(targetCorpGr, seriesGb);
                }
            }
        }

        // 2. 신규 등록
        if (saveDto.getInsertList() != null) {
            for (Szx0seDto dto : saveDto.getInsertList()) {
                String targetCorpGr = (dto.getCorpGr() != null && !dto.getCorpGr().isBlank()) ? dto.getCorpGr() : corpGr;
                dto.setCorpGr(targetCorpGr);
                String g1 = dto.getSeriesG1() != null ? dto.getSeriesG1().trim() : "";
                String g2 = dto.getSeriesG2() != null ? dto.getSeriesG2().trim() : "";
                String seriesGb = g1 + g2;
                dto.setSeriesGb(seriesGb);

                com.kfp.aams.domain.dailyadvisory.entity.Szx0se entity = toEntity(dto);
                szx0seQueryDslRepository.saveEntity(entity);
            }
        }

        // 3. 수정
        if (saveDto.getUpdateList() != null) {
            for (Szx0seDto dto : saveDto.getUpdateList()) {
                String targetCorpGr = (dto.getCorpGr() != null && !dto.getCorpGr().isBlank()) ? dto.getCorpGr() : corpGr;
                dto.setCorpGr(targetCorpGr);
                String g1 = dto.getSeriesG1() != null ? dto.getSeriesG1().trim() : "";
                String g2 = dto.getSeriesG2() != null ? dto.getSeriesG2().trim() : "";
                String seriesGb = g1 + g2;
                dto.setSeriesGb(seriesGb);

                com.kfp.aams.domain.dailyadvisory.entity.Szx0se entity = toEntity(dto);
                szx0seQueryDslRepository.saveEntity(entity);

                // PB updateend: series_gb 변경 시 szm0ia 동기화
                if (dto.getOriginalSeriesGb() != null && !dto.getOriginalSeriesGb().isBlank()
                        && !dto.getOriginalSeriesGb().equals(seriesGb)) {
                    szx0seQueryDslRepository.syncSzm0iaSeriesGb(targetCorpGr, dto.getOriginalSeriesGb(), seriesGb);
                }
            }
        }
    }

    private com.kfp.aams.domain.dailyadvisory.entity.Szx0se toEntity(Szx0seDto dto) {
        return com.kfp.aams.domain.dailyadvisory.entity.Szx0se.builder()
                .corpGr(dto.getCorpGr())
                .seriesG1(dto.getSeriesG1() != null ? dto.getSeriesG1().trim() : "")
                .seriesG2(dto.getSeriesG2() != null ? dto.getSeriesG2().trim() : "")
                .seriesGb(dto.getSeriesGb() != null ? dto.getSeriesGb().trim() : "")
                .seriesNm(dto.getSeriesNm())
                .retSusu(dto.getRetSusu())
                .retSusuGb(dto.getRetSusuGb())
                .futuresInclude(dto.getFuturesInclude())
                .used(dto.getUsed() != null ? dto.getUsed() : "1")
                .reSeoljYear(dto.getReSeoljYear())
                .sintakGigan(dto.getSintakGigan())
                .bosuGigan(dto.getBosuGigan())
                .mokpyoSuikPer(dto.getMokpyoSuikPer())
                .preBasic(dto.getPreBasic())
                .basicPer(dto.getBasicPer())
                .successPer(dto.getSuccessPer())
                .magamUsed(dto.getMagamUsed() != null ? dto.getMagamUsed() : "0")
                .dpUsed(dto.getDpUsed() != null ? dto.getDpUsed() : "0")
                .bmGr(dto.getBmGr())
                .gugan(dto.getGugan())
                .ga(dto.getGa())
                .bigo(dto.getBigo())
                .build();
    }
}
