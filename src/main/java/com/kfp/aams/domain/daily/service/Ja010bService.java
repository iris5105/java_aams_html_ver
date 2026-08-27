package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010bDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010bIoDto;
import com.kfp.aams.domain.daily.dto.Ja010bMasterDto;
import com.kfp.aams.domain.daily.mapper.Ja010bMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010bService {

    private final Ja010bMapper ja010bMapper;

    public List<Ja010bMasterDto> getMasterList(String corpGr) {
        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : "2200";
        return ja010bMapper.selectJa010bMasterList(targetCorpGr);
    }

    public List<Ja010bDetailDto> getDetailList(String corpGr, String fundCd) {
        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : "2200";
        return ja010bMapper.selectJa010bDetailList(targetCorpGr, fundCd);
    }

    public List<Ja010bIoDto> getIoList(String corpGr, String fundCd) {
        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : "2200";
        return ja010bMapper.selectJa010bIoList(targetCorpGr, fundCd);
    }
}
