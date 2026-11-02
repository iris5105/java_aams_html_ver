package com.kfp.aams.domain.subscriptionrights.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDate;

@Mapper
public interface Ja021gMapper {
    String selectStockHoliday(@Param("ymd") LocalDate ymd);
}

