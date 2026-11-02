package com.kfp.aams.domain.subscriptionrights.mapper.repository;

import com.kfp.aams.domain.subscriptionrights.entity.Sct1cg;
import com.kfp.aams.domain.subscriptionrights.entity.Sct1cgId;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;

import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.List;

public interface Sct1cgRepository extends JpaRepository<Sct1cg, Sct1cgId> {
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    List<Sct1cg> findByCorpGrAndTrYmdAndTrCdAndFundCdAndJmCdAndAekGbAndGwamok(
            String corpGr, LocalDate trYmd, String trCd, String fundCd, String jmCd,
            String aekGb, String gwamok);
}
