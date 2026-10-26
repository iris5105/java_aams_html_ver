package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010jDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010jMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010jService {

    private final Ja010jMapper ja010jMapper;

    public List<Ja010jDto> selectJa010jList(String corpGr, LocalDate ymd) {
        if (corpGr == null || corpGr.isBlank() || ymd == null) {
            return Collections.emptyList();
        }
        return ja010jMapper.selectJa010jList(corpGr, ymd);
    }
}

