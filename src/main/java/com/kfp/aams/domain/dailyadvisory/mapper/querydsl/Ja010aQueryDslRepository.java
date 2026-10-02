package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010aDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010aMasterDto;
import com.kfp.aams.domain.dailyadvisory.entity.QSzx0ab;
import com.kfp.aams.domain.dailyadvisory.entity.Szx0ab;
import com.kfp.aams.home.entity.QSzx0aa;
import com.kfp.aams.home.entity.Szx0aa;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * QueryDSL Repository for single-table queries on SZX0AA and SZX0AB
 * - d_ja010a1.srd (SZX0AA)
 * - d_ja010a2.srd (SZX0AB)
 * Adheres strictly to Guideline 1 & Guideline 4.
 */
@Repository
@RequiredArgsConstructor
public class Ja010aQueryDslRepository {

    private final JPAQueryFactory queryFactory;
    private final jakarta.persistence.EntityManager em;

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * PB w_ja010a.srw dw_list::ue_insertstart 스크립트 기반 회사코드 채번:
     * ls_corp_gr = string (idt_workdate,'yy') + '01'
     * SELECT NVL(max(corp_gr) + 1, :ls_corp_gr) FROM szx0aa t1 WHERE t1.corp_gr >= :ls_corp_gr;
     */
    public String getNextCorpGr() {
        String currentYY01 = java.time.LocalDate.now().format(DateTimeFormatter.ofPattern("yy")) + "01";
        try {
            List<String> list = em.createQuery(
                    "SELECT a.corpGr FROM Szx0aa a WHERE a.corpGr >= :defaultVal ORDER BY a.corpGr DESC", String.class)
                    .setParameter("defaultVal", currentYY01)
                    .setMaxResults(1)
                    .getResultList();
            if (list != null && !list.isEmpty()) {
                long val = Long.parseLong(list.get(0).trim()) + 1;
                return String.valueOf(val);
            }
            return currentYY01;
        } catch (Exception e) {
            return currentYY01;
        }
    }

    public void saveMaster(Ja010aMasterDto master) {
        if (master == null || master.getCorpGr() == null || master.getCorpGr().isBlank()) return;
        String corpGr = master.getCorpGr().trim();
        Szx0aa entity = em.find(Szx0aa.class, corpGr);
        if (entity == null) {
            entity = new Szx0aa();
            entity.setCorpGr(corpGr);
        }
        entity.setCompanyName(master.getCompanyName());
        entity.setDepositDd(master.getDepositDd());
        entity.setHyunYmd(master.getHyunYmd());
        entity.setGijungaYmd(master.getGijungaYmd());
        entity.setJunyongYmd(master.getJunyongYmd());
        entity.setIkyongYmd(master.getIkyongYmd());
        entity.setThikyongYmd(master.getThikyongYmd());
        entity.setSymd(master.getSymd());
        entity.setEymd(master.getEymd());
        entity.setCustomerGr(master.getCustomerGr());
        entity.setExpenseYn(master.getExpenseYn());
        entity.setDepositAccount(master.getDepositAccount());
        entity.setBigo(master.getBigo());
        em.merge(entity);
    }

    public void saveDetail(Ja010aDetailDto detail) {
        if (detail == null || detail.getCorpGr() == null || detail.getYmd() == null) return;
        String corpGr = detail.getCorpGr().trim();
        java.time.LocalDate ymd = detail.getYmd();

        com.kfp.aams.domain.dailyadvisory.entity.Szx0abId id = 
            new com.kfp.aams.domain.dailyadvisory.entity.Szx0abId(corpGr, ymd);
        Szx0ab entity = em.find(Szx0ab.class, id);
        if (entity == null) {
            entity = new Szx0ab();
            entity.setCorpGr(corpGr);
            entity.setYmd(ymd);
        }
        entity.setCompanyName(detail.getCompanyName());
        entity.setIdno(detail.getIdno() != null ? detail.getIdno().replaceAll("-", "") : null);
        entity.setContractYmd(detail.getContractYmd());
        entity.setPost(detail.getPost());
        entity.setJuso(detail.getJuso());
        entity.setCeoNm(detail.getCeoNm());
        entity.setTelNo(detail.getTelNo());
        entity.setFaxNo(detail.getFaxNo());
        entity.setEmail(detail.getEmail());
        em.merge(entity);
    }

