package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010aDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010aMasterDto;
import com.kfp.aams.domain.daily.mapper.Ja010aMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010aService {

    private final Ja010aMapper ja010aMapper;

    public List<Ja010aMasterDto> getMasterList() {
        return ja010aMapper.selectJa010aMasterList();
    }

    public List<Ja010aDetailDto> getDetailList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return List.of();
        }
        return ja010aMapper.selectJa010aDetailList(corpGr.trim());
    }
}
