package com.kfp.aams.domain.subscriptionrights.mapper.querydsl;

import com.kfp.aams.domain.subscriptionrights.dto.*;
import com.kfp.aams.domain.subscriptionrights.entity.*;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository @RequiredArgsConstructor
public class Ja021gJpaRepository {
    private final EntityManager em;

    public List<Ja021gMasterDto> selectMaster(String trCd, LocalDate workDate) {
        String orderBy = "G93".equals(trCd) ? "order by h.trYmd desc, h.piHabCo, h.habCo"
                : "order by h.trYmd desc, h.piHabCo";
        return em.createQuery("""
            select h, function('f_balh_nm', '', h.habCo), function('f_balh_nm', '', h.piHabCo)
            from Sjt0hk h where h.trCd = :trCd
            """ + orderBy, Object[].class).setParameter("trCd", trCd).getResultList().stream().map(row -> {
                Ja021gMasterDto dto = new Ja021gMasterDto();
                BeanUtils.copyProperties(row[0], dto);
                dto.setXxHabCo(row[1] == null ? "" : row[1].toString());
                dto.setXxPiHabCo(row[2] == null ? "" : row[2].toString());
                dto.setPVisible(dto.getTrYmd() != null && !dto.getTrYmd().isBefore(workDate) ? 1 : 0);
                dto.setOriginal(key(dto));
                return dto;
            }).toList();
    }

    public List<Ja021gDetailDto> selectDetail(String scope, Sjt0hkId key) {
        return em.createQuery("""
            select h, function('f_fund_nm', h.corpGr, h.fundCd) from Sjt0h1 h
            where h.corpGr like :scope and h.trYmd = :ymd and h.trCd = :trCd
              and h.habCo = :habCo and h.piHabCo = :piHabCo
            order by h.corpGr, h.fundCd
            """, Object[].class).setParameter("scope", scope).setParameter("ymd", key.getTrYmd())
                .setParameter("trCd", key.getTrCd()).setParameter("habCo", key.getHabCo())
                .setParameter("piHabCo", key.getPiHabCo()).getResultList().stream().map(row -> {
                    Ja021gDetailDto dto = new Ja021gDetailDto();
                    BeanUtils.copyProperties(row[0], dto);
                    dto.setFundNm(row[1] == null ? "" : row[1].toString());
                    return dto;
                }).toList();
    }

    public Sjt0hk find(Sjt0hkId key) { return em.find(Sjt0hk.class, key); }
    public void insert(Ja021gMasterDto dto) {
        Sjt0hk entity = new Sjt0hk();
        BeanUtils.copyProperties(dto, entity);
        em.persist(entity);
        em.flush();
    }
    public void update(Ja021gMasterDto d) {
        var query = em.createQuery("update Sjt0hk h set h.trYmd = :trYmd, h.trCd = :trCd, h.habCo = :habCo, h.piHabCo = :piHabCo, h.habIlbanRt = :habIlbanRt, h.habWoosRt = :habWoosRt, h.habIlbanAek = :habIlbanAek, h.habWoosAek = :habWoosAek, h.gamIlbanRt = :gamIlbanRt, h.gamWoosRt = :gamWoosRt, h.gamIlbanAek = :gamIlbanAek, h.gamWoosAek = :gamWoosAek, h.piHabIlbanRt = :piHabIlbanRt, h.piHabWoosRt = :piHabWoosRt, h.piHabIlbanAek = :piHabIlbanAek, h.piHabWoosAek = :piHabWoosAek"
                + " where h.trYmd = :oldYmd and h.trCd = :oldCd and h.habCo = :oldCo and h.piHabCo = :oldPiCo");
        query.setParameter("trYmd", d.getTrYmd());
        query.setParameter("trCd", d.getTrCd());
        query.setParameter("habCo", d.getHabCo());
        query.setParameter("piHabCo", d.getPiHabCo());
        query.setParameter("habIlbanRt", d.getHabIlbanRt());
        query.setParameter("habWoosRt", d.getHabWoosRt());
        query.setParameter("habIlbanAek", d.getHabIlbanAek());
        query.setParameter("habWoosAek", d.getHabWoosAek());
        query.setParameter("gamIlbanRt", d.getGamIlbanRt());
        query.setParameter("gamWoosRt", d.getGamWoosRt());
        query.setParameter("gamIlbanAek", d.getGamIlbanAek());
        query.setParameter("gamWoosAek", d.getGamWoosAek());
        query.setParameter("piHabIlbanRt", d.getPiHabIlbanRt());
        query.setParameter("piHabWoosRt", d.getPiHabWoosRt());
        query.setParameter("piHabIlbanAek", d.getPiHabIlbanAek());
        query.setParameter("piHabWoosAek", d.getPiHabWoosAek());
        query.setParameter("oldYmd", d.getOriginal().getTrYmd()).setParameter("oldCd", d.getOriginal().getTrCd())
                .setParameter("oldCo", d.getOriginal().getHabCo()).setParameter("oldPiCo", d.getOriginal().getPiHabCo());
        if (query.executeUpdate() != 1) throw new IllegalStateException("수정할 공시가 변경되었거나 존재하지 않습니다.");
        em.clear();
    }
    public void delete(Sjt0hk entity) { em.remove(entity); em.flush(); }
    public void updateDetail(Ja021gDetailDto dto) {
        Sjt0h1Id id = new Sjt0h1Id();
        BeanUtils.copyProperties(dto, id);
        Sjt0h1 entity = em.find(Sjt0h1.class, id);
        if (entity == null) throw new IllegalArgumentException("상세 내역을 다시 조회해 주세요.");
        entity.setHabJusu(dto.getHabJusu());
    }
    public static Sjt0hkId key(Ja021gMasterDto d) { return new Sjt0hkId(d.getTrYmd(), d.getTrCd(), d.getHabCo(), d.getPiHabCo()); }
}