    public void deleteMaster(Ja010aMasterDto master) {
        if (master == null || master.getCorpGr() == null) return;
        String corpGr = master.getCorpGr().trim();
        QSzx0aa q = QSzx0aa.szx0aa;
        queryFactory.delete(q).where(q.corpGr.eq(corpGr)).execute();
    }

    public void deleteDetail(Ja010aDetailDto detail) {
        if (detail == null || detail.getCorpGr() == null || detail.getYmd() == null) return;
        String corpGr = detail.getCorpGr().trim();
        java.time.LocalDate ymd = detail.getYmd();
        QSzx0ab q = QSzx0ab.szx0ab;
        queryFactory.delete(q).where(q.corpGr.eq(corpGr).and(q.ymd.eq(ymd))).execute();
    }

    public List<Ja010aMasterDto> findMasterList() {
        QSzx0aa q = QSzx0aa.szx0aa;

        List<Szx0aa> entities = queryFactory
                .selectFrom(q)
                .orderBy(q.corpGr.asc())
                .fetch();

        return entities.stream().map(e -> Ja010aMasterDto.builder()
                .corpGr(e.getCorpGr())
                .companyName(e.getCompanyName())
                .hyunYmd(formatDateString(e.getHyunYmd()))
                .gijungaYmd(formatDateString(e.getGijungaYmd()))
                .junyongYmd(formatDateString(e.getJunyongYmd()))
                .ikyongYmd(formatDateString(e.getIkyongYmd()))
                .thikyongYmd(formatDateString(e.getThikyongYmd()))
                .symd(formatDateString(e.getSymd()))
                .eymd(formatDateString(e.getEymd()))
                .depositDd(e.getDepositDd())
                .depositAccount(e.getDepositAccount())
                .bigo(e.getBigo())
                .customerGr(e.getCustomerGr())
                .expenseYn(e.getExpenseYn())
                .pVisible(1)
                .build()
        ).collect(Collectors.toList());
    }

    public List<Ja010aDetailDto> findDetailList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }

        QSzx0ab q = QSzx0ab.szx0ab;

        List<Szx0ab> entities = queryFactory
                .selectFrom(q)
                .where(q.corpGr.eq(corpGr.trim()))
                .orderBy(q.ymd.desc())
                .fetch();

        return entities.stream().map(e -> Ja010aDetailDto.builder()
                .corpGr(e.getCorpGr())
                .ymd(e.getYmd())
                .companyName(e.getCompanyName())
                .idno(e.getIdno())
                .contractYmd(e.getContractYmd())
                .post(e.getPost())
                .juso(e.getJuso())
                .ceoNm(e.getCeoNm())
                .telNo(e.getTelNo())
                .faxNo(e.getFaxNo())
                .email(e.getEmail())
                .pVisible(1)
                .build()
        ).collect(Collectors.toList());
    }

    private String formatDateString(String val) {
        if (val == null || val.isBlank()) return "";
        String text = val.trim();
        if (text.length() >= 10 && (text.charAt(4) == '-' || text.charAt(4) == '/' || text.charAt(4) == '.')) {
            return text.substring(0, 4) + "-" + text.substring(5, 7) + "-" + text.substring(8, 10);
        }
        String digits = text.replaceAll("\\D", "");
        if (digits.length() >= 8) {
            return digits.substring(0, 4) + "-" + digits.substring(4, 6) + "-" + digits.substring(6, 8);
        }
        return text;
    }
}
