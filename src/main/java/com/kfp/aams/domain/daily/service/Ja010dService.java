package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010dDto;
import com.kfp.aams.domain.daily.mapper.Ja010dMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010dService {

    private final Ja010dMapper ja010dMapper;

    public List<Ja010dDto> getJa010dList(String corpGr, String trYmd) {
        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : "2200";
        return ja010dMapper.selectJa010dList(targetCorpGr, trYmd);
    }

    public List<String> getTrDates(String corpGr) {
        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : "2200";
        return ja010dMapper.selectJa010dTrDates(targetCorpGr);
    }
}
