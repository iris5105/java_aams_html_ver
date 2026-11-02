package com.kfp.aams.domain.subscriptionrights.mapper.querydsl;

import com.kfp.aams.domain.subscriptionrights.entity.Sjt0fs;
import com.kfp.aams.domain.subscriptionrights.entity.Sjt0fsId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class Ja020cJpaRepository {

    private final EntityManager em;

    public Sjt0fs findById(Sjt0fsId id) {
        return em.find(Sjt0fs.class, id);
    }

    public void persist(Sjt0fs entity) {
        em.persist(entity);
    }

    public void remove(Sjt0fs entity) {
        em.remove(entity);
    }

    public void flush() {
        em.flush();
    }
}

