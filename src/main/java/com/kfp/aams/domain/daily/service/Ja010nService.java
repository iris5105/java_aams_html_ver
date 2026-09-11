package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010nDto;
import com.kfp.aams.domain.daily.dto.Ja010nSaveDto;
import com.kfp.aams.domain.daily.mapper.Ja010nMapper;
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

    /**
     * 주가지수 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja010nDto> getJa010nList() {
        return ja010nMapper.selectJa010nList();
    }

    /**
     * 주가지수 일괄 저장
     */
    @Transactional
    public void saveJa010n(Ja010nSaveDto saveDto) {
        if (saveDto == null) return;

        // 1. 삭제 대상
        if (saveDto.getDeletedRows() != null) {
            for (Ja010nDto row : saveDto.getDeletedRows()) {
                if (row.getYmd() != null && !row.getYmd().isBlank()) {
                    ja010nMapper.deleteJa010n(row.getYmd());
                }
            }
        }

        // 2. 신규 생성 대상
        if (saveDto.getCreatedRows() != null) {
            for (Ja010nDto row : saveDto.getCreatedRows()) {
                if (row.getYmd() != null && !row.getYmd().isBlank()) {
                    try {
                        ja010nMapper.insertJa010n(row);
                    } catch (Exception e) {
                        ja010nMapper.updateJa010n(row);
                    }
                }
            }
        }

        // 3. 수정 대상
        if (saveDto.getUpdatedRows() != null) {
            for (Ja010nDto row : saveDto.getUpdatedRows()) {
                if (row.getYmd() != null && !row.getYmd().isBlank()) {
                    int updated = ja010nMapper.updateJa010n(row);
                    if (updated == 0) {
                        ja010nMapper.insertJa010n(row);
                    }
                }
            }
        }
    }
}
