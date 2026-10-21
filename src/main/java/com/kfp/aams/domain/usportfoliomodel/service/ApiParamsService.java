package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.ApiParamsDto;
import com.kfp.aams.domain.usportfoliomodel.entity.ApiParams;
import com.kfp.aams.domain.usportfoliomodel.entity.ApiParamsId;
import com.kfp.aams.domain.usportfoliomodel.mapper.ApiParamsMapper;
import com.kfp.aams.domain.usportfoliomodel.repository.ApiParamsRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Collections;
import java.util.List;

/**
 * API PARAMETER 관리 서비스 (W_API_PARAMS)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ApiParamsService {

    private final ApiParamsMapper apiParamsMapper;
    private final ApiParamsRepository apiParamsRepository;

    @PersistenceContext
    private EntityManager em;

    /**
     * API 파라미터 목록 조회 (MyBatis 복합 조인, 규정 01-2)
     */
    @Transactional(readOnly = true)
    public List<ApiParamsDto> getApiParamsList(String trCoCd) {
        if (trCoCd == null || trCoCd.isBlank()) {
            return Collections.emptyList();
        }
        return apiParamsMapper.selectApiParamsList(trCoCd.trim());
    }

    /**
     * API 파라미터 CUD 일괄 저장 (Spring Data JPA / 더티 체킹 표준, 규정 01-2 & 01-3)
     */
    @Transactional
    public void saveApiParamsList(List<ApiParamsDto> list) {
        if (list == null || list.isEmpty()) {
            return;
        }

        for (ApiParamsDto dto : list) {
            if (dto.getTrCoCd() == null || dto.getTrCoCd().isBlank()
                    || dto.getGrCd() == null || dto.getGrCd().isBlank()
                    || dto.getScd() == null || dto.getScd().isBlank()
                    || dto.getCompany() == null || dto.getCompany().isBlank()) {
                continue;
            }

            ApiParamsId id = new ApiParamsId(
                    dto.getTrCoCd().trim(),
                    dto.getGrCd().trim(),
                    dto.getScd().trim(),
                    dto.getCompany().trim()
            );

            // 1. 삭제 (Delete)
            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                ApiParams entity = em.find(ApiParams.class, id);
                if (entity != null) {
                    em.remove(entity);
                }
                continue;
            }

            // 2. 신규 등록 (Create)
            if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                ApiParams entity = ApiParams.builder()
                        .trCoCd(dto.getTrCoCd().trim())
                        .grCd(dto.getGrCd().trim())
                        .scd(dto.getScd().trim())
                        .company(dto.getCompany().trim())
                        .snm(dto.getSnm())
                        .url(dto.getUrl())
                        .headers(dto.getHeaders())
                        .queryparams(dto.getQueryparams())
                        .tablename(dto.getTablename())
                        .subtable(dto.getSubtable())
                        .keyValue(dto.getKeyValue())
                        .subKeyValue(dto.getSubKeyValue())
                        .comments(dto.getComments())
                        .qValue(dto.getQValue())
                        .build();
                em.persist(entity);
                continue;
            }

            // 3. 수정 (Update - Dirty Checking 자동 반영, 규정 01-2 & 01-3)
            if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                ApiParams entity = em.find(ApiParams.class, id);
                if (entity != null) {
                    entity.setSnm(dto.getSnm());
                    entity.setUrl(dto.getUrl());
                    entity.setHeaders(dto.getHeaders());
                    entity.setQueryparams(dto.getQueryparams());
                    entity.setTablename(dto.getTablename());
                    entity.setSubtable(dto.getSubtable());
                    entity.setKeyValue(dto.getKeyValue());
                    entity.setSubKeyValue(dto.getSubKeyValue());
                    entity.setComments(dto.getComments());
                    entity.setQValue(dto.getQValue());
                }
            }
        }
    }

    /**
     * API_Q 요청 레코드 생성 (w_api_params.srw mle_q_value::doubleclicked 연동)
     */
    @Transactional
    public void createApiQRequest(ApiParamsDto dto) {
        if (dto == null) return;
        apiParamsMapper.insertApiQRequest(
                dto.getCompany() != null ? dto.getCompany().trim() : "",
                dto.getUrl() != null ? dto.getUrl().trim() : "",
                dto.getHeaders() != null ? dto.getHeaders().trim() : "",
                dto.getQValue() != null ? dto.getQValue().trim() : (dto.getQueryparams() != null ? dto.getQueryparams().trim() : ""),
                dto.getTablename() != null ? dto.getTablename().trim() : "",
                dto.getSubtable() != null ? dto.getSubtable().trim() : "",
                dto.getKeyValue() != null ? dto.getKeyValue().trim() : "",
                dto.getSubKeyValue() != null ? dto.getSubKeyValue().trim() : ""
        );
    }
}
