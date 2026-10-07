package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010dDto;
import com.kfp.aams.domain.dailyadvisory.entity.Szm0ia;
import com.kfp.aams.domain.dailyadvisory.entity.Szm0iaId;
import com.kfp.aams.domain.dailyadvisory.entity.Szt0io;
import com.kfp.aams.domain.dailyadvisory.entity.Szt0ioId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * JPA Repository for w_ja010d (입출금 및 기준가적용일자 관리)
 * - Pure JPA Entity (Szt0io, Szx0aa, Szm0ia) persistence without hardcoded
 * native queries
 * - PB dw_list::itemchanged validation checks
 */
@Repository
@RequiredArgsConstructor
public class Ja010dQueryDslRepository {

    private final EntityManager em;

    /**
     * PB w_ja010d.srw dw_list::itemchanged 검증:
     * 신규설정일과 입출금일이 동일한 경우 입금 등록 제한:
     * "신규설정금액은 계좌정보(#1011) 등록시 계좌잔액에 입력하십시오."
     */
    public void validateFstSeoljYmd(String corpGr, String fundCd, LocalDate trYmd, BigDecimal inAek) {
        if (inAek == null || inAek.compareTo(BigDecimal.ZERO) <= 0)
            return;
        if (corpGr == null || fundCd == null || trYmd == null)
            return;

        Szm0ia fund = em.find(Szm0ia.class, new Szm0iaId(corpGr.trim(), fundCd.trim()));
        if (fund != null && fund.getFstSeoljYmd() != null) {
            if (fund.getFstSeoljYmd().equals(trYmd)) {
                throw new IllegalStateException("신규설정금액은 계좌정보(#1011) 등록시 계좌잔액에 입력하십시오.");
            }
        }
    }

    public void insertIo(Ja010dDto dto) {
        insertIo(dto, "SYSTEM");
    }

    public void insertIo(Ja010dDto dto, String modUser) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getTrYmd() == null)
            return;

        LocalDate trYmd = dto.getTrYmd();
        Szt0ioId id = new Szt0ioId(dto.getCorpGr().trim(), dto.getFundCd().trim(), trYmd);
        Szt0io entity = em.find(Szt0io.class, id);

        BigDecimal inAek = dto.getInAek() != null ? dto.getInAek() : BigDecimal.ZERO;
        BigDecimal outAek = dto.getOutAek() != null ? dto.getOutAek() : BigDecimal.ZERO;
        BigDecimal wonbonAek = dto.getWonbonAek() != null ? dto.getWonbonAek() : BigDecimal.ZERO;
        BigDecimal ioJo = dto.getIoJo() != null ? dto.getIoJo() : BigDecimal.ZERO;
        String safeModUser = truncateModUser(modUser);

        if (entity == null) {
            entity = Szt0io.builder()
                    .corpGr(dto.getCorpGr().trim())
                    .fundCd(dto.getFundCd().trim())
                    .trYmd(trYmd)
                    .inAek(inAek)
                    .outAek(outAek)
                    .wonbonAek(wonbonAek)
                    .ioJo(ioJo)
                    .modDt(java.time.LocalDateTime.now())
                    .modUser(safeModUser)
                    .build();
            em.persist(entity);
        } else {
            entity.setInAek(inAek);
            entity.setOutAek(outAek);
            entity.setWonbonAek(wonbonAek);
            entity.setIoJo(ioJo);
            entity.setModDt(java.time.LocalDateTime.now());
            entity.setModUser(safeModUser);
        }
    }

    public void updateIo(Ja010dDto dto) {
        updateIo(dto, "SYSTEM");
    }

    public void updateIo(Ja010dDto dto, String modUser) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getTrYmd() == null)
            return;

        LocalDate trYmd = dto.getTrYmd();
        Szt0ioId id = new Szt0ioId(dto.getCorpGr().trim(), dto.getFundCd().trim(), trYmd);
        Szt0io entity = em.find(Szt0io.class, id);

        if (entity != null) {
            entity.setInAek(dto.getInAek() != null ? dto.getInAek() : BigDecimal.ZERO);
            entity.setOutAek(dto.getOutAek() != null ? dto.getOutAek() : BigDecimal.ZERO);
            entity.setWonbonAek(dto.getWonbonAek() != null ? dto.getWonbonAek() : BigDecimal.ZERO);
            entity.setIoJo(dto.getIoJo() != null ? dto.getIoJo() : BigDecimal.ZERO);
            entity.setModDt(java.time.LocalDateTime.now());
            entity.setModUser(truncateModUser(modUser));
        } else {
            insertIo(dto, modUser);
        }
    }

    public void deleteIo(Ja010dDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getTrYmd() == null)
            return;
        LocalDate trYmd = dto.getTrYmd();
        Szt0ioId id = new Szt0ioId(dto.getCorpGr().trim(), dto.getFundCd().trim(), trYmd);
        Szt0io entity = em.find(Szt0io.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    private String truncateModUser(String modUser) {
        if (modUser == null || modUser.isBlank())
            return "SYSTEM";
        String trimmed = modUser.trim();
        return trimmed.length() > 40 ? trimmed.substring(0, 40) : trimmed;
    }

    public void updateGijungaYmd(String corpGr, LocalDate trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null)
            return;
        try {
            // ANSI 표준 JDBC 바인딩: java.sql.Date로 Oracle DATE 컬럼에 안전하게 매핑 (TO_DATE 문자열 치환 불필요)
            em.createNativeQuery("UPDATE SZX0AA SET GIJUNGA_YMD = :ymd WHERE CORP_GR = :corpGr")
                    .setParameter("ymd", java.sql.Date.valueOf(trYmd))
                    .setParameter("corpGr", corpGr.trim())
                    .executeUpdate();
        } catch (Exception e) {
            System.err.println("[updateGijungaYmd] Failed to update SZX0AA: " + e.getMessage());
        }
    }

    public void flush() {
        em.flush();
    }
}
