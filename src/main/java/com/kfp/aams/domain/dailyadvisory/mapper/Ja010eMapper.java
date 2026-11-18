package com.kfp.aams.domain.dailyadvisory.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010eDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010eImportFundDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010eImportSecurityDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * MyBatis Mapper for w_ja010e (주식체결LOAD(입고))
 * Query joins SJT1JG + szm0ia + sjm0jj (d_ja010e1.srd)
 */
@Mapper
public interface Ja010eMapper {

    List<Ja010eDto> selectJa010eList(@Param("corpGr") String corpGr,
                                     @Param("trYmd") LocalDate trYmd,
                                     @Param("trCoCd") String trCoCd);

    List<String> selectJa010eDates(@Param("corpGr") String corpGr,
                                   @Param("trCoCd") String trCoCd);

    Ja010eImportFundDto selectActiveImportFund(@Param("corpGr") String corpGr,
                                               @Param("trCoCd") String trCoCd,
                                               @Param("acctNo") String acctNo);

    Ja010eImportFundDto selectImportFundByAccountSuffix(@Param("corpGr") String corpGr,
                                                        @Param("acctNoSuffix") String acctNoSuffix);

    Ja010eImportSecurityDto selectImportSecurityByKoscomCd(@Param("koscomCd") String koscomCd);

    Ja010eImportSecurityDto selectImportSecurityByName(@Param("jjNm") String jjNm);
}
