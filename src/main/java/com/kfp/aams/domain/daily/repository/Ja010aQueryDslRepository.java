package com.kfp.aams.domain.daily.repository;

import com.kfp.aams.domain.daily.dto.Ja010aDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010aMasterDto;
import com.kfp.aams.domain.daily.entity.QSzx0ab;
import com.kfp.aams.domain.daily.entity.Szx0ab;
import com.kfp.aams.domain.home.entity.QSzx0aa;
import com.kfp.aams.domain.home.entity.Szx0aa;
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

    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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
                .ymd(e.getYmd() != null ? e.getYmd().format(DATE_FMT) : null)
                .companyName(e.getCompanyName())
                .idno(e.getIdno())
                .contractYmd(e.getContractYmd() != null ? e.getContractYmd().format(DATE_FMT) : null)
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
