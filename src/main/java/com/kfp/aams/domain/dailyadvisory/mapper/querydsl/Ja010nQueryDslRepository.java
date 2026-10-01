package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010nDto;
import com.kfp.aams.domain.dailyadvisory.entity.Skt0bm;
import com.kfp.aams.domain.dailyadvisory.entity.Skt0bmId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * JPA Repository for w_ja010n (KOSPI 주가지수 관리)
 * - Operations on SKT0BM via Pure JPA Entity / JPQL
 */
@Repository
@RequiredArgsConstructor
public class Ja010nQueryDslRepository {

    private final EntityManager em;
    private static final DateTimeFormatter YMD_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public List<Ja010nDto> selectJa010nList() {
        List<Skt0bm> entities = em.createQuery(
                "SELECT b FROM Skt0bm b " +
                        "WHERE b.corpGr = 'JISU' AND b.colId = 'kospi_jisu' " +
                        "ORDER BY b.ymd DESC", Skt0bm.class)
                .getResultList();

        List<Ja010nDto> result = new ArrayList<>();
        for (Skt0bm b : entities) {
            Ja010nDto dto = new Ja010nDto();
            dto.setCorpGr(b.getCorpGr());
            dto.setYmd(b.getYmd() != null ? b.getYmd().format(YMD_FORMATTER) : null);
            dto.setColId(b.getColId());
            dto.setColVal(b.getColVal());
            result.add(dto);
        }
        return result;
    }

    public void insertJa010n(Ja010nDto dto) {
        LocalDate parsedYmd = parseLocalDate(dto.getYmd());
        Skt0bm entity = Skt0bm.builder()
                .corpGr("JISU")
                .ymd(parsedYmd)
                .colId("kospi_jisu")
                .colVal(dto.getColVal())
                .build();
        em.persist(entity);
    }

    public int updateJa010n(Ja010nDto dto) {
        LocalDate parsedYmd = parseLocalDate(dto.getYmd());
        Skt0bmId id = new Skt0bmId("JISU", parsedYmd, "kospi_jisu");
        Skt0bm entity = em.find(Skt0bm.class, id);
        if (entity != null) {
            entity.setColVal(dto.getColVal());
            return 1;
        }
        return 0;
    }

    public void deleteJa010n(String ymd) {
        LocalDate parsedYmd = parseLocalDate(ymd);
        Skt0bmId id = new Skt0bmId("JISU", parsedYmd, "kospi_jisu");
        Skt0bm entity = em.find(Skt0bm.class, id);
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
