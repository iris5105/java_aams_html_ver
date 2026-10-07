package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010bDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010bIoDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010bMasterDto;
import com.kfp.aams.domain.dailyadvisory.entity.*;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * JPA Repository for w_ja010b (계좌계약정보관리)
 * - C/U/D persistence on SZM0IA, SZM0GI, SZT0IO via Pure JPA Entity & JPQL
 * - PB dw_list::ue_insertstart script-based fund_cd key generation
 */
@Repository
@RequiredArgsConstructor
public class Ja010bQueryDslRepository {

    private final EntityManager em;

    /**
     * PB w_ja010b.srw dw_list::ue_insertstart 기반 펀드코드 채번:
     * ll_fund = dec(string(idt_workdate,'yy')) * 100
     * SELECT NVL(MAX (fund_cd),:ll_fund) + 1 INTO :ll_fund FROM szm0ia WHERE
     * corp_gr = :corp_gr AND fund_cd > TO_CHAR(:ll_fund)
     */
    public String getNextFundCd(String corpGr) {
        if (corpGr == null || corpGr.isBlank())
            return "0001";
        int yyBase = (LocalDate.now().getYear() % 100) * 100;
        String baseStr = String.valueOf(yyBase);
        try {
            List<String> list = em.createQuery(
                    "SELECT m.fundCd FROM Szm0ia m " +
                            " WHERE m.corpGr = :corpGr " +
                            "   AND m.fundCd > :baseStr " +
                            " ORDER BY m.fundCd DESC",
                    String.class)
                    .setParameter("corpGr", corpGr.trim())
                    .setParameter("baseStr", baseStr)
                    .setMaxResults(1)
                    .getResultList();

            if (list != null && !list.isEmpty()) {
                String maxCd = list.get(0).trim();
                long val = Long.parseLong(maxCd) + 1;
                return String.format("%04d", val);
            }
        } catch (Exception ignored) {
        }
        return String.format("%04d", yyBase + 1);
    }

    public void insertMaster(Ja010bMasterDto m) {
        String encAcctNo = encrypt(m.getAcctNo());

        Szm0ia entity = Szm0ia.builder()
                .corpGr(m.getCorpGr())
                .fundCd(m.getFundCd())
                .fundNm(m.getFundNm())
                .typeGb(m.getTypeGb())
                .fstSeoljYmd(m.getFstSeoljYmd())
                .sintakGigan(m.getSintakGigan())
                .bfGyulYmd(m.getBfGyulYmd())
                .afGyulYmd(m.getAfGyulYmd())
                .preBasic(m.getPreBasic())
                .basicPer(m.getBasicPer())
                .bmPer(m.getBmPer())
                .successPer(m.getSuccessPer())
                .seriesGb(m.getSeriesGb())
                .targetJasan(m.getTargetJasan())
                .gyulGi(m.getGyulGi())
                .haejiGb(m.getHaejiGb())
                .haejiYmd(m.getHaejiYmd())
                .reSeoljYear(m.getReSeoljYear())
                .reSeoljAek(m.getReSeoljAek())
                .mgCd(m.getMgCd())
                .susuRt(m.getSusuRt())
                .email1(m.getEmail1())
                .reSeoljYmd(m.getReSeoljYmd())
                .unyongSabun(m.getUnyongSabun())
                .orderSend(m.getOrderSend())
                .expenseYn(m.getExpenseYn())
                .aliasCode(m.getAliasCode())
                .specialNote(m.getSpecialNote())
                .encAcctNo(encAcctNo)
                .build();

        em.persist(entity);
    }

    public void updateMaster(Ja010bMasterDto m) {
        Szm0iaId id = new Szm0iaId(m.getCorpGr(), m.getFundCd());
        Szm0ia entity = em.find(Szm0ia.class, id);
        if (entity != null) {
            entity.setFundNm(m.getFundNm());
            entity.setTypeGb(m.getTypeGb());
            entity.setFstSeoljYmd(m.getFstSeoljYmd());
            entity.setSintakGigan(m.getSintakGigan());
            entity.setBfGyulYmd(m.getBfGyulYmd());
            entity.setAfGyulYmd(m.getAfGyulYmd());
            entity.setPreBasic(m.getPreBasic());
            entity.setBasicPer(m.getBasicPer());
            entity.setBmPer(m.getBmPer());
            entity.setSuccessPer(m.getSuccessPer());
            entity.setSeriesGb(m.getSeriesGb());
            entity.setTargetJasan(m.getTargetJasan());
            entity.setGyulGi(m.getGyulGi());
            entity.setHaejiGb(m.getHaejiGb());
            entity.setHaejiYmd(m.getHaejiYmd());
            entity.setReSeoljYear(m.getReSeoljYear());
            entity.setReSeoljAek(m.getReSeoljAek());
            entity.setMgCd(m.getMgCd());
            entity.setSusuRt(m.getSusuRt());
            entity.setEmail1(m.getEmail1());
            entity.setReSeoljYmd(m.getReSeoljYmd());
            entity.setUnyongSabun(m.getUnyongSabun());
            entity.setExpenseYn(m.getExpenseYn());
            entity.setSpecialNote(m.getSpecialNote());

            if (m.getAcctNo() != null && !m.getAcctNo().isBlank()) {
                entity.setEncAcctNo(encrypt(m.getAcctNo()));
            }
        }
    }

