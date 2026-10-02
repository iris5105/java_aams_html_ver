package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010kDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010kMasterDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010kSaveDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010kMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja010kService {

    private final Ja010kMapper ja010kMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010kQueryDslRepository ja010kQueryDslRepository;

    @Transactional(readOnly = true)
    public List<Ja010kMasterDto> getMasterList(String corpGr, java.time.LocalDate tymd) {
        if (corpGr == null || corpGr.trim().isEmpty() || tymd == null) {
            return Collections.emptyList();
        }
        return ja010kMapper.selectMasterList(corpGr, tymd);
    }

    @Transactional(readOnly = true)
    public List<Ja010kDetailDto> getDetailList(String corpGr, java.time.LocalDate fymd, java.time.LocalDate tymd, String fundCd) {
        if (corpGr == null || corpGr.trim().isEmpty() ||
            fymd == null || tymd == null ||
            fundCd == null || fundCd.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return ja010kMapper.selectDetailList(corpGr, fymd, tymd, fundCd);
    }

    @Transactional
    public void save(Ja010kSaveDto saveDto) {
        if (saveDto == null || saveDto.getUpdatedList() == null || saveDto.getUpdatedList().isEmpty()) {
            return;
        }

        for (Ja010kSaveDto.Ja010kItemSaveDto item : saveDto.getUpdatedList()) {
            ja010kQueryDslRepository.updateVcOld(item);
        }
    }
}
