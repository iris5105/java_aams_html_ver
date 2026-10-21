package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.CronQDto;
import com.kfp.aams.domain.usportfoliomodel.dto.CronStatusDto;
import com.kfp.aams.domain.usportfoliomodel.entity.CronQ;
import com.kfp.aams.domain.usportfoliomodel.entity.CronStatus;
import com.kfp.aams.domain.usportfoliomodel.repository.CronQRepository;
import com.kfp.aams.domain.usportfoliomodel.repository.CronStatusRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * CRON 작업 및 프로시저 관리 서비스 (W_CRON_Q)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CronQService {

    private final CronQRepository cronQRepository;
    private final CronStatusRepository cronStatusRepository;

    @PersistenceContext
    private EntityManager em;

    /**
     * CRON 작업 목록 조회 (CRON_Q 테이블)
     */
    @Transactional(readOnly = true)
    public List<CronQDto> getCronQList() {
        List<CronQ> entities = cronQRepository.findAllByOrderByCronKeyAscProcNameAsc();
        List<CronQDto> dtoList = new ArrayList<>();

        for (CronQ e : entities) {
            CronQDto dto = new CronQDto();
            dto.setCronKey(e.getCronKey());
            dto.setProcName(e.getProcName());
            dto.setProcComments(e.getProcComments());
            dto.setInParam(e.getInParam());
            dto.setOutParam(e.getOutParam());
            dto.setRunTime(e.getRunTime());
            dto.setRunStatus(e.getRunStatus());
            dtoList.add(dto);
        }
        return dtoList;
    }

    /**
     * CRON 실행 이력/상태 목록 조회 (CRON_STATUS 테이블)
     */
    @Transactional(readOnly = true)
    public List<CronStatusDto> getCronStatusList(String cronKey) {
        if (cronKey == null || cronKey.isBlank()) {
            return Collections.emptyList();
        }
        List<CronStatus> entities = cronStatusRepository.findByCronKeyOrderByRunTimeDesc(cronKey.trim());
        List<CronStatusDto> dtoList = new ArrayList<>();

        for (CronStatus e : entities) {
            CronStatusDto dto = new CronStatusDto(
                    e.getCronKey(),
                    e.getRunTime(),
                    e.getRunStatus(),
                    e.getOutParam()
            );
            dtoList.add(dto);
        }
        return dtoList;
    }

    /**
     * CRON 큐 CUD 일괄 저장 (Spring Data JPA / 더티 체킹 표준, 규정 01-2 & 01-3)
     */
    @Transactional
    public void saveCronQList(List<CronQDto> list) {
        if (list == null || list.isEmpty()) {
            return;
        }

        for (CronQDto dto : list) {
            if (dto.getCronKey() == null || dto.getCronKey().isBlank()) {
                continue;
            }

            String key = dto.getCronKey().trim();

            // 1. 삭제 (Delete)
            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                CronQ entity = em.find(CronQ.class, key);
                if (entity != null) {
                    em.remove(entity);
                }
                continue;
            }

            // 2. 신규 등록 (Create)
            if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                CronQ entity = new CronQ(
                        key,
                        dto.getProcName(),
                        dto.getProcComments(),
                        dto.getInParam(),
                        dto.getOutParam(),
                        dto.getRunTime(),
                        dto.getRunStatus()
                );
                em.persist(entity);
                continue;
            }

            // 3. 수정 (Update - 더티 체킹)
            if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                CronQ entity = em.find(CronQ.class, key);
                if (entity != null) {
                    entity.setProcName(dto.getProcName());
                    entity.setProcComments(dto.getProcComments());
                    entity.setInParam(dto.getInParam());
                    entity.setOutParam(dto.getOutParam());
                    entity.setRunTime(dto.getRunTime());
                    entity.setRunStatus(dto.getRunStatus());
                }
            }
        }
        em.flush();
    }
}
