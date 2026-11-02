package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020eDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja020eMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja020eService {

    private final Ja020eMapper mapper;
    private final WorkDateService workDateService;

    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * w_ja020e.srw wue_retrieve 명세:
     * - trArg = '1' (발행처별): balhCo = 입력값(또는 '%'), krakYmd = null, chengYmd = null
     * - trArg = '2' (권리락일별): balhCo = '%', krakYmd = 입력값, chengYmd = null
     * - trArg = '3' (청약일별): balhCo = '%', krakYmd = null, chengYmd = 입력값
     */
    public List<Ja020eDto> getList(String corpGr, String trArg, String balhCo, LocalDate krakYmd, LocalDate chengYmd) {
        if (corpGr == null || corpGr.isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        String arg = (trArg != null && !trArg.isBlank()) ? trArg.trim() : "1";
        String targetBalhCo = "%";
        LocalDate targetKrakYmd = null;
        LocalDate targetChengYmd = null;

        if ("1".equals(arg)) {
            targetBalhCo = (balhCo != null && !balhCo.isBlank()) ? balhCo.trim() : "%";
        } else if ("2".equals(arg)) {
            targetKrakYmd = krakYmd;
        } else if ("3".equals(arg)) {
            targetChengYmd = chengYmd;
        }

        return mapper.selectList(corpGr.trim(), targetBalhCo, targetKrakYmd, targetChengYmd);
    }
}

