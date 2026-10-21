package com.kfp.aams.domain.usportfoliomodel.repository;

import com.kfp.aams.domain.usportfoliomodel.entity.ApiParams;
import com.kfp.aams.domain.usportfoliomodel.entity.ApiParamsId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * API_PARAMS JPA 리포지토리
 */
@Repository
public interface ApiParamsRepository extends JpaRepository<ApiParams, ApiParamsId> {

    List<ApiParams> findByTrCoCdOrderByGrCdAscScdAscCompanyAsc(String trCoCd);
}
