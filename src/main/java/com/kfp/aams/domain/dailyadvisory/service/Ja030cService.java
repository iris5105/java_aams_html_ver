package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja030cDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja030cMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

/**
 * Service for w_ja030c (채권 매매등록)
 * - Multi-table query on SCT0CG + SZM0IA + SCM0CJ via MyBatis (Guideline 4)
 * - Strictly adheres to Guideline 1 (no default value fallback)
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja030cService {

    private final Ja030cMapper ja030cMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja030cQueryDslRepository ja030cQueryDslRepository;

    public List<Ja030cDto> getJa030cList(String corpGr, String trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) {
            return Collections.emptyList();
        }
        return ja030cMapper.selectJa030cList(corpGr.trim(), trYmd.trim());
    }

    /**
     * Retrieve Available Dates for Calendar Highlighting (w_ja030c.srw / dw_c::ue_getdate / SCT0CG)
     */
    public List<String> getDates(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja030cMapper.selectJa030cDates(corpGr.trim());
    }

    /**
     * PB 채번 로직: 다음 순번 조회
     */
    public java.math.BigDecimal getNextSeqNo(String corpGr, String trCd, String trYmd, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) {
            return java.math.BigDecimal.ONE;
        }
        String cd = (trCd != null && !trCd.isBlank()) ? trCd : "J15";
        return ja030cQueryDslRepository.selectNextSeqNo(corpGr.trim(), cd.trim(), trYmd.trim(), fundCd);
    }

    /**
     * PB itemchanged(fund_cd): 운용회사(tr_co_cd) 자동 조회
     */
    public String getTrCoCd(String corpGr, String fundCd) {
        if (corpGr == null || corpGr.isBlank() || fundCd == null || fundCd.isBlank()) {
            return null;
        }
        return ja030cQueryDslRepository.selectTrCoCd(corpGr.trim(), fundCd.trim());
    }

    /**
     * 채권 매매등록 저장 (JPA EntityManager CUD)
     */
    @Transactional
    public int saveJa030c(com.kfp.aams.domain.dailyadvisory.dto.Ja030cSaveRequestDto requestDto) {
        if (requestDto == null || requestDto.getItems() == null || requestDto.getItems().isEmpty()) {
            return 0;
        }

        String corpGr = requestDto.getCorpGr();
        String trYmd = requestDto.getTrYmd();
        String trCd = requestDto.getTrCd();
        if (trCd == null || trCd.isBlank()) {
            trCd = "J15";
        }

        int affected = 0;

        // 0. 삭제 선행 처리
        if (requestDto.getDeletedList() != null) {
            for (Ja030cDto del : requestDto.getDeletedList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) del.setCorpGr(corpGr);
                if (del.getTrYmd() == null || del.getTrYmd().isBlank()) del.setTrYmd(trYmd);
                if (del.getTrCd() == null || del.getTrCd().isBlank()) del.setTrCd(trCd);
                ja030cQueryDslRepository.deleteSct0cg(del);
                affected++;
            }
        }

        if (requestDto.getItems() != null) {
            for (Ja030cDto item : requestDto.getItems()) {
            if (item.getCorpGr() == null || item.getCorpGr().isBlank()) {
                item.setCorpGr(corpGr);
            }
            if (item.getTrYmd() == null || item.getTrYmd().isBlank()) {
                item.setTrYmd(trYmd);
            }
            if (item.getTrCd() == null || item.getTrCd().isBlank()) {
                item.setTrCd(trCd);
            }

            if (Boolean.TRUE.equals(item.getIsNew())) {
                if (item.getSeqNo() == null || item.getSeqNo().compareTo(java.math.BigDecimal.ZERO) <= 0) {
                    java.math.BigDecimal nextSeq = ja030cQueryDslRepository.selectNextSeqNo(
                            item.getCorpGr(), item.getTrCd(), item.getTrYmd(), item.getFundCd());
                    item.setSeqNo(nextSeq);
                }
                if (item.getPgCd() == null || item.getPgCd().isBlank()) {
                    item.setPgCd("0211");
                }
                if (item.getBuyDate() == null || item.getBuyDate().isBlank()) {
                    item.setBuyDate(item.getTrYmd().replace("-", ""));
                }
                if (item.getSudoYmd() == null || item.getSudoYmd().isBlank()) {
                    item.setSudoYmd(item.getTrYmd());
                }
                ja030cQueryDslRepository.insertSct0cg(item);
                affected++;
            } else if (Boolean.TRUE.equals(item.getIsUpdated())) {
                ja030cQueryDslRepository.updateSct0cg(item);
                affected++;
            }
        }
    }
    return affected;
}
}
