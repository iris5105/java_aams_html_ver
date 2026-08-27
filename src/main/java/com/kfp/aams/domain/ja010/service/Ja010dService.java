package com.kfp.aams.domain.ja010.service;

import com.kfp.aams.domain.ja010.dto.Ja010dDto;
import com.kfp.aams.domain.ja010.mapper.Ja010dMapper;
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
        return ja010dMapper.selectJa010dList(corpGr, trYmd);
    }

    public List<String> getTrDates(String corpGr) {
        return ja010dMapper.selectJa010dTrDates(corpGr);
    }
}
