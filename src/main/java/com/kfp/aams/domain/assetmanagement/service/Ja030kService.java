package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030kDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030kSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030kMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * 원리금 상환 명세표 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja030kService {

    private final Ja030kMapper ja030kMapper;

    /**
     * 상환 명세 목록 조회
     * - corpGr == '2402': UZM0SH 기반 조회 (d_ja030k1_2402)
     * - 그 외: UCS0BH + UHM0HP 기반 조회 (d_ja030k1)
     */
    @Transactional(readOnly = true)
    public List<Ja030kDto> getList(String corpGr, String fymd, String tymd) {
        if ("2402".equals(corpGr)) {
            return ja030kMapper.selectList2402(corpGr, fymd, tymd);
        } else {
            return ja030kMapper.selectListGeneral(corpGr, fymd, tymd);
        }
    }

    /**
     * 2402 리셋자산운용 UZM0SH 저장 (수령이자, 세금, 수령액)
     */
    @Transactional
    public int saveList(Ja030kSaveRequest request, String userNm) {
        if (request == null || request.getUpdatedList() == null || request.getUpdatedList().isEmpty()) {
            return 0;
        }

        String corpGr = request.getCorpGr();
        if (!"2402".equals(corpGr)) {
            throw new IllegalStateException("해당 회사는 상환명세 수정 권한이 없습니다.");
        }

        int count = 0;
        for (Ja030kDto item : request.getUpdatedList()) {
            item.setCorpGr(corpGr);
            item.setModUser(userNm);

            // PB dw_list::itemchanged 수령액 계산 로직 보정
            // IF sunhu_gb == '2' THEN sury_aek = aekm + misu_ija - ija_tax
            // ELSE sury_aek = chui_aek + misu_ija - ija_tax
            BigDecimal base = "2".equals(item.getSunhuGb())
                    ? (item.getAekm() != null ? item.getAekm() : BigDecimal.ZERO)
                    : (item.getChuiAek() != null ? item.getChuiAek() : BigDecimal.ZERO);
            BigDecimal misu = item.getMisuIja() != null ? item.getMisuIja() : BigDecimal.ZERO;
            BigDecimal tax = item.getIjaTax() != null ? item.getIjaTax() : (item.getSunnTax() != null ? item.getSunnTax() : BigDecimal.ZERO);
            item.setIjaTax(tax);
            item.setSuryAek(base.add(misu).subtract(tax));

            count += ja030kMapper.updateUzm0sh(item);
        }
        return count;
    }
}

