package com.kfp.aams;

import com.kfp.aams.domain.subscriptionrights.dto.*;
import com.kfp.aams.domain.subscriptionrights.entity.*;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja021gMapper;
import com.kfp.aams.domain.subscriptionrights.mapper.querydsl.Ja021gJpaRepository;
import com.kfp.aams.domain.subscriptionrights.service.Ja021gService;
import org.junit.jupiter.api.Test;
import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class Ja021gServiceTests {
    private final LocalDate date = LocalDate.of(2026,10,29);
    private final Ja021gJpaRepository repository = mock(Ja021gJpaRepository.class,
            withSettings().mockMaker("mock-maker-subclass"));
    private final Ja021gMapper mapper = mock(Ja021gMapper.class,
            withSettings().mockMaker("mock-maker-subclass"));
    private final Ja021gService service = new Ja021gService(repository,mapper);

    private Ja021gMasterDto row() {
        var row = new Ja021gMasterDto();
        row.setNew(true); row.setUpdated(true); row.setTrYmd(date);
        row.setHabCo("12345"); row.setPiHabCo("54321");
        return row;
    }
    private Ja021gSaveDto request(Ja021gMasterDto row) {
        var request = new Ja021gSaveDto(); request.setTab("t1"); request.setMaster(List.of(row));
        return request;
    }
    @Test void eachTabUsesItsPowerBuilderTransactionCode() {
        String[] expected={"G40","G43","G45","G47","G60","G92","G93"};
        for(int i=0;i<expected.length;i++) {
            service.master("t"+(i+1), date);
            verify(repository).selectMaster(expected[i], date);
        }
        assertThrows(IllegalArgumentException.class,()->service.master("G40", date));
    }
    @Test void preventsEditingPastRecordsEvenWhenNewDateIsFuture() {
        var row=row(); row.setNew(false);
        row.setOriginal(new Sjt0hkId(date.minusDays(1),"G40","12345","54321"));
        assertThrows(IllegalArgumentException.class,()->service.save(request(row),"2402",false,date));
        verify(repository,never()).update(any());
    }
    @Test void stockHolidayPreventsInsert() {
        when(mapper.selectStockHoliday(date)).thenReturn("1");
        assertThrows(IllegalArgumentException.class,()->service.save(request(row()),"2402",false,date));
        verify(repository,never()).insert(any());
    }
    @Test void reductionUsesSameIssuerAndServerTransactionCode() {
        var row=row(); row.setTrCd("G93");
        var request=request(row); request.setTab("t3");
        service.save(request,"2402",false,date);
        assertEquals("G45",row.getTrCd());
        assertEquals(row.getHabCo(),row.getPiHabCo());
        verify(repository).insert(row);
    }
    @Test void duplicateKeyIsRejected() {
        var row=row(); row.setTrCd("G40");
        when(repository.find(Ja021gJpaRepository.key(row))).thenReturn(new Sjt0hk());
        assertThrows(IllegalArgumentException.class,()->service.save(request(row),"2402",false,date));
        verify(repository,never()).insert(any());
    }
    @Test void cannotSaveAnotherCompanyDetail() {
        var detail=new Ja021gDetailDto(); detail.setUpdated(true);
        detail.setCorpGr("9999"); detail.setTrCd("G40"); detail.setHabJusu(BigDecimal.ONE);
        var request=new Ja021gSaveDto();request.setTab("t1");request.setDetail(List.of(detail));
        assertThrows(IllegalArgumentException.class,()->service.save(request,"2402",false,date));
        verify(repository,never()).updateDetail(any());
    }
    @Test void detailOnlyAllowsNonnegativeWholeShares() {
        var detail=new Ja021gDetailDto();detail.setUpdated(true);
        detail.setCorpGr("2402");detail.setTrCd("G40");detail.setHabJusu(new BigDecimal("1.5"));
        var request=new Ja021gSaveDto();request.setTab("t1");request.setDetail(List.of(detail));
        assertThrows(IllegalArgumentException.class,()->service.save(request,"2402",false,date));
        detail.setHabJusu(new BigDecimal("25"));
        service.save(request,"2402",false,date);
        verify(repository).updateDetail(detail);
    }
    @Test void deletedNewRowDoesNotReachDatabase() {
        var row=row();row.setDeleted(true);
        service.save(request(row),"2402",false,date);
        verifyNoInteractions(repository,mapper);
    }
}

