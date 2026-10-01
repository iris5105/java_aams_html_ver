package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Sjt0scDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt0sc;
import com.kfp.aams.domain.dailyadvisory.entity.Sjt0scId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

/**
 * JPA Repository for w_sjt0sc (펀드 기준가(시가액)등록)
 * - C/U/D persistence on SJT0SC via Pure JPA Entity
 */
@Repository
@RequiredArgsConstructor
public class Sjt0scQueryDslRepository {

    private final EntityManager em;

    public void insertSjt0sc(Sjt0scDto dto) {
        Sjt0sc entity = Sjt0sc.builder()
                .corpGr(dto.getCorpGr())
                .ymd(parseLocalDate(dto.getYmd()))
                .jmCd(dto.getJmCd())
                .dangGijunGa(dto.getDangGijunGa())
                .junGijunGa(dto.getJunGijunGa())
                .gyulGijunGa(dto.getGyulGijunGa())
                .bfSigaAek(dto.getBfSigaAek())
                .loadSigaAek(dto.getLoadSigaAek())
                .bigo(dto.getBigo() != null ? dto.getBigo() : "W_SJT0SC")
                .dangGgijunGa(dto.getDangGgijunGa() != null ? dto.getDangGgijunGa() : dto.getDangGijunGa())
                .gyulGgijunGa(dto.getGyulGgijunGa() != null ? dto.getGyulGgijunGa() : dto.getGyulGijunGa())
                .build();
        em.persist(entity);
    }

    public int updateSjt0sc(Sjt0scDto dto) {
        Sjt0scId id = new Sjt0scId(dto.getCorpGr(), parseLocalDate(dto.getYmd()), dto.getJmCd());
        Sjt0sc entity = em.find(Sjt0sc.class, id);
        if (entity != null) {
            entity.setDangGijunGa(dto.getDangGijunGa());
            entity.setJunGijunGa(dto.getJunGijunGa());
            entity.setGyulGijunGa(dto.getGyulGijunGa());
            entity.setBfSigaAek(dto.getBfSigaAek());
            entity.setLoadSigaAek(dto.getLoadSigaAek());
            entity.setBigo(dto.getBigo() != null ? dto.getBigo() : "W_SJT0SC");
            entity.setDangGgijunGa(dto.getDangGgijunGa() != null ? dto.getDangGgijunGa() : dto.getDangGijunGa());
            entity.setGyulGgijunGa(dto.getGyulGgijunGa() != null ? dto.getGyulGgijunGa() : dto.getGyulGijunGa());
            return 1;
        }
        return 0;
    }

    public void deleteSjt0sc(String corpGr, String ymd, String jmCd) {
        Sjt0scId id = new Sjt0scId(corpGr, parseLocalDate(ymd), jmCd);
        Sjt0sc entity = em.find(Sjt0sc.class, id);
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
