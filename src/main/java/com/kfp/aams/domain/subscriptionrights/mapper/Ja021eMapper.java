package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021eDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021eFilterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja021eMapper {
    List<Ja021eDetailDto> selectDetails(Ja021eFilterDto filter);
    List<Ja021eDetailDto> selectHoldings(Ja021eFilterDto filter);
    LocalDate selectSystemDate();
    BigDecimal selectClose(@Param("workDate") LocalDate workDate, @Param("koscomCd") String koscomCd);
}
