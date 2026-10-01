package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja030cDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sct0cg;
import com.kfp.aams.domain.dailyadvisory.entity.Sct0cgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * JPA Repository for w_ja030c (채권 매매등록)
 * - Key sequencing & C/U/D operations on SCT0CG via Pure JPA Entity & JPQL
 */
@Repository
@RequiredArgsConstructor
public class Ja030cQueryDslRepository {

    private final EntityManager em;

    /**
     * PowerBuilder ue_insertstart & itemchanged 채번 로직:
     * SELECT NVL(MAX(seq_no), 0) + 1 FROM SCT0CG WHERE corp_gr = :corp_gr AND tr_cd = :tr_cd AND TRUNC(tr_ymd) = :tr_ymd
     */
    public BigDecimal selectNextSeqNo(String corpGr, String trCd, String trYmd, String fundCd) {
        LocalDate parsedTrYmd = parseLocalDate(trYmd);
        StringBuilder jpql = new StringBuilder(
                "SELECT COALESCE(MAX(c.seqNo), 0) + 1 " +
                        "  FROM Sct0cg c " +
                        " WHERE c.corpGr = :corpGr AND c.trCd = :trCd AND c.trYmd = :trYmd ");
        if (fundCd != null && !fundCd.isBlank()) {
            jpql.append("AND c.fundCd = :fundCd ");
        }

        var query = em.createQuery(jpql.toString(), Number.class)
                .setParameter("corpGr", corpGr)
                .setParameter("trCd", trCd)
                .setParameter("trYmd", parsedTrYmd);
        if (fundCd != null && !fundCd.isBlank()) {
            query.setParameter("fundCd", fundCd.trim());
        }

        Number result = query.getSingleResult();
        if (result != null) {
            return BigDecimal.valueOf(result.longValue());
        }
        return BigDecimal.ONE;
    }

    /**
     * PowerBuilder itemchanged (fund_cd) -> 운용회사(tr_co_cd) 자동 조회:
     * SELECT mg_cd FROM SZM0IA WHERE corp_gr = :corp_gr AND fund_cd = :fund_cd
     */
    public String selectTrCoCd(String corpGr, String fundCd) {
        List<String> list = em.createQuery(
                "SELECT m.mgCd FROM Szm0ia m WHERE m.corpGr = :corpGr AND m.fundCd = :fundCd", String.class)
                .setParameter("corpGr", corpGr)
                .setParameter("fundCd", fundCd.trim())
                .getResultList();
        if (list != null && !list.isEmpty() && list.get(0) != null) {
            return list.get(0).trim();
        }
        return null;
    }

    /**
     * SCT0CG INSERT via pure JPA persist
     */
    public void insertSct0cg(Ja030cDto dto) {
        LocalDate trYmd = parseLocalDate(dto.getTrYmd());
        LocalDate sudoYmd = dto.getSudoYmd() != null && !dto.getSudoYmd().isBlank()
                ? parseLocalDate(dto.getSudoYmd())
                : trYmd;
        String buyDateClean = dto.getBuyDate() != null ? dto.getBuyDate().replaceAll("\\D", "") : "";
        if (buyDateClean.length() < 8 && dto.getTrYmd() != null) {
            buyDateClean = dto.getTrYmd().replaceAll("\\D", "");
        }

        Sct0cg entity = Sct0cg.builder()
                .corpGr(dto.getCorpGr())
                .trYmd(trYmd)
                .trCd(dto.getTrCd())
                .seqNo(dto.getSeqNo())
                .fundCd(dto.getFundCd())
                .jmCd(dto.getJmCd())
                .buyDate(buyDateClean)
                .trCoCd(dto.getTrCoCd())
                .aekm(dto.getAekm() != null ? dto.getAekm() : BigDecimal.ZERO)
                .danga(dto.getDanga() != null ? dto.getDanga() : BigDecimal.ZERO)
                .trAek(dto.getTrAek() != null ? dto.getTrAek() : BigDecimal.ZERO)
                .susu(dto.getSusu() != null ? dto.getSusu() : BigDecimal.ZERO)
                .sudoYmd(sudoYmd)
                .mkSuikRt(dto.getMkSuikRt())
                .pgCd(dto.getPgCd() != null && !dto.getPgCd().isBlank() ? dto.getPgCd() : "0211")
                .jajunGb(dto.getJajunGb())
                .chuiAek(dto.getChuiAek() != null ? dto.getChuiAek() : dto.getTrAek())
                .dangaGb(dto.getDangaGb())
                .jajunSayu(dto.getJajunSayu())
                .ijaAekm(dto.getIjaAekm() != null ? dto.getIjaAekm() : BigDecimal.ZERO)
                .build();

        em.persist(entity);
    }

