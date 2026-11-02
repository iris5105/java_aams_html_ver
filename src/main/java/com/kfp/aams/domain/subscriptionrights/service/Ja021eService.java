package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.DddwService;
import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.dailyadvisory.entity.Sct0cg;
import com.kfp.aams.domain.dailyadvisory.entity.Sct0cgId;
import com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja030cQueryDslRepository;
import com.kfp.aams.domain.subscriptionrights.dto.*;
import com.kfp.aams.domain.subscriptionrights.entity.*;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja021eMapper;
import com.kfp.aams.domain.subscriptionrights.mapper.querydsl.Ja021eLedgerRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.*;

@Service
@Transactional(readOnly = true)
public class Ja021eService {
    private final Ja021eMapper mapper;
    private final Ja030cQueryDslRepository trades;
    private final Ja021eLedgerRepository ledgers;
    private final WorkDateService workDates;
    private final DddwService dddw;

    public Ja021eService(Ja021eMapper mapper, Ja030cQueryDslRepository trades,
                         Ja021eLedgerRepository ledgers, WorkDateService workDates, DddwService dddw) {
        this.mapper=mapper; this.trades=trades; this.ledgers=ledgers; this.workDates=workDates; this.dddw=dddw;
    }

    public List<LocalDate> dates(String corpGr, String trCd) { return trades.findDates(corpGr, trCd); }

    public Ja021eDataDto query(Ja021eFilterDto filter) {
        require(filter != null && nonblank(filter.getCorpGr()) && filter.getTrYmd()!=null && nonblank(filter.getTrCd()), "회사·권리일자·거래코드를 확인하십시오.");
        if (!nonblank(filter.getCjCd())) filter.setCjCd("%");
        LocalDate workDate=LocalDate.parse(workDates.getWorkDateOrDefault(filter.getCorpGr()));
        LocalDate systemDate=mapper.selectSystemDate();
        Ja021eBondDto bond=ledgers.findBond(filter.getCjCd(),systemDate);
        BigDecimal close=nonblank(filter.getKoscomCd()) ? zero(mapper.selectClose(workDate,filter.getKoscomCd())) : BigDecimal.ZERO;
        List<Ja021eDetailDto> rows=mapper.selectDetails(filter);
        if (rows.isEmpty() && !"%".equals(filter.getCjCd())) {
            rows=mapper.selectHoldings(filter);
            for (var row:rows) {
                row.setCorpGr(filter.getCorpGr()); row.setTrYmd(filter.getTrYmd()); row.setTrCd(filter.getTrCd());
                row.setJmCd(filter.getCjCd()); row.setBuyDate("%"); row.setKoscomCd(filter.getKoscomCd());
                row.setIjaBaedGb(filter.getIjaBaedGb()); row.setDancGb(filter.getDancGb());
                row.setDanga(bond.getChgGa()); row.setChgJmCd(bond.getChgJmCd()); row.setLockEnd(bond.getLockEnd());
                row.setPVisible(BigDecimal.ONE); row.setIsNew(true);
                BigDecimal holding=zero(row.getHoldingAek()), price=zero(bond.getChgGa());
                if (price.signum()!=0) {
                    row.setJusicJusu(holding.divide(price,0,RoundingMode.DOWN));
                    row.setJusicAek(row.getJusicJusu().multiply(price));
                    row.setJusicDanga(holding.subtract(row.getJusicAek()));
                } else row.setJusicAek(holding);
            }
        }
        for (var row:rows) if (row.getIsNew()==null) row.setIsNew(false);
        var result=new Ja021eDataDto(); result.setRows(rows); result.setBond(bond);
        result.setClosePrice(close); result.setSystemDate(systemDate); result.setWorkDate(workDate);
        result.setCanManage(!filter.getTrYmd().isBefore(workDate) && !filter.getCjCd().contains("%") && !filter.getCjCd().contains("_"));
        return result;
    }

    private void validateCode(String id, String corp, String value, String where) {
        require(nonblank(value) && dddw.getDddwList(id,1,corp,where,null,null).stream()
                .anyMatch(o -> value.equals(o.getCode()!=null ? o.getCode().trim() : null)), "유효하지 않은 코드입니다: "+id);
    }

