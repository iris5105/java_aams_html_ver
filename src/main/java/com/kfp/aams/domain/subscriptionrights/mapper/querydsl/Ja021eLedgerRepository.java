package com.kfp.aams.domain.subscriptionrights.mapper.querydsl;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021eBondDto;
import com.kfp.aams.domain.subscriptionrights.entity.*;
import com.kfp.aams.domain.subscriptionrights.mapper.repository.Scm0cjKapRepository;
import com.kfp.aams.domain.subscriptionrights.mapper.repository.Sct1cgRepository;
import com.kfp.aams.domain.subscriptionrights.mapper.repository.Sct1cgTrRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class Ja021eLedgerRepository {
    private final Scm0cjKapRepository bondRepository;
    private final Sct1cgRepository ledgerRepository;
    private final Sct1cgTrRepository receiptRepository;

    public Ja021eBondDto findBond(String cjCd, LocalDate systemDate) {
        var dto = new Ja021eBondDto();
        dto.setLockEnd(systemDate); // d_ja021e1.srd: now() AS lock_end
        if (cjCd == null || cjCd.isBlank()) return dto;
        var entity = bondRepository.findById(cjCd).orElse(null);
        if (entity != null) {
            dto.setChgGa(entity.getChgGa()); dto.setChgJmCd(entity.getChgJmCd());
            dto.setChgStartIl(entity.getChgStartIl());
        }
        return dto;
    }

    public List<Sct1cg> findLedgers(String corpGr, LocalDate trYmd, String trCd, String fundCd, String jmCd) {
        return ledgerRepository.findByCorpGrAndTrYmdAndTrCdAndFundCdAndJmCdAndAekGbAndGwamok(
                corpGr, trYmd, trCd, fundCd, jmCd, "3", "12049");
    }

    public List<Sct1cgTr> findReceipts(String corpGr, LocalDate trYmd, String trCd, String fundCd, String jmCd) {
        return receiptRepository.findByCorpGrAndTrYmdAndTrCdAndFundCdAndJmCdAndAekGb(
                corpGr, trYmd, trCd, fundCd, jmCd, "3");
    }

    public void remove(Object entity) {
        if (entity instanceof Sct1cg ledger) ledgerRepository.delete(ledger);
        else if (entity instanceof Sct1cgTr receipt) receiptRepository.delete(receipt);
        else if (entity instanceof Scm0cjKap bond) bondRepository.delete(bond);
    }

    public void persist(Object entity) {
        if (entity instanceof Sct1cg ledger) ledgerRepository.save(ledger);
        else if (entity instanceof Sct1cgTr receipt) receiptRepository.save(receipt);
        else if (entity instanceof Scm0cjKap bond) bondRepository.save(bond);
    }
}
