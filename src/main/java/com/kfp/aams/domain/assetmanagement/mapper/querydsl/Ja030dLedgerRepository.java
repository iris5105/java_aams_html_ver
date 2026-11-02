package com.kfp.aams.domain.assetmanagement.mapper.querydsl;

import com.kfp.aams.domain.assetmanagement.dto.Ja030dDto;
import com.kfp.aams.domain.dailyadvisory.entity.Sct0cg;
import com.kfp.aams.domain.dailyadvisory.entity.Sct0cgId;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;

@Repository
@RequiredArgsConstructor
public class Ja030dLedgerRepository {
    private final EntityManager em;
    public void insert(Ja030dDto dto) { dto.setSeqNo(nextSeqNo(dto)); em.persist(toEntity(dto)); }
    public boolean update(Ja030dDto dto) { Sct0cg e = em.find(Sct0cg.class, id(dto)); if (e == null) return false; copy(e, dto); return true; }
    public boolean delete(Ja030dDto dto) { Sct0cg e = em.find(Sct0cg.class, id(dto)); if (e == null) return false; em.remove(e); return true; }
    private BigDecimal nextSeqNo(Ja030dDto dto) {
        BigDecimal max = em.createQuery("SELECT MAX(s.seqNo) FROM Sct0cg s WHERE s.corpGr=:corpGr AND s.trYmd=:trYmd AND s.trCd=:trCd", BigDecimal.class)
                .setParameter("corpGr", dto.getCorpGr()).setParameter("trYmd", dto.getTrYmd()).setParameter("trCd", dto.getTrCd()).getSingleResult();
        return max == null ? BigDecimal.ONE : max.add(BigDecimal.ONE);
    }
    private Sct0cgId id(Ja030dDto dto) { return new Sct0cgId(dto.getCorpGr(), dto.getTrYmd(), dto.getTrCd(), dto.getSeqNo()); }
    private Sct0cg toEntity(Ja030dDto dto) { Sct0cg e=Sct0cg.builder().corpGr(dto.getCorpGr()).trYmd(dto.getTrYmd()).trCd(dto.getTrCd()).seqNo(dto.getSeqNo()).build(); copy(e,dto); return e; }
    private void copy(Sct0cg e, Ja030dDto d) {
        e.setFundCd(d.getFundCd()); e.setJmCd(d.getJmCd()); e.setTrCoCd(d.getTrCoCd()); e.setBuyDate(d.getBuyDate()); e.setSudoYmd(d.getSudoYmd());
        e.setAekm(z(d.getAekm())); e.setDanga(z(d.getDanga())); e.setTrAek(z(d.getTrAek())); e.setSusu(z(d.getSusu())); e.setSodukTax(z(d.getSodukTax())); e.setJuminTax(z(d.getJuminTax())); e.setIjaTax(z(d.getIjaTax()));
        e.setMkSuikRt(z(d.getMkSuikRt())); e.setJajunGb(d.getJajunGb()); e.setChuiAek(z(d.getChuiAek())); e.setDangaGb(d.getDangaGb()); e.setJajunSayu(d.getJajunSayu()); e.setIjaAekm(z(d.getIjaAekm())); e.setCreUser(d.getCreUser());
    }
    private BigDecimal z(BigDecimal v) { return v == null ? BigDecimal.ZERO : v; }
}
