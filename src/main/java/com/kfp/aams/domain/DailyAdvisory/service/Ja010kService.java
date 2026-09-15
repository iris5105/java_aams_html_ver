package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja010kDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010kMasterDto;
import com.kfp.aams.domain.daily.dto.Ja010kSaveDto;
import com.kfp.aams.domain.daily.mapper.Ja010kMapper;
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

    @Transactional(readOnly = true)
    public List<Ja010kMasterDto> getMasterList(String corpGr, String tymd) {
        if (corpGr == null || corpGr.trim().isEmpty() || tymd == null || tymd.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return ja010kMapper.selectMasterList(corpGr, tymd.replace("-", ""));
    }

    @Transactional(readOnly = true)
    public List<Ja010kDetailDto> getDetailList(String corpGr, String fymd, String tymd, String fundCd) {
        if (corpGr == null || corpGr.trim().isEmpty() ||
            fymd == null || fymd.trim().isEmpty() ||
            tymd == null || tymd.trim().isEmpty() ||
            fundCd == null || fundCd.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return ja010kMapper.selectDetailList(corpGr, fymd.replace("-", ""), tymd.replace("-", ""), fundCd);
    }

    @Transactional
    public void save(Ja010kSaveDto saveDto) {
        if (saveDto == null || saveDto.getUpdatedList() == null || saveDto.getUpdatedList().isEmpty()) {
            return;
        }

        for (Ja010kSaveDto.Ja010kItemSaveDto item : saveDto.getUpdatedList()) {
            if (item.getYmd() != null) {
                item.setYmd(item.getYmd().replace("-", ""));
            }
            if (item.getBuyDate() != null) {
                item.setBuyDate(item.getBuyDate().replace("-", ""));
            }
            ja010kMapper.updateVcOld(item);
        }
    }
}
