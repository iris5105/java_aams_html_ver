package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Shm0hjMasterDto;
import com.kfp.aams.domain.dailyadvisory.entity.Shm0hj;
import com.kfp.aams.domain.dailyadvisory.entity.Shm0hjId;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * JPA Repository for w_shm0hj (현금 매입(종목)등록)
 * - Key sequencing, procedure execution, and C/U/D operations on SHM0HJ & SHT0HG via Pure JPA Entity & JPQL
 */
@Repository
@RequiredArgsConstructor
public class Shm0hjQueryDslRepository {

    private final EntityManager em;

    /**
     * PowerBuilder itemchanged_next 종목코드 채번:
     * ls_jm_cd = 'KR9' + ls_yy + ls_mm + dd + ls_cd + '___'
     * SELECT NVL(MAX(SUBSTR(JM_CD,10,2)),0) + 1 FROM SHM0HJ WHERE corp_gr = :corpGr AND jm_cd LIKE :ls_jm_cd
     */
    public String getNextJmCd(String corpGr, LocalDate balhYmd, String cashCd) {
        LocalDate date = (balhYmd != null) ? balhYmd : LocalDate.now();
        String yyyy = String.format("%04d", date.getYear());
        String mm = String.format("%02d", date.getMonthValue());
        String dd = String.format("%02d", date.getDayOfMonth());

        String yyCode = getIdDae("Y", yyyy);
        String mmCode = getIdDae("M", mm);
        String code = (cashCd != null && !cashCd.isBlank() && !"%".equals(cashCd)) ? cashCd.trim() : "ZS";

        String prefixPattern = "KR9" + yyCode + mmCode + dd + code + "%";

        List<String> list = em.createQuery(
                "SELECT COALESCE(MAX(SUBSTRING(h.jmCd, 10, 2)), '0') " +
                        "  FROM Shm0hj h " +
                        " WHERE h.corpGr = :corpGr AND h.jmCd LIKE :prefix", String.class)
                .setParameter("corpGr", corpGr.trim())
                .setParameter("prefix", prefixPattern)
                .getResultList();

        int nextSeq = 1;
        if (list != null && !list.isEmpty() && list.get(0) != null) {
            try {
                nextSeq = Integer.parseInt(list.get(0).trim()) + 1;
            } catch (NumberFormatException ignored) {}
        }

        String base9 = "KR9" + yyCode + mmCode + dd + code;
        return base9 + String.format("%02d", nextSeq);
    }

    private String getIdDae(String type, String val) {
        int v = Integer.parseInt(val);
        if ("Y".equalsIgnoreCase(type)) {
            int lastDigit = v % 10;
            return String.valueOf(lastDigit);
        } else if ("M".equalsIgnoreCase(type)) {
            if (v <= 9) return String.valueOf(v);
            if (v == 10) return "A";
            if (v == 11) return "B";
            if (v == 12) return "C";
        }
        return val;
    }

