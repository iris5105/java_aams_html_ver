package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Szx0seDto;
import com.kfp.aams.domain.daily.mapper.Szx0seMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Szx0seService {

    private final Szx0seMapper szx0seMapper;

    public List<Szx0seDto> getSzx0seList(String corpGr) {
        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : "2200";
        return szx0seMapper.selectSzx0seList(targetCorpGr);
    }
}
