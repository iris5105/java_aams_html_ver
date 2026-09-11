package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.Ja990dDto;
import com.kfp.aams.domain.daily.dto.Ja990dSaveDto;
import com.kfp.aams.domain.daily.mapper.Ja990dMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja990dService {

    private final Ja990dMapper ja990dMapper;

    @Transactional(readOnly = true)
    public List<Ja990dDto> getStockList(String searchKeyword) {
        return ja990dMapper.selectStockList(searchKeyword != null ? searchKeyword.trim() : null);
    }

    @Transactional(readOnly = true)
    public List<Ja990dDto> getRightList(String searchKeyword) {
        return ja990dMapper.selectRightList(searchKeyword != null ? searchKeyword.trim() : null);
    }

    @Transactional
    public void save(Ja990dSaveDto saveDto) {
        if (saveDto == null) return;

        // 1. Delete
        if (saveDto.getDeletedList() != null) {
            for (Ja990dDto item : saveDto.getDeletedList()) {
                if (item.getJmCd() != null && !item.getJmCd().isBlank()) {
                    ja990dMapper.deleteJm(item.getJmCd());
                }
            }
        }

        // 2. Insert
        if (saveDto.getInsertedList() != null) {
            for (Ja990dDto item : saveDto.getInsertedList()) {
                if (item.getJmCd() == null || item.getJmCd().isBlank()) {
                    throw new IllegalArgumentException("종목코드는 필수 입력 항목입니다.");
                }
                if (ja990dMapper.checkJmCdExists(item.getJmCd()) > 0) {
                    throw new IllegalStateException("이미 등록된 종목코드입니다: " + item.getJmCd());
                }
                ja990dMapper.insertJm(item);
            }
        }

        // 3. Update
        if (saveDto.getUpdatedList() != null) {
            for (Ja990dDto item : saveDto.getUpdatedList()) {
                if (item.getJmCd() != null && !item.getJmCd().isBlank()) {
                    ja990dMapper.updateJm(item);
                }
            }
        }
    }
}
