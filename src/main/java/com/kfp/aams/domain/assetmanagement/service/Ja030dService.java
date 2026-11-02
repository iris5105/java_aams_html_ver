package com.kfp.aams.domain.assetmanagement.service;

import com.kfp.aams.domain.assetmanagement.dto.Ja030dDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030dSaveRequest;
import com.kfp.aams.domain.assetmanagement.mapper.Ja030dMapper;
import com.kfp.aams.domain.assetmanagement.mapper.querydsl.Ja030dLedgerRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

@Service @RequiredArgsConstructor @Transactional(readOnly = true)
public class Ja030dService {
    private final Ja030dMapper mapper; private final Ja030dLedgerRepository ledger;
    public List<Ja030dDto> list(String corpGr, LocalDate ymd, String trCd) { return blank(corpGr)||ymd==null||blank(trCd) ? Collections.emptyList() : mapper.selectList(corpGr, ymd, trCd); }
    @Transactional public int save(String corpGr, Ja030dSaveRequest request) {
        if (blank(corpGr)||request==null||request.getYmd()==null||blank(request.getTrCd())) return 0; int count=0;
        if (request.getDeletedList()!=null) for (Ja030dDto d:request.getDeletedList()) if (d!=null) { prepare(d,corpGr,request); if(ledger.delete(d)) count++; }
        if (request.getItems()!=null) for (Ja030dDto d:request.getItems()) if(d!=null&&!blank(d.getFundCd())&&!blank(d.getJmCd())) { prepare(d,corpGr,request); if(Boolean.TRUE.equals(d.getIsNew())) { ledger.insert(d); count++; } else if(Boolean.TRUE.equals(d.getIsUpdated())&&ledger.update(d)) count++; }
        return count;
    }
    private void prepare(Ja030dDto d,String corpGr,Ja030dSaveRequest r){ d.setCorpGr(corpGr);d.setTrYmd(r.getYmd());d.setTrCd(r.getTrCd());if(d.getSudoYmd()==null)d.setSudoYmd(r.getYmd());d.setAekm(z(d.getAekm()));d.setTrAek(z(d.getTrAek()));d.setDanga(z(d.getDanga()));d.setSusu(z(d.getSusu())); }
    private BigDecimal z(BigDecimal v){return v==null?BigDecimal.ZERO:v;} private boolean blank(String s){return s==null||s.isBlank();}
}
