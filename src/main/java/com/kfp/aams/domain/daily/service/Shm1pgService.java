package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Shm1pgDto;
import com.kfp.aams.domain.daily.dto.Shm1pgSaveDto;
import com.kfp.aams.domain.daily.mapper.Shm1pgMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Shm1pgService {

    private final Shm1pgMapper shm1pgMapper;

    /**
     * 현금신용등급 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Shm1pgDto> getShm1pgList(String corpGr, String ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return List.of();
        }
        return shm1pgMapper.selectShm1pgList(corpGr, ymd);
    }

    /**
     * 현금신용등급 저장
     */
    @Transactional
    public void saveShm1pg(Shm1pgSaveDto saveDto) {
        if (saveDto == null || saveDto.getUpdatedRows() == null) return;
        String corpGr = saveDto.getCorpGr();

        for (Shm1pgDto row : saveDto.getUpdatedRows()) {
            if (row.getJmCd() != null && !row.getJmCd().isBlank()) {
                row.setCorpGr(corpGr);
                shm1pgMapper.updateShm1pg(row);
            }
        }
    }
}
