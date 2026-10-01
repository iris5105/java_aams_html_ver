package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja990cDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja990cMasterDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja990cSaveDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja990cMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja990cService {

    private final Ja990cMapper ja990cMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja990cQueryDslRepository ja990cQueryDslRepository;

    @Transactional(readOnly = true)
    public List<Ja990cMasterDto> getMasterList(boolean isAdmin) {
        String cdLen = isAdmin ? "0" : "2";
        return ja990cMapper.selectMasterList("%", cdLen);
    }

    @Transactional(readOnly = true)
    public List<Ja990cDetailDto> getDetailList(String balhCo) {
        if (balhCo == null || balhCo.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return ja990cMapper.selectDetailList(balhCo.trim());
    }

    @Transactional
    public void save(Ja990cSaveDto saveDto, String updUser) {
        if (saveDto == null) return;

        // 1. Delete
        if (saveDto.getDeletedList() != null) {
            for (Ja990cMasterDto item : saveDto.getDeletedList()) {
                if (item.getBalhCo() != null && !item.getBalhCo().isBlank()) {
                    ja990cQueryDslRepository.deleteMaster(item.getBalhCo());
                }
            }
        }

        // 2. Insert
        if (saveDto.getInsertedList() != null) {
            for (Ja990cMasterDto item : saveDto.getInsertedList()) {
                if (item.getBalhCo() == null || item.getBalhCo().isBlank()) {
                    throw new IllegalArgumentException("발행기관코드는 필수 입력 항목입니다.");
                }
                if (ja990cQueryDslRepository.checkBalhCoExists(item.getBalhCo()) > 0) {
                    throw new IllegalStateException("이미 등록된 발행기관입니다: " + item.getBalhCo());
                }
                if (item.getBalhNation() == null || item.getBalhNation().isBlank()) {
                    item.setBalhNation("KR");
                }
                if (item.getTrStopGb() == null || item.getTrStopGb().isBlank()) {
                    item.setTrStopGb("1");
                }
                if (item.getSosokGb() == null || item.getSosokGb().isBlank()) {
                    item.setSosokGb("B");
                }
                if (item.getGyulMm() == null || item.getGyulMm().isBlank()) {
                    item.setGyulMm("12");
                }
                ja990cQueryDslRepository.insertMaster(item);
            }
        }

        // 3. Update
        if (saveDto.getUpdatedList() != null) {
            for (Ja990cMasterDto item : saveDto.getUpdatedList()) {
                if (item.getBalhCo() != null && !item.getBalhCo().isBlank()) {
                    ja990cQueryDslRepository.updateMaster(item);
                }
            }
        }

        // 4. History Logging
        if (saveDto.getHistoryList() != null) {
            for (Ja990cDetailDto hist : saveDto.getHistoryList()) {
                if (hist.getBalhCo() != null && !hist.getBalhCo().isBlank()) {
                    if (hist.getUpdUser() == null || hist.getUpdUser().isBlank()) {
                        hist.setUpdUser(updUser != null ? updUser : "SYSTEM");
                    }
                    ja990cQueryDslRepository.insertHistory(hist);
                }
            }
        }
    }
}
