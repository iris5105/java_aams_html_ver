package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020rDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020rMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020rSaveDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja020rMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja020rService {

    private final Ja020rMapper ja020rMapper;
    private final WorkDateService workDateService;

    /**
     * 회사그룹별 기준 작업일자 조회
     */
    @Transactional(readOnly = true)
    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * 마스터 계좌 목록 조회 (d_ja020r1)
     */
    @Transactional(readOnly = true)
    public List<Ja020rMasterDto> getMasterList(String corpGr, String ymd, String dw) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        String dwType = (dw != null && !dw.isBlank()) ? dw : "d_ja020r2c";
        return ja020rMapper.selectMasterList(corpGr.trim(), ymd.trim(), dwType.trim());
    }

    /**
     * 디테일 유가증권 취득액 목록 조회 (d_ja020r2c, d_ja020r2h, d_ja020r2j)
     */
    @Transactional(readOnly = true)
    public List<Ja020rDetailDto> getDetailList(String corpGr, String ymd, String fundCd, String dw) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank() || fundCd == null || fundCd.isBlank()) {
            return Collections.emptyList();
        }
        String dwType = (dw != null && !dw.isBlank()) ? dw.trim() : "d_ja020r2c";

        if ("d_ja020r2h".equals(dwType)) {
            return ja020rMapper.selectCashDetailList(corpGr.trim(), ymd.trim(), fundCd.trim());
        } else if ("d_ja020r2j".equals(dwType)) {
            return ja020rMapper.selectStockDetailList(corpGr.trim(), ymd.trim(), fundCd.trim());
        } else {
            // 기본값 d_ja020r2c (채권)
            return ja020rMapper.selectBondDetailList(corpGr.trim(), ymd.trim(), fundCd.trim());
        }
    }

    /**
     * 수정취득액 저장 처리
     */
    @Transactional
    public void save(Ja020rSaveDto saveDto, String loginUser) {
        if (saveDto == null || saveDto.getUpdatedList() == null || saveDto.getUpdatedList().isEmpty()) {
            return;
        }

        String dwType = saveDto.getDwType();
        if (dwType == null || dwType.isBlank()) {
            dwType = "d_ja020r2c";
        }

        for (Ja020rDetailDto item : saveDto.getUpdatedList()) {
            if (item.getCorpGr() == null || item.getCorpGr().isBlank()) {
                item.setCorpGr(saveDto.getCorpGr());
            }
            if (item.getYmd() == null || item.getYmd().isBlank()) {
                item.setYmd(saveDto.getYmd());
            }

            // 파워빌더 itemchanged 로직: alter_aek == 0 이면 ip_user = null, 아니면 loginUser
            BigDecimal alterAek = item.getAlterAek();
            if (alterAek == null || alterAek.compareTo(BigDecimal.ZERO) == 0) {
                item.setIpUser(null);
            } else {
                item.setIpUser((loginUser != null && !loginUser.isBlank()) ? loginUser : "admin");
            }

            if ("d_ja020r2h".equals(dwType)) {
                ja020rMapper.updateCashAlterAek(item);
            } else if ("d_ja020r2j".equals(dwType)) {
                ja020rMapper.updateStockAlterAek(item);
            } else {
                ja020rMapper.updateBondAlterAek(item);
            }
        }
    }
}
