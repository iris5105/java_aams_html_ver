package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Scm1pgDetailDto;
import com.kfp.aams.domain.daily.dto.Scm1pgMasterDto;
import com.kfp.aams.domain.daily.dto.Scm1pgSaveDto;
import com.kfp.aams.domain.daily.mapper.Scm1pgMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Scm1pgService {

    private final Scm1pgMapper scm1pgMapper;

    /**
     * 마스터 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Scm1pgMasterDto> getMasterList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return List.of();
        }
        return scm1pgMapper.selectMasterList(corpGr, ymd);
    }

    /**
     * 디테일 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Scm1pgDetailDto> getDetailList(String corpGr, String jmCd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            return List.of();
        }
        return scm1pgMapper.selectDetailList(corpGr, jmCd);
    }

    /**
     * 디테일 일괄 저장
     */
    @Transactional
    public void saveDetail(Scm1pgSaveDto saveDto) {
        if (saveDto == null) return;
        String corpGr = saveDto.getCorpGr();
        String jmCd = saveDto.getJmCd();

        // 1. 삭제
        if (saveDto.getDeletedRows() != null) {
            for (Scm1pgDetailDto row : saveDto.getDeletedRows()) {
                if (row.getYmd() != null && !row.getYmd().isBlank()) {
                    scm1pgMapper.deleteDetail(corpGr, jmCd, row.getYmd());
                }
            }
        }

        // 2. 신규
        if (saveDto.getCreatedRows() != null) {
            for (Scm1pgDetailDto row : saveDto.getCreatedRows()) {
                row.setCorpGr(corpGr);
                row.setJmCd(jmCd);
                try {
                    scm1pgMapper.insertDetail(row);
                } catch (Exception e) {
                    scm1pgMapper.updateDetail(row);
                }
            }
        }

        // 3. 수정
        if (saveDto.getUpdatedRows() != null) {
            for (Scm1pgDetailDto row : saveDto.getUpdatedRows()) {
                row.setCorpGr(corpGr);
                row.setJmCd(jmCd);
                int updated = scm1pgMapper.updateDetail(row);
                if (updated == 0) {
                    scm1pgMapper.insertDetail(row);
                }
            }
        }
    }
}
