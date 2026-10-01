package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010kSaveDto;
import com.kfp.aams.domain.dailyadvisory.entity.Uzm0ui;
import com.kfp.aams.domain.dailyadvisory.entity.Uzm0uiId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

/**
 * JPA Repository for w_ja010k (벤처기업투자비율 관리)
 * - UZM0UI 테이블 vc_old 수정 영속화 (순수 JPA Entity 기반 dirty checking)
 */
@Repository
@RequiredArgsConstructor
public class Ja010kQueryDslRepository {

    private final EntityManager em;

    public int updateVcOld(Ja010kSaveDto.Ja010kItemSaveDto item) {
        LocalDate parsedYmd = parseLocalDate(item.getYmd());
        String cleanBuyDate = item.getBuyDate() != null ? item.getBuyDate().replace("-", "").trim() : null;

        Uzm0uiId id = new Uzm0uiId(
                item.getCorpGr(),
                parsedYmd,
                item.getFundCd(),
                item.getJmGr(),
                item.getJmCd(),
                cleanBuyDate,
                item.getChasu()
        );

        Uzm0ui entity = em.find(Uzm0ui.class, id);
        if (entity != null) {
            entity.setVcOld(item.getVcOld());
            entity.setVcOldDt(LocalDate.now());
            return 1;
        }
        return 0;
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
