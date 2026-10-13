package com.kfp.aams.domain.usportfoliomodel.repository;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aPortDto;
import com.kfp.aams.domain.usportfoliomodel.entity.QUspm;
import com.kfp.aams.domain.usportfoliomodel.entity.QUspmPort;
import com.kfp.aams.domain.usportfoliomodel.entity.Uspm;
import com.kfp.aams.domain.usportfoliomodel.entity.UspmId;
import com.kfp.aams.domain.usportfoliomodel.entity.UspmPort;
import com.kfp.aams.domain.usportfoliomodel.entity.UspmPortId;
import com.querydsl.jpa.impl.JPAQueryFactory;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

/**
 * JPA Repository for w_ja032a (포트폴리오 모델 등록)
 * - Single-table CUD persistence on USPM_PORT and USPM via JPA EntityManager & QueryDSL
 * - Adheres strictly to Guideline 01 (JPA for single-table CUD, Zero-Default)
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class Ja032aJpaRepository {

    private final EntityManager em;
    private final JPAQueryFactory queryFactory;

    /* =========================================================================
     * 1. USPM_PORT 단일 테이블 CUD (JPA EntityManager)
     * ========================================================================= */

    public void insertPort(Ja032aPortDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getPortNum() == null) return;
        LocalDate tymd = parseLocalDate(dto.getTymd());
        LocalDate fymd = parseLocalDate(dto.getFymd());
        LocalDate mangi = parseLocalDate(dto.getMangiYmd());

        UspmPort entity = UspmPort.builder()
                .corpGr(dto.getCorpGr().trim())
                .tymd(tymd)
                .fundCd(dto.getFundCd().trim())
                .portNum(dto.getPortNum().trim())
                .fymd(fymd)
                .tt(dto.getTt())
                .instDays(dto.getInstDays())
                .mangi(mangi)
                .dt(dto.getDt())
                .putZ(dto.getZ())
                .jmPer(dto.getJmPer())
                .usdTuja(dto.getUsdTuja())
                .yearBeta(dto.getYearBeta())
                .monBeta(dto.getMonBeta())
                .pricePer(dto.getPricePer())
                .build();

        em.persist(entity);
    }

    public int updatePort(Ja032aPortDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getPortNum() == null) return 0;
        LocalDate tymd = parseLocalDate(dto.getTymd());
        if (tymd == null) return 0;

        UspmPortId id = new UspmPortId(dto.getCorpGr().trim(), tymd, dto.getFundCd().trim(), dto.getPortNum().trim());
        UspmPort entity = em.find(UspmPort.class, id);
        if (entity != null) {
            // 변경 감지(Dirty Checking)를 통한 엔티티 업데이트
            entity.setTt(dto.getTt());
            entity.setInstDays(dto.getInstDays());
            entity.setMangi(parseLocalDate(dto.getMangiYmd()));
            entity.setDt(dto.getDt());
            entity.setPutZ(dto.getZ());
            entity.setJmPer(dto.getJmPer());
            entity.setUsdTuja(dto.getUsdTuja());
            entity.setYearBeta(dto.getYearBeta());
            entity.setMonBeta(dto.getMonBeta());
            entity.setPricePer(dto.getPricePer());
            return 1;
        }
        return 0;
    }

    public void deletePort(Ja032aPortDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getPortNum() == null) return;
        LocalDate tymd = parseLocalDate(dto.getTymd());
        if (tymd == null) return;

        UspmPortId id = new UspmPortId(dto.getCorpGr().trim(), tymd, dto.getFundCd().trim(), dto.getPortNum().trim());
        UspmPort entity = em.find(UspmPort.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    public long deletePortAll(String corpGr, LocalDate tymd, String fundCd) {
        QUspmPort q = QUspmPort.uspmPort;
        return queryFactory.delete(q)
                .where(q.corpGr.eq(corpGr), q.tymd.eq(tymd), q.fundCd.eq(fundCd))
                .execute();
    }

    /* =========================================================================
     * 2. USPM 종목 상세 단일 테이블 CUD (JPA EntityManager)
     * ========================================================================= */

    public void insertDetail(Ja032aDetailDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getPortNum() == null || dto.getYjCd() == null) return;
        LocalDate ymd = parseLocalDate(dto.getYmd());

        Uspm entity = Uspm.builder()
                .corpGr(dto.getCorpGr().trim())
                .ymd(ymd)
                .fundCd(dto.getFundCd().trim())
                .portNum(dto.getPortNum().trim())
                .jmCd(dto.getYjCd().trim())
                .usdTuja(dto.getUsdTuja())
                .targetReturnPer(dto.getTargetReturnPer())
                .pricePer(dto.getPricePer())
                .col(dto.getCol())
                .ovrsExcgCd(dto.getOvrsExcgCd())
                .build();

        em.persist(entity);
    }

    public int updateDetail(Ja032aDetailDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getPortNum() == null || dto.getYjCd() == null) return 0;
        LocalDate ymd = parseLocalDate(dto.getYmd());
        if (ymd == null) return 0;

        UspmId id = new UspmId(dto.getCorpGr().trim(), ymd, dto.getFundCd().trim(), dto.getPortNum().trim(), dto.getYjCd().trim());
        Uspm entity = em.find(Uspm.class, id);
        if (entity != null) {
            // 변경 감지(Dirty Checking)
            entity.setUsdTuja(dto.getUsdTuja());
            entity.setTargetReturnPer(dto.getTargetReturnPer());
            entity.setPricePer(dto.getPricePer());
            entity.setCol(dto.getCol());
            entity.setOvrsExcgCd(dto.getOvrsExcgCd());
            return 1;
        }
        return 0;
    }

    public void deleteDetail(Ja032aDetailDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getPortNum() == null || dto.getYjCd() == null) return;
        LocalDate ymd = parseLocalDate(dto.getYmd());
        if (ymd == null) return;

        UspmId id = new UspmId(dto.getCorpGr().trim(), ymd, dto.getFundCd().trim(), dto.getPortNum().trim(), dto.getYjCd().trim());
        Uspm entity = em.find(Uspm.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    public long deleteDetailByPort(String corpGr, LocalDate ymd, String fundCd, String portNum) {
        QUspm q = QUspm.uspm;
        return queryFactory.delete(q)
                .where(q.corpGr.eq(corpGr), q.ymd.eq(ymd), q.fundCd.eq(fundCd), q.portNum.eq(portNum))
                .execute();
    }

    public long deleteDetailAll(String corpGr, LocalDate ymd, String fundCd) {
        QUspm q = QUspm.uspm;
        return queryFactory.delete(q)
                .where(q.corpGr.eq(corpGr), q.ymd.eq(ymd), q.fundCd.eq(fundCd))
                .execute();
    }

    private LocalDate parseLocalDate(String str) {
        if (str == null || str.isBlank()) return null;
        try {
            return LocalDate.parse(str.trim().replace(".", "-"));
        } catch (Exception e) {
            log.warn("날짜 파싱 실패: {}", str);
            return null;
        }
    }
}