    public void insertDetail(Ja010bDetailDto d) {
        Szm0gi entity = Szm0gi.builder()
                .corpGr(d.getCorpGr())
                .fundCd(d.getFundCd())
                .gyulGi(d.getGyulGi())
                .bfGyulYmd(d.getBfGyulYmd())
                .afGyulYmd(d.getAfGyulYmd())
                .ilsu(d.getIlsu())
                .giSonikAek(d.getGiSonikAek())
                .wmSeoljAek(d.getWmSeoljAek())
                .wmDt(d.getWmDt())
                .haejiYmd(d.getHaejiYmd())
                .inchulYmd(d.getInchulYmd())
                .inAek(d.getInAek())
                .distCalc(d.getDistCalc())
                .afGijun(d.getAfGijun())
                .build();
        em.persist(entity);
    }

    public void updateDetail(Ja010bDetailDto d) {
        Szm0giId id = new Szm0giId(d.getCorpGr(), d.getFundCd(), d.getBfGyulYmd());
        Szm0gi entity = em.find(Szm0gi.class, id);
        if (entity != null) {
            entity.setAfGyulYmd(d.getAfGyulYmd());
            entity.setIlsu(d.getIlsu());
            entity.setGiSonikAek(d.getGiSonikAek());
            entity.setWmSeoljAek(d.getWmSeoljAek());
            entity.setWmDt(d.getWmDt());
            entity.setHaejiYmd(d.getHaejiYmd());
            entity.setInchulYmd(d.getInchulYmd());
            entity.setInAek(d.getInAek());
            entity.setDistCalc(d.getDistCalc());
            entity.setAfGijun(d.getAfGijun());
        }
    }

    public void deleteDetail(Ja010bDetailDto d) {
        Szm0giId id = new Szm0giId(d.getCorpGr(), d.getFundCd(), d.getBfGyulYmd());
        Szm0gi entity = em.find(Szm0gi.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    public void insertIo(Ja010bIoDto io) {
        String safeModUser = truncateModUser(io.getModUser());
        Szt0io entity = Szt0io.builder()
                .corpGr(io.getCorpGr())
                .fundCd(io.getFundCd())
                .trYmd(io.getTrYmd())
                .wonbonAek(io.getWonbonAek())
                .inAek(io.getInAek())
                .outAek(io.getOutAek())
                .giganIlsu(io.getGiganIlsu())
                .passIlsu(io.getPassIlsu())
                .ioJo(io.getIoJo())
                .modDt(LocalDateTime.now())
                .modUser(safeModUser)
                .build();
        em.persist(entity);
    }

    public void updateIo(Ja010bIoDto io) {
        Szt0ioId id = new Szt0ioId(io.getCorpGr(), io.getFundCd(), io.getTrYmd());
        Szt0io entity = em.find(Szt0io.class, id);
        if (entity != null) {
            entity.setWonbonAek(io.getWonbonAek());
            entity.setInAek(io.getInAek());
            entity.setOutAek(io.getOutAek());
            entity.setGiganIlsu(io.getGiganIlsu());
            entity.setPassIlsu(io.getPassIlsu());
            entity.setIoJo(io.getIoJo());
            entity.setModDt(LocalDateTime.now());
            entity.setModUser(truncateModUser(io.getModUser()));
        }
    }

    private String truncateModUser(String modUser) {
        if (modUser == null || modUser.isBlank())
            return "SYSTEM";
        String trimmed = modUser.trim();
        return trimmed.length() > 40 ? trimmed.substring(0, 40) : trimmed;
    }

    public void deleteIo(Ja010bIoDto io) {
        Szt0ioId id = new Szt0ioId(io.getCorpGr(), io.getFundCd(), io.getTrYmd());
        Szt0io entity = em.find(Szt0io.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    public void deleteMaster(Ja010bMasterDto m) {
        if (m == null || m.getCorpGr() == null || m.getFundCd() == null)
            return;
        Szm0iaId id = new Szm0iaId(m.getCorpGr().trim(), m.getFundCd().trim());
        Szm0ia entity = em.find(Szm0ia.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    private String encrypt(String plain) {
        if (plain == null || plain.isBlank())
            return null;
        try {
            return em.createQuery("SELECT function('TO_ENCRYPTS', :plain) FROM Szm0ia m WHERE rownum = 1", String.class)
                    .setParameter("plain", plain.trim())
                    .getSingleResult();
        } catch (Exception e) {
            return (String) em.createNativeQuery("SELECT TO_ENCRYPTS(:plain) FROM DUAL")
                    .setParameter("plain", plain.trim())
                    .getSingleResult();
        }
    }
}
