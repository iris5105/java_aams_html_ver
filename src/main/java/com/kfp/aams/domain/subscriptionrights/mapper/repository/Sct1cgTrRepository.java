package com.kfp.aams.domain.subscriptionrights.mapper.repository;

import com.kfp.aams.domain.subscriptionrights.entity.Sct1cgTr;
import com.kfp.aams.domain.subscriptionrights.entity.Sct1cgTrId;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;

import java.time.LocalDate;
import java.util.List;

public interface Sct1cgTrRepository extends JpaRepository<Sct1cgTr, Sct1cgTrId> {
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    List<Sct1cgTr> findByCorpGrAndTrYmdAndTrCdAndFundCdAndJmCdAndAekGb(
            String corpGr, LocalDate trYmd, String trCd, String fundCd, String jmCd,
            String aekGb);
}
