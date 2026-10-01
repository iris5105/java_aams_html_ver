package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010dDto;
import com.kfp.aams.domain.dailyadvisory.entity.Szm0ia;
import com.kfp.aams.domain.dailyadvisory.entity.Szm0iaId;
import com.kfp.aams.domain.dailyadvisory.entity.Szt0io;
import com.kfp.aams.domain.dailyadvisory.entity.Szt0ioId;
import com.kfp.aams.home.entity.Szx0aa;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * JPA Repository for w_ja010d (입출금 및 기준가적용일자 관리)
 * - Pure JPA Entity (Szt0io, Szx0aa, Szm0ia) persistence without hardcoded native queries
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
    public void validateFstSeoljYmd(String corpGr, String fundCd, String trYmd, BigDecimal inAek) {
        if (inAek == null || inAek.compareTo(BigDecimal.ZERO) <= 0) return;
        if (corpGr == null || fundCd == null || trYmd == null) return;

        Szm0ia fund = em.find(Szm0ia.class, new Szm0iaId(corpGr.trim(), fundCd.trim()));
        if (fund != null && fund.getFstSeoljYmd() != null) {
            LocalDate inputYmd = parseLocalDate(trYmd);
            if (fund.getFstSeoljYmd().equals(inputYmd)) {
                throw new IllegalStateException("신규설정금액은 계좌정보(#1011) 등록시 계좌잔액에 입력하십시오.");
            }
        }
    }

    public void insertIo(Ja010dDto dto) {
        insertIo(dto, "SYSTEM");
    }

    public void insertIo(Ja010dDto dto, String modUser) {
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getTrYmd() == null) return;

        LocalDate trYmd = parseLocalDate(dto.getTrYmd());
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
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getTrYmd() == null) return;

        LocalDate trYmd = parseLocalDate(dto.getTrYmd());
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
        if (dto == null || dto.getCorpGr() == null || dto.getFundCd() == null || dto.getTrYmd() == null) return;
        LocalDate trYmd = parseLocalDate(dto.getTrYmd());
        if (trYmd == null) return;
        Szt0ioId id = new Szt0ioId(dto.getCorpGr().trim(), dto.getFundCd().trim(), trYmd);
        Szt0io entity = em.find(Szt0io.class, id);
        if (entity != null) {
            em.remove(entity);
        }
    }

    private String truncateModUser(String modUser) {
        if (modUser == null || modUser.isBlank()) return "SYSTEM";
        String trimmed = modUser.trim();
        return trimmed.length() > 40 ? trimmed.substring(0, 40) : trimmed;
    }

    public void updateGijungaYmd(String corpGr, String trYmd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trYmd.isBlank()) return;
        try {
            String clean = cleanDate(trYmd);
            // SZX0AA.GIJUNGA_YMD는 DATE 컬럼이므로 TO_DATE 네이티브 쿼리로 안전하게 업데이트 (타입 불일치 ORA-00932 방지)
            em.createNativeQuery("UPDATE SZX0AA SET GIJUNGA_YMD = TO_DATE(:ymd, 'YYYY-MM-DD') WHERE CORP_GR = :corpGr")
                    .setParameter("ymd", clean)
                    .setParameter("corpGr", corpGr.trim())
                    .executeUpdate();
        } catch (Exception e) {
            // SZX0AA 기준가적용일자 업데이트 예외 발생 시 경고 로그 후 진행
            System.err.println("[updateGijungaYmd] Failed to update SZX0AA: " + e.getMessage());
        }
    }

    public void flush() {
        em.flush();
    }

    private LocalDate parseLocalDate(String text) {
        if (text == null || text.isBlank()) return null;
        String clean = cleanDate(text);
        if (clean == null || clean.length() < 10) return null;
        return LocalDate.parse(clean.substring(0, 10), DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    }

    private String cleanDate(String text) {
        if (text == null || text.isBlank()) return null;
        String clean = text.trim();
        if (clean.length() >= 10) {
            return clean.substring(0, 10).replace('.', '-').replace('/', '-');
        }
        String digits = clean.replaceAll("\\D", "");
        if (digits.length() == 8) {
            return digits.substring(0, 4) + "-" + digits.substring(4, 6) + "-" + digits.substring(6, 8);
        }
        return clean;
    }
}