    /**
     * SCT0CG UPDATE via pure JPA dirty checking
     */
    public void updateSct0cg(Ja030cDto dto) {
        LocalDate trYmd = parseLocalDate(dto.getTrYmd());
        Sct0cgId id = new Sct0cgId(dto.getCorpGr(), trYmd, dto.getTrCd(), dto.getSeqNo());
        Sct0cg entity = em.find(Sct0cg.class, id);
        if (entity != null) {
            LocalDate sudoYmd = dto.getSudoYmd() != null && !dto.getSudoYmd().isBlank()
                    ? parseLocalDate(dto.getSudoYmd())
                    : trYmd;
            String buyDateClean = dto.getBuyDate() != null ? dto.getBuyDate().replaceAll("\\D", "") : "";
            if (buyDateClean.length() < 8 && dto.getTrYmd() != null) {
                buyDateClean = dto.getTrYmd().replaceAll("\\D", "");
            }

            entity.setFundCd(dto.getFundCd());
            entity.setJmCd(dto.getJmCd());
            entity.setBuyDate(buyDateClean);
            entity.setTrCoCd(dto.getTrCoCd());
            entity.setAekm(dto.getAekm() != null ? dto.getAekm() : BigDecimal.ZERO);
            entity.setDanga(dto.getDanga() != null ? dto.getDanga() : BigDecimal.ZERO);
            entity.setTrAek(dto.getTrAek() != null ? dto.getTrAek() : BigDecimal.ZERO);
            entity.setSusu(dto.getSusu() != null ? dto.getSusu() : BigDecimal.ZERO);
            entity.setSudoYmd(sudoYmd);
            entity.setMkSuikRt(dto.getMkSuikRt());
            entity.setPgCd(dto.getPgCd());
            entity.setJajunGb(dto.getJajunGb());
            entity.setChuiAek(dto.getChuiAek() != null ? dto.getChuiAek() : dto.getTrAek());
            entity.setDangaGb(dto.getDangaGb());
            entity.setJajunSayu(dto.getJajunSayu());
            entity.setIjaAekm(dto.getIjaAekm() != null ? dto.getIjaAekm() : BigDecimal.ZERO);
        }
    }

    /**
     * SCT0CG DELETE via pure JPA remove
     */
    public void deleteSct0cg(Ja030cDto dto) {
        LocalDate trYmd = parseLocalDate(dto.getTrYmd());
        Sct0cgId id = new Sct0cgId(dto.getCorpGr(), trYmd, dto.getTrCd(), dto.getSeqNo());
        Sct0cg entity = em.find(Sct0cg.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    private LocalDate parseLocalDate(String text) {
        if (text == null || text.isBlank()) return null;
        String digits = text.replaceAll("\\D", "");
        if (digits.length() == 8) {
            return LocalDate.of(
                    Integer.parseInt(digits.substring(0, 4)),
                    Integer.parseInt(digits.substring(4, 6)),
                    Integer.parseInt(digits.substring(6, 8))
            );
        }
        return LocalDate.parse(text.substring(0, 10).replace('.', '-').replace('/', '-'));
    }
}