    @Transactional
    public int save(Ja021eSaveDto request) {
        require(request!=null && request.getFilter()!=null && request.getRows()!=null,"저장할 자료를 확인하십시오.");
        var filter=request.getFilter();
        require(nonblank(filter.getCjCd()) && !filter.getCjCd().contains("%") && !filter.getCjCd().contains("_"),"채권종목을 지정하여 조회한 후 저장하십시오.");
        validateCode("dddw",filter.getCorpGr(),filter.getTrCd(),"szx1pt.obj_id='W_JA021E'");
        validateCode("ija_baedang_gb",filter.getCorpGr(),filter.getIjaBaedGb(),"");
        validateCode("danc_gb",filter.getCorpGr(),filter.getDancGb(),"szx0gd.tr_cd='"+filter.getTrCd().replace("'","''")+"'");
        trades.lockCompany(filter.getCorpGr());
        var current=query(filter);
        require(Boolean.TRUE.equals(current.getCanManage()),"과거 권리일자는 수정할 수 없습니다.");
        Map<String,Ja021eDetailDto> baseline=new HashMap<>();
        for (var row:current.getRows()) require(baseline.put(key(row),row)==null,"중복 원장 자료가 있습니다. 원장을 확인하십시오.");
        BigDecimal next=trades.selectNextSeqNo(filter.getCorpGr(),filter.getTrCd(),filter.getTrYmd(),null);
        Set<String> visited=new HashSet<>();
        int count=0;
        for (var input:request.getRows()) {
            require(input!=null && visited.add(key(input)),"중복 저장 행입니다.");
            var before=baseline.get(key(input));
            require(before!=null,"조회 자료가 변경되었습니다. 다시 조회하십시오.");
            boolean isNew=Boolean.TRUE.equals(before.getIsNew());
            boolean deleting="D".equals(input.getRowStatus()) || Boolean.TRUE.equals(input.getIsDeleted());
            Sct0cg entity=null;
            if (!isNew) {
                entity=trades.findForUpdate(new Sct0cgId(filter.getCorpGr(),filter.getTrYmd(),filter.getTrCd(),before.getSeqNo()));
                require(entity!=null && Objects.equals(entity.getFundCd(),before.getFundCd()) && Objects.equals(entity.getJmCd(),filter.getCjCd()),"저장 대상이 변경되었습니다.");
            }
            boolean protectedReceipt=zero(before.getSuryProtect()).signum()!=0;
            if (deleting) {
                require(!protectedReceipt,"수령 처리된 과거 원장은 삭제할 수 없습니다.");
                if (!isNew) { deleteLedgers(filter,before); trades.remove(entity); count++; }
                continue;
            }
            require(zero(input.getAekm()).signum()>0,"행사액면을 확인하십시오.");
            require(zero(input.getAekm()).compareTo(zero(before.getComAekm()).multiply(BigDecimal.valueOf(10000)))<=0,"행사액면이 보유액면을 초과합니다.");
            for (var amount:Arrays.asList(input.getAekm(),input.getJusicJusu(),input.getJusicAek(),input.getAek()))
                require(amount==null || (amount.signum()>=0 && amount.stripTrailingZeros().scale()<=0),"수량과 금액은 0 이상의 정수로 입력하십시오.");
            boolean cashChanged=zero(input.getAek()).compareTo(zero(before.getAek()))!=0;
            String checked="1".equals(input.getSuryChk()) ? "1" : "0";
            boolean receiptChanged=!checked.equals("1".equals(before.getSuryChk()) ? "1" : "0");
            require(!protectedReceipt || (!cashChanged && !receiptChanged),"잠금된 수령 내역은 변경할 수 없습니다.");
            LocalDate receiptDate=receiptChanged ? ("1".equals(checked) ? current.getSystemDate() : null) : before.getSuryYmd();
            require(receiptDate==null || zero(input.getAek()).signum()>0,"단주대금을 먼저 입력하십시오.");
            if (zero(input.getAek()).signum()==0) { receiptDate=null; checked="0"; }

            if (isNew) {
                entity=new Sct0cg(); entity.setCorpGr(filter.getCorpGr()); entity.setTrYmd(filter.getTrYmd());
                entity.setTrCd(filter.getTrCd()); entity.setSeqNo(next); next=next.add(BigDecimal.ONE);
                entity.setFundCd(before.getFundCd()); entity.setJmCd(filter.getCjCd()); entity.setBuyDate(before.getBuyDate());
                entity.setTrCoCd(before.getTrCoCd()); entity.setKoscomCd(before.getKoscomCd());
                entity.setIjaBaedGb(before.getIjaBaedGb()); entity.setDancGb(before.getDancGb());
                entity.setDanga(before.getDanga()); entity.setChgJmCd(before.getChgJmCd());
                entity.setMijigubTax(before.getMijigubTax());
            }
            // Update this screen's editable fields only; preserve other trading columns.
            entity.setAekm(input.getAekm()); entity.setJusicJusu(zero(input.getJusicJusu()));
            entity.setJusicAek(zero(input.getJusicAek())); entity.setJusicDanga(before.getJusicDanga());
            if (zero(input.getAekm()).compareTo(zero(before.getAekm()))!=0 && zero(current.getBond().getChgGa()).signum()!=0) {
                BigDecimal shares=input.getAekm().divide(current.getBond().getChgGa(),0,RoundingMode.DOWN);
                entity.setJusicJusu(shares); entity.setJusicAek(shares.multiply(current.getClosePrice()));
                entity.setJusicDanga(current.getClosePrice());
            }
            entity.setLockEnd(input.getLockEnd());
            if (isNew) trades.persist(entity);
            if (cashChanged || receiptChanged) syncLedger(filter,before,zero(input.getAek()),receiptDate);
            count++;
        }
        return count;
    }

