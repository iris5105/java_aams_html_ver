package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja990dDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sjm0jj;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt1tg;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt1tgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * JPA Repository for w_ja990d (종목기본정보/수정)
 * - SJM0JJ C/U/D 및 SJT1TG 연동 (순수 JPA Entity 기반)
 */
@Repository
@RequiredArgsConstructor
public class Ja990dQueryDslRepository {

    private final EntityManager em;

    public int checkJmCdExists(String jmCd) {
        Long count = em.createQuery("SELECT COUNT(j) FROM Sjm0jj j WHERE j.jmCd = :jmCd", Long.class)
                .setParameter("jmCd", jmCd)
                .getSingleResult();
        return count != null ? count.intValue() : 0;
    }

    public void insertJm(Ja990dDto item) {
        Sjm0jj entity = Sjm0jj.builder()
                .jmCd(item.getJmCd())
                .koscomCd(item.getKoscomCd())
                .jjFnm(item.getJjFnm())
                .jjNm(item.getJjNm())
                .jjEnm(item.getJjEnm())
                .balhCo(item.getBalhCo())
                .woosIlbanGb(item.getWoosIlbanGb())
                .chgGb(item.getChgGb())
                .newOldGb(item.getNewOldGb())
                .dancGb(item.getDancGb())
                .balhGa(item.getBalhGa())
                .kweonriYmd(item.getKweonriYmd())
                .sangjYmd(item.getSangjYmd())
                .sangjJusu(item.getSangjJusu())
                .upjCd(item.getUpjCd())
                .createdYmd(item.getCreatedYmd() != null ? item.getCreatedYmd() : LocalDateTime.now())
                .delYn(item.getDelYn() != null ? item.getDelYn() : "0")
                .capsize(item.getCapsize())
                .kospigubun(item.getKospigubun())
                .woosVoteYmd(item.getWoosVoteYmd())
                .under(item.getUnder())
                .baedGisanYmd(item.getBaedGisanYmd())
                .isinCd(item.getIsinCd())
                .a0231(item.getA0231())
                .deposit(item.getDeposit())
                .chgRt(item.getChgRt())
                .build();

        em.persist(entity);

        // 파워빌더 updatestart: 신규 등록된 종목의 koscom_cd가 SJT1TG에 없으면 자동 생성
        if (item.getKoscomCd() != null && !item.getKoscomCd().isBlank()) {
            ensureSjt1tg(item.getKoscomCd());
        }
    }

    public int updateJm(Ja990dDto item) {
        Sjm0jj entity = em.find(Sjm0jj.class, item.getJmCd());
        if (entity != null) {
            entity.setKoscomCd(item.getKoscomCd());
            entity.setJjFnm(item.getJjFnm());
            entity.setJjNm(item.getJjNm());
            entity.setJjEnm(item.getJjEnm());
            entity.setBalhCo(item.getBalhCo());
            entity.setWoosIlbanGb(item.getWoosIlbanGb());
            entity.setChgGb(item.getChgGb());
            entity.setNewOldGb(item.getNewOldGb());
            entity.setDancGb(item.getDancGb());
            entity.setBalhGa(item.getBalhGa());
            entity.setKweonriYmd(item.getKweonriYmd());
            entity.setSangjYmd(item.getSangjYmd());
            entity.setSangjJusu(item.getSangjJusu());
            entity.setUpjCd(item.getUpjCd());
            entity.setDelYn(item.getDelYn() != null ? item.getDelYn() : "0");
            entity.setCapsize(item.getCapsize());
            entity.setKospigubun(item.getKospigubun());
            entity.setWoosVoteYmd(item.getWoosVoteYmd());
            entity.setUnder(item.getUnder());
            entity.setBaedGisanYmd(item.getBaedGisanYmd());
            entity.setIsinCd(item.getIsinCd());
            entity.setA0231(item.getA0231());
            entity.setDeposit(item.getDeposit());
            entity.setChgRt(item.getChgRt());
            return 1;
        }
        return 0;
    }

    public int deleteJm(String jmCd) {
        Sjm0jj entity = em.find(Sjm0jj.class, jmCd);
        if (entity != null) {
            em.remove(entity);
            return 1;
        }
        return 0;
    }

    private void ensureSjt1tg(String koscomCd) {
        try {
            LocalDate today = LocalDate.now();
            Sjt1tgId id = new Sjt1tgId(koscomCd.trim(), today);
            Sjt1tg existing = em.find(Sjt1tg.class, id);
            if (existing == null) {
                Sjt1tg entity = Sjt1tg.builder()
                        .koscomCd(koscomCd.trim())
                        .ymd(today)
                        .modDt(LocalDateTime.now())
                        .build();
                em.persist(entity);
            }
        } catch (Exception ignored) {
            // SJT1TG 자동 생성 실패 시에도 메인 등록은 유지
        }
    }
}
