package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010m3SaveDto;
import com.kfp.aams.domain.dailyadvisory.entity.Skt1gsIndata;
import com.kfp.aams.domain.dailyadvisory.entity.Skt1gsIndataId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * JPA Repository for w_ja010m3 (투자자문/일임보고서 수수료 관리)
 * - SKT1GS_INDATA 수정 영속화 (순수 JPA Entity dirty checking)
 */
@Repository
@RequiredArgsConstructor
public class Ja010m3QueryDslRepository {

    private final EntityManager em;

    public int updateJa010m3(Ja010m3SaveDto.Ja010m3ItemSaveDto item) {
        LocalDate parsedGyulYmd = parseLocalDate(item.getGyulYmd());
        Skt1gsIndataId id = new Skt1gsIndataId(item.getCorpGr(), parsedGyulYmd, item.getFundCd());

        Skt1gsIndata entity = em.find(Skt1gsIndata.class, id);
        if (entity != null) {
            entity.setBasicBosu(item.getBasicBosu());
            entity.setSuccessBosu(item.getSuccessBosu());
            entity.setTotalBosu(item.getTotalBosu());
            entity.setRecontractAek(item.getRecontractAek());
            entity.setWmSeoljAek(item.getWmSeoljAek());
            entity.setWmSonik(item.getWmSonik());
            entity.setDocNo(item.getDocNo());
            entity.setHaejiSayu(item.getHaejiSayu());
            entity.setSendMailAddr(item.getSendMailAddr());
            entity.setSendCcAddr(item.getSendCcAddr());
            entity.setProductNm(item.getProductNm());
            entity.setContractCondition(item.getContractCondition());
            entity.setSendDt(LocalDateTime.now());
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
