package com.kfp.aams;

import com.kfp.aams.common.dto.DddwDto;
import com.kfp.aams.common.service.DddwService;
import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.dailyadvisory.entity.Sct0cg;
import com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja030cQueryDslRepository;
import com.kfp.aams.domain.subscriptionrights.dto.*;
import com.kfp.aams.domain.subscriptionrights.entity.*;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja021eMapper;
import com.kfp.aams.domain.subscriptionrights.mapper.querydsl.Ja021eLedgerRepository;
import com.kfp.aams.domain.subscriptionrights.service.Ja021eService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

class Ja021eServiceTests {
    private final LocalDate date=LocalDate.of(2026,10,28);
    private Ja021eMapper mapper;
    private Ja030cQueryDslRepository trades;
    private Ja021eLedgerRepository ledgers;
    private WorkDateService dates;
    private Ja021eService service;
    private Ja021eDetailDto before;
    private Sct0cg entity;

    private static <T> T stub(Class<T> type) { return mock(type,withSettings().mockMaker("mock-maker-subclass")); }
    @BeforeEach
    void setup() {
        mapper=stub(Ja021eMapper.class); trades=stub(Ja030cQueryDslRepository.class);
        ledgers=stub(Ja021eLedgerRepository.class); dates=stub(WorkDateService.class);
        DddwService codes=stub(DddwService.class);
        when(codes.getDddwList(anyString(),eq(1),anyString(),anyString(),isNull(),isNull()))
                .thenAnswer(call -> List.of(new DddwDto("dddw".equals(call.getArgument(0)) ? "F55" : "1","code","")));
        when(dates.getWorkDateOrDefault("2402")).thenReturn(date.toString());
        when(mapper.selectSystemDate()).thenReturn(date);
        when(mapper.selectClose(date,"KOSCOM")).thenReturn(new BigDecimal("900"));
        var bond=new Ja021eBondDto(); bond.setChgGa(new BigDecimal("1000")); bond.setChgJmCd("STOCK"); bond.setLockEnd(date);
        when(ledgers.findBond(anyString(),eq(date))).thenReturn(bond);
        before=row(); when(mapper.selectDetails(any())).thenReturn(List.of(before));
        entity=new Sct0cg(); entity.setFundCd("FUND"); entity.setJmCd("BOND"); entity.setTrAek(new BigDecimal("777"));
        when(trades.findForUpdate(any())).thenReturn(entity);
        when(trades.selectNextSeqNo(anyString(),anyString(),any(),isNull())).thenReturn(BigDecimal.TEN);
        service=new Ja021eService(mapper,trades,ledgers,dates,codes);
    }
    private Ja021eDetailDto row() {
        var row=new Ja021eDetailDto(); row.setFundCd("FUND"); row.setJmCd("BOND"); row.setSeqNo(BigDecimal.ONE);
        row.setAekm(new BigDecimal("10000")); row.setComAekm(BigDecimal.TEN); row.setAek(BigDecimal.ZERO);
        row.setJusicJusu(BigDecimal.TEN); row.setJusicAek(new BigDecimal("9000"));
        row.setSuryChk("0"); row.setSuryProtect(BigDecimal.ZERO); row.setLockEnd(date);
        return row;
    }
    private Ja021eSaveDto request(Ja021eDetailDto row) {
        var filter=new Ja021eFilterDto(); filter.setCorpGr("2402"); filter.setTrYmd(date); filter.setTrCd("F55");
        filter.setCjCd("BOND"); filter.setKoscomCd("KOSCOM"); filter.setIjaBaedGb("1"); filter.setDancGb("1");
        var request=new Ja021eSaveDto(); request.setFilter(filter); request.setRows(List.of(row)); return request;
    }
    @Test
    void recalculatesConversionAndPreservesOtherScreenColumns() {
        var row=row(); row.setAekm(new BigDecimal("20000"));
        assertEquals(1,service.save(request(row)));
        assertEquals(0,entity.getJusicJusu().compareTo(new BigDecimal("20")));
        assertEquals(0,entity.getJusicAek().compareTo(new BigDecimal("18000")));
        assertEquals(new BigDecimal("777"),entity.getTrAek());
        verify(trades,never()).persist(any()); verify(ledgers,never()).persist(any());
    }
    @Test
    void rejectsExerciseBeyondServerHolding() {
        var row=row(); row.setAekm(new BigDecimal("100001")); row.setComAekm(new BigDecimal("999999"));
        assertThrows(IllegalArgumentException.class,()->service.save(request(row)));
        assertNull(entity.getAekm()); verify(ledgers,never()).persist(any());
    }
    @Test
    void rejectsProtectedCashChanges() {
        before.setSuryProtect(BigDecimal.ONE);
        var row=row(); row.setAek(BigDecimal.TEN);
        assertThrows(IllegalArgumentException.class,()->service.save(request(row)));
        verify(ledgers,never()).persist(any());
    }
    @Test
    void refusesReceiptWithoutCash() {
        var row=row(); row.setSuryChk("1");
        assertThrows(IllegalArgumentException.class,()->service.save(request(row)));
        verify(ledgers,never()).persist(any());
    }
    @Test
    void createsCashAndReceiptWithServerDate() {
        var row=row(); row.setAek(new BigDecimal("100")); row.setSuryChk("1"); row.setSuryYmd(date.minusDays(3));
        service.save(request(row));
        var captured=ArgumentCaptor.forClass(Object.class); verify(ledgers,times(2)).persist(captured.capture());
        var ledger=(Sct1cg)captured.getAllValues().get(0);
        var receipt=(Sct1cgTr)captured.getAllValues().get(1);
        assertEquals(BigDecimal.ZERO,ledger.getJanAek()); assertEquals(date,ledger.getSanghwYmd());
        assertEquals(new BigDecimal("100"),receipt.getSanghwAek()); assertEquals(date,receipt.getSanghwYmd());
    }
    @Test
    void zeroCashRemovesBothLedgerTypes() {
        before.setAek(new BigDecimal("100"));
        var ledger=new Sct1cg(); var receipt=new Sct1cgTr();
        when(ledgers.findLedgers(anyString(),any(),anyString(),anyString(),anyString())).thenReturn(List.of(ledger));
        when(ledgers.findReceipts(anyString(),any(),anyString(),anyString(),anyString())).thenReturn(List.of(receipt));
        service.save(request(row()));
        verify(ledgers).remove(ledger); verify(ledgers).remove(receipt);
    }
    @Test
    void pastWorkDateCannotBeSaved() {
        when(dates.getWorkDateOrDefault("2402")).thenReturn(date.plusDays(1).toString());
        assertThrows(IllegalArgumentException.class,()->service.save(request(row())));
        verify(trades,never()).findForUpdate(any());
    }
    @Test
    void cannotInjectUnqueriedAccount() {
        var row=row(); row.setFundCd("OTHER");
        assertThrows(IllegalArgumentException.class,()->service.save(request(row)));
        verify(trades,never()).findForUpdate(any());
    }
    @Test
    void createsMissingAccountFromHoldingsAndAssignsSequence() {
        var holding=row(); holding.setSeqNo(null); holding.setAekm(null);
        holding.setHoldingAek(new BigDecimal("12500"));
        when(mapper.selectDetails(any())).thenReturn(List.of());
        when(mapper.selectHoldings(any())).thenReturn(List.of(holding));
        var input=row(); input.setSeqNo(null); input.setAekm(new BigDecimal("20000"));
        service.save(request(input));
        var captured=ArgumentCaptor.forClass(Sct0cg.class); verify(trades).persist(captured.capture());
        assertEquals(BigDecimal.TEN,captured.getValue().getSeqNo());
        assertEquals("BOND",captured.getValue().getJmCd());
        assertEquals(0,captured.getValue().getJusicAek().compareTo(new BigDecimal("18000")));
        verify(ledgers,never()).persist(any());
    }
    @Test
    void deletionRemovesTradeAndItsLedgers() {
        var row=row(); row.setRowStatus("D");
        var ledger=new Sct1cg(); var receipt=new Sct1cgTr();
        when(ledgers.findLedgers(anyString(),any(),anyString(),anyString(),anyString())).thenReturn(List.of(ledger));
        when(ledgers.findReceipts(anyString(),any(),anyString(),anyString(),anyString())).thenReturn(List.of(receipt));
        service.save(request(row));
        verify(trades).remove(entity); verify(ledgers).remove(ledger); verify(ledgers).remove(receipt);
    }
    @Test
    void protectedReceiptCannotBeDeleted() {
        before.setSuryProtect(BigDecimal.ONE);
        var row=row(); row.setRowStatus("D");
        assertThrows(IllegalArgumentException.class,()->service.save(request(row)));
        verify(trades,never()).remove(any()); verify(ledgers,never()).remove(any());
    }
}
