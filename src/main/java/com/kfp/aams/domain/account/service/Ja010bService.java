package com.kfp.aams.domain.account.service;

import com.kfp.aams.domain.account.dto.Ja010bDetailDto;
import com.kfp.aams.domain.account.dto.Ja010bIoDto;
import com.kfp.aams.domain.account.dto.Ja010bMasterDto;
import com.kfp.aams.domain.account.mapper.Ja010bMapper;
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
        return ja010bMapper.selectJa010bMasterList(corpGr);
    }

    public List<Ja010bDetailDto> getDetailList(String corpGr, String fundCd) {
        return ja010bMapper.selectJa010bDetailList(corpGr, fundCd);
    }

    public List<Ja010bIoDto> getIoList(String corpGr, String fundCd) {
        return ja010bMapper.selectJa010bIoList(corpGr, fundCd);
    }
}
