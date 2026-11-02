package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020cDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface Ja020cMapper {

    List<Ja020cDto> selectList(@Param("corpGr") String corpGr,
                               @Param("ymd") LocalDate ymd,
                               @Param("trCd") String trCd,
                               @Param("jmCd") String jmCd);

    List<LocalDate> selectDates(@Param("corpGr") String corpGr,
                                @Param("trCd") String trCd);

    String selectJmCdByKoscomCd(@Param("koscomCd") String koscomCd,
                                @Param("dancGb") String dancGb);

    void callSrJa021c(Map<String, Object> params);
}

