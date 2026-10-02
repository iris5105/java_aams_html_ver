package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010nDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010nSaveDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010nMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja010nService {

    private final Ja010nMapper ja010nMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010nQueryDslRepository ja010nQueryDslRepository;

    /**
     * 주가지수 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja010nDto> getJa010nList() {
        return ja010nMapper.selectJa010nList();
    }

    /**
     * 주가지수 일괄 저장 (JPA EntityManager CUD)
     */
    @Transactional
    public void saveJa010n(Ja010nSaveDto saveDto) {
        if (saveDto == null) return;

        // 1. 삭제 대상
        if (saveDto.getDeletedRows() != null) {
            for (Ja010nDto row : saveDto.getDeletedRows()) {
                if (row.getYmd() != null) {
                    ja010nQueryDslRepository.deleteJa010n(row.getYmd());
                }
            }
        }

        // 2. 신규 생성 대상
        if (saveDto.getCreatedRows() != null) {
            for (Ja010nDto row : saveDto.getCreatedRows()) {
                if (row.getYmd() != null) {
                    row.setCorpGr("JISU");
                    row.setColId("kospi_jisu");
                    try {
                        ja010nQueryDslRepository.insertJa010n(row);
                    } catch (Exception e) {
                        ja010nQueryDslRepository.updateJa010n(row);
                    }
                }
            }
        }

        // 3. 수정 대상
        if (saveDto.getUpdatedRows() != null) {
            for (Ja010nDto row : saveDto.getUpdatedRows()) {
                if (row.getYmd() != null) {
                    row.setCorpGr("JISU");
                    row.setColId("kospi_jisu");
                    int updated = ja010nQueryDslRepository.updateJa010n(row);
                    if (updated == 0) {
                        ja010nQueryDslRepository.insertJa010n(row);
                    }
                }
            }
        }
    }
}
