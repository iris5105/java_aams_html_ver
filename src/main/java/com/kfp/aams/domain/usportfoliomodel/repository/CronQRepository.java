package com.kfp.aams.domain.usportfoliomodel.repository;

import com.kfp.aams.domain.usportfoliomodel.entity.CronQ;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CronQRepository extends JpaRepository<CronQ, String> {

    List<CronQ> findAllByOrderByCronKeyAscProcNameAsc();
}