    /**
     * Procedure SR_SHJ0IG call via JPA StoredProcedureQuery
     */
    public void callSrShj0ig(String corpGr, String jmCd, String pDel) {
        try {
            StoredProcedureQuery query = em.createStoredProcedureQuery("KFP.SR_SHJ0IG");
            query.registerStoredProcedureParameter("p_corp_gr", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_jm_cd", String.class, ParameterMode.IN);
            query.registerStoredProcedureParameter("p_del", String.class, ParameterMode.IN);

            query.setParameter("p_corp_gr", corpGr.trim());
            query.setParameter("p_jm_cd", jmCd.trim());
            query.setParameter("p_del", pDel != null ? pDel.trim() : "ok");

            query.execute();
        } catch (Exception e) {
            // fallback if parameter names differ
            try {
                StoredProcedureQuery query = em.createStoredProcedureQuery("KFP.SR_SHJ0IG");
                query.registerStoredProcedureParameter(1, String.class, ParameterMode.IN);
                query.registerStoredProcedureParameter(2, String.class, ParameterMode.IN);
                query.registerStoredProcedureParameter(3, String.class, ParameterMode.IN);

                query.setParameter(1, corpGr.trim());
                query.setParameter(2, jmCd.trim());
                query.setParameter(3, pDel != null ? pDel.trim() : "ok");

                query.execute();
            } catch (Exception ignored) {}
        }
    }

    /**
     * Delete SHT0HG on row deletion (PB updateend)
     */
    public void deleteSht0hg(String corpGr, String jmCd) {
        em.createQuery("DELETE FROM Sht0hg g WHERE g.corpGr = :corpGr AND g.jmCd = :jmCd")
                .setParameter("corpGr", corpGr.trim())
                .setParameter("jmCd", jmCd.trim())
                .executeUpdate();
    }

    /**
     * Delete SHM0HJ
     */
    public void deleteShm0hj(String corpGr, String jmCd) {
        deleteSht0hg(corpGr, jmCd);
        Shm0hjId id = new Shm0hjId(corpGr.trim(), jmCd.trim());
        Shm0hj entity = em.find(Shm0hj.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    /**
     * Insert SHM0HJ
     */
    public void insertShm0hj(Shm0hjMasterDto dto) {
        BigDecimal pyom = dto.getPyomIyulPer() != null ? dto.getPyomIyulPer().divide(BigDecimal.valueOf(100)) : dto.getPyomIyul();
        BigDecimal suik = dto.getMeibSuikRtPer() != null ? dto.getMeibSuikRtPer().divide(BigDecimal.valueOf(100)) : dto.getMeibSuikRt();

        Shm0hj entity = Shm0hj.builder()
                .corpGr(dto.getCorpGr())
                .jmCd(dto.getJmCd())
                .fundCd(dto.getFundCd())
                .cdJigubGb(dto.getCdJigubGb() != null ? dto.getCdJigubGb() : "1")
                .aekm(dto.getAekm() != null ? dto.getAekm() : BigDecimal.ZERO)
                .balhYmd(dto.getBalhYmd())
                .cashCd(dto.getCashCd())
                .chuiAek(dto.getChuiAek() != null ? dto.getChuiAek() : BigDecimal.ZERO)
                .hjNm(dto.getHjNm())
                .meibYmd(dto.getMeibYmd())
                .pyomIyul(pyom != null ? pyom : BigDecimal.ZERO)
                .afIjaYmd(dto.getAfIjaYmd())
                .bojngGb(dto.getBojngGb())
                .nowIjaHoicha(dto.getNowIjaHoicha() != null ? dto.getNowIjaHoicha() : BigDecimal.ZERO)
                .sanghwAek(dto.getSanghwAek() != null ? dto.getSanghwAek() : BigDecimal.ZERO)
                .sanghwYmd(dto.getSanghwYmd())
                .sunhuGb(dto.getSunhuGb() != null ? dto.getSunhuGb() : "1")
                .yyIjaHoicha(dto.getYyIjaHoicha() != null ? dto.getYyIjaHoicha() : BigDecimal.ONE)
                .ijaYySu(dto.getIjaYySu() != null ? dto.getIjaYySu() : BigDecimal.ONE)
                .meibMkGb(dto.getMeibMkGb() != null ? dto.getMeibMkGb() : "1")
                .meibSuikRt(suik != null ? suik : BigDecimal.ZERO)
                .totIjaGugan(dto.getTotIjaGugan() != null ? dto.getTotIjaGugan() : BigDecimal.ONE)
                .offerCoCd(dto.getOfferCoCd())
                .giupGyumo(dto.getGiupGyumo())
                .trAek(dto.getTrAek() != null ? dto.getTrAek() : BigDecimal.ZERO)
                .sunhuTaxGb(dto.getSunhuTaxGb() != null ? dto.getSunhuTaxGb() : "1")
                .taxOfferGb(dto.getTaxOfferGb() != null ? dto.getTaxOfferGb() : "2")
                .daeyeoGb(dto.getDaeyeoGb() != null ? dto.getDaeyeoGb() : "0")
                .brokerCd(dto.getBrokerCd())
                .susuGa(dto.getSusuGa() != null ? dto.getSusuGa() : BigDecimal.ZERO)
                .bojngCo(dto.getBojngCo())
                .sungCost(dto.getSungCost() != null ? dto.getSungCost() : BigDecimal.ZERO)
                .opYmd(dto.getOpYmd())
                .ksdJmCd(dto.getKsdJmCd())
                .seqNo(dto.getSeqNo() != null ? dto.getSeqNo() : BigDecimal.ZERO)
                .susu09900(dto.getSusu09900() != null ? dto.getSusu09900() : BigDecimal.ZERO)
                .ksdJm5(dto.getKsdJm5())
                .ksdJm8(dto.getKsdJm8())
                .pgCd(dto.getPgCd())
                .build();

        em.persist(entity);

        // PB updateend: call SR_SHJ0IG
        try {
            callSrShj0ig(dto.getCorpGr(), dto.getJmCd(), "ok");
        } catch (Exception ignored) {}
    }

    /**
     * Update SHM0HJ via pure JPA dirty checking
     */
    public void updateShm0hj(Shm0hjMasterDto dto) {
        Shm0hjId id = new Shm0hjId(dto.getCorpGr().trim(), dto.getJmCd().trim());
        Shm0hj entity = em.find(Shm0hj.class, id);
        if (entity != null) {
            BigDecimal pyom = dto.getPyomIyulPer() != null ? dto.getPyomIyulPer().divide(BigDecimal.valueOf(100)) : dto.getPyomIyul();
            BigDecimal suik = dto.getMeibSuikRtPer() != null ? dto.getMeibSuikRtPer().divide(BigDecimal.valueOf(100)) : dto.getMeibSuikRt();

            entity.setFundCd(dto.getFundCd());
            if (dto.getCdJigubGb() != null) entity.setCdJigubGb(dto.getCdJigubGb());
            entity.setAekm(dto.getAekm() != null ? dto.getAekm() : BigDecimal.ZERO);
            entity.setBalhYmd(dto.getBalhYmd());
            entity.setCashCd(dto.getCashCd());
            entity.setChuiAek(dto.getChuiAek() != null ? dto.getChuiAek() : BigDecimal.ZERO);
            entity.setHjNm(dto.getHjNm());
            entity.setMeibYmd(dto.getMeibYmd());
            if (pyom != null) entity.setPyomIyul(pyom);
            entity.setAfIjaYmd(dto.getAfIjaYmd());
            entity.setBojngGb(dto.getBojngGb());
            if (dto.getNowIjaHoicha() != null) entity.setNowIjaHoicha(dto.getNowIjaHoicha());
            entity.setSanghwAek(dto.getSanghwAek() != null ? dto.getSanghwAek() : BigDecimal.ZERO);
            entity.setSanghwYmd(dto.getSanghwYmd());
            if (dto.getSunhuGb() != null) entity.setSunhuGb(dto.getSunhuGb());
            if (dto.getYyIjaHoicha() != null) entity.setYyIjaHoicha(dto.getYyIjaHoicha());
            if (dto.getIjaYySu() != null) entity.setIjaYySu(dto.getIjaYySu());
            if (dto.getMeibMkGb() != null) entity.setMeibMkGb(dto.getMeibMkGb());
            if (suik != null) entity.setMeibSuikRt(suik);
            if (dto.getTotIjaGugan() != null) entity.setTotIjaGugan(dto.getTotIjaGugan());
            entity.setOfferCoCd(dto.getOfferCoCd());
            entity.setGiupGyumo(dto.getGiupGyumo());
            entity.setTrAek(dto.getTrAek() != null ? dto.getTrAek() : BigDecimal.ZERO);
            if (dto.getSunhuTaxGb() != null) entity.setSunhuTaxGb(dto.getSunhuTaxGb());
            if (dto.getTaxOfferGb() != null) entity.setTaxOfferGb(dto.getTaxOfferGb());
            if (dto.getDaeyeoGb() != null) entity.setDaeyeoGb(dto.getDaeyeoGb());
            entity.setBrokerCd(dto.getBrokerCd());
            entity.setSusuGa(dto.getSusuGa() != null ? dto.getSusuGa() : BigDecimal.ZERO);
            entity.setBojngCo(dto.getBojngCo());
            entity.setSungCost(dto.getSungCost() != null ? dto.getSungCost() : BigDecimal.ZERO);
            entity.setOpYmd(dto.getOpYmd());
            entity.setKsdJmCd(dto.getKsdJmCd());
            if (dto.getSeqNo() != null) entity.setSeqNo(dto.getSeqNo());
            if (dto.getSusu09900() != null) entity.setSusu09900(dto.getSusu09900());
            entity.setKsdJm5(dto.getKsdJm5());
            entity.setKsdJm8(dto.getKsdJm8());
            entity.setPgCd(dto.getPgCd());
        }

        // PB updateend: call SR_SHJ0IG
        try {
            callSrShj0ig(dto.getCorpGr(), dto.getJmCd(), "ok");
        } catch (Exception ignored) {}
    }
}
