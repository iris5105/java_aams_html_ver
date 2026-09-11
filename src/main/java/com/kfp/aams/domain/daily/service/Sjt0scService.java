package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Sjt0scDto;
import com.kfp.aams.domain.daily.dto.Sjt0scSaveDto;
import com.kfp.aams.domain.daily.mapper.Sjt0scMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Sjt0scService {

    private final Sjt0scMapper sjt0scMapper;

    /**
     * 펀드 기준가(시가액)등록 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Sjt0scDto> getSjt0scList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return List.of();
        }
        return sjt0scMapper.selectSjt0scList(corpGr, ymd);
    }

    /**
     * 펀드 기준가(시가액)등록 일괄 저장
     */
    @Transactional
    public void saveSjt0sc(Sjt0scSaveDto saveDto) {
        if (saveDto == null) return;
        String corpGr = saveDto.getCorpGr();
        String ymd = saveDto.getYmd();

        // 1. 삭제 대상
        if (saveDto.getDeletedRows() != null) {
            for (Sjt0scDto row : saveDto.getDeletedRows()) {
                if (row.getJmCd() != null && !row.getJmCd().isBlank()) {
                    sjt0scMapper.deleteSjt0sc(corpGr, ymd, row.getJmCd());
                }
            }
        }

        // 2. 신규 생성 대상
        if (saveDto.getCreatedRows() != null) {
            for (Sjt0scDto row : saveDto.getCreatedRows()) {
                if (row.getJmCd() != null && !row.getJmCd().isBlank()) {
                    row.setCorpGr(corpGr);
                    row.setYmd(ymd);
                    try {
                        sjt0scMapper.insertSjt0sc(row);
                    } catch (Exception e) {
                        sjt0scMapper.updateSjt0sc(row);
                    }
                }
            }
        }

        // 3. 수정 대상
        if (saveDto.getUpdatedRows() != null) {
            for (Sjt0scDto row : saveDto.getUpdatedRows()) {
                if (row.getJmCd() != null && !row.getJmCd().isBlank()) {
                    row.setCorpGr(corpGr);
                    row.setYmd(ymd);
                    int updated = sjt0scMapper.updateSjt0sc(row);
                    if (updated == 0) {
                        sjt0scMapper.insertSjt0sc(row);
                    }
                }
            }
        }
    }
}