    private void deleteLedgers(Ja021eFilterDto f, Ja021eDetailDto row) {
        ledgers.findReceipts(f.getCorpGr(),f.getTrYmd(),f.getTrCd(),row.getFundCd(),f.getCjCd()).forEach(ledgers::remove);
        ledgers.findLedgers(f.getCorpGr(),f.getTrYmd(),f.getTrCd(),row.getFundCd(),f.getCjCd()).forEach(ledgers::remove);
    }

    private void syncLedger(Ja021eFilterDto f, Ja021eDetailDto row, BigDecimal amount, LocalDate receiptDate) {
        if (amount.signum()==0) { deleteLedgers(f,row); return; }
        var found=ledgers.findLedgers(f.getCorpGr(),f.getTrYmd(),f.getTrCd(),row.getFundCd(),f.getCjCd());
        require(found.size()<=1,"복수 단주대금 원장은 이 화면에서 변경할 수 없습니다.");
        Sct1cg ledger;
        if (found.isEmpty()) {
            ledger=new Sct1cg(); ledger.setCorpGr(f.getCorpGr()); ledger.setTrYmd(f.getTrYmd());
            ledger.setTrCd(f.getTrCd()); ledger.setFundCd(row.getFundCd()); ledger.setJmCd(f.getCjCd());
            ledger.setBuyDate("%"); ledger.setSeqNo(BigDecimal.ONE); ledger.setAekGb("3"); ledger.setGwamok("12049");
            ledgers.persist(ledger);
        } else ledger=found.get(0);
        ledger.setAek(amount); ledger.setJanAek(receiptDate==null ? amount : BigDecimal.ZERO); ledger.setSanghwYmd(receiptDate);
        var receipts=ledgers.findReceipts(f.getCorpGr(),f.getTrYmd(),f.getTrCd(),row.getFundCd(),f.getCjCd());
        var matching=receipts.stream().filter(t -> Objects.equals(t.getBuyDate(),ledger.getBuyDate()) && zero(t.getSeqNo()).compareTo(zero(ledger.getSeqNo()))==0).toList();
        require(matching.size()<=1,"중복 단주대금 수령 원장입니다.");
        Sct1cgTr receipt;
        if (matching.isEmpty()) {
            receipt=new Sct1cgTr(); receipt.setCorpGr(ledger.getCorpGr()); receipt.setTrYmd(ledger.getTrYmd());
            receipt.setTrCd(ledger.getTrCd()); receipt.setFundCd(ledger.getFundCd()); receipt.setJmCd(ledger.getJmCd());
            receipt.setBuyDate(ledger.getBuyDate()); receipt.setSeqNo(ledger.getSeqNo()); receipt.setAekGb("3");
            ledgers.persist(receipt);
        } else receipt=matching.get(0);
        receipt.setSanghwYmd(receiptDate!=null ? receiptDate : f.getTrYmd());
        receipt.setSanghwAek(receiptDate!=null ? amount : BigDecimal.ZERO);
        receipt.setBigo(receiptDate!=null ? "전액상환" : null);
    }

    private static String key(Ja021eDetailDto row) {
        return Objects.toString(row.getFundCd(),"")+"|"+(row.getSeqNo()==null ? "new" : row.getSeqNo().stripTrailingZeros().toPlainString());
    }
    private static BigDecimal zero(BigDecimal value) { return value!=null ? value : BigDecimal.ZERO; }
    private static boolean nonblank(String value) { return value!=null && !value.isBlank(); }
    private static void require(boolean condition,String message) { if (!condition) throw new IllegalArgumentException(message); }
}
