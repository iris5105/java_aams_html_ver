package com.kfp.aams.domain.dailyadvisory.mapper.querydsl;

import com.kfp.aams.domain.dailyadvisory.dto.Shm1pgDto;
import com.kfp.aams.domain.dailyadvisory.entity.Shm0hj;
import com.kfp.aams.domain.dailyadvisory.entity.Shm0hjId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

/**
 * JPA Repository for w_shm1pg (현금신용등급 관리)
 * - Pure JPA Entity (Shm0hj) persistence without hardcoded native queries
 */
@Repository
@RequiredArgsConstructor
public class Shm1pgQueryDslRepository {

    private final EntityManager em;

    public int updateShm1pg(Shm1pgDto dto) {
        if (dto == null || dto.getCorpGr() == null || dto.getJmCd() == null) return 0;
        Shm0hj entity = em.find(Shm0hj.class, new Shm0hjId(dto.getCorpGr().trim(), dto.getJmCd().trim()));
        if (entity != null) {
            entity.setPgCd(dto.getPgCd());
            return 1;
        }
        return 0;
    }
}
