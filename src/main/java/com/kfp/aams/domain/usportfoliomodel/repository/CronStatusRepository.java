package com.kfp.aams.domain.usportfoliomodel.repository;

import com.kfp.aams.domain.usportfoliomodel.entity.CronStatus;
import com.kfp.aams.domain.usportfoliomodel.entity.CronStatusId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CronStatusRepository extends JpaRepository<CronStatus, CronStatusId> {

    List<CronStatus> findByCronKeyOrderByRunTimeDesc(String cronKey);
}
