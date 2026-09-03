package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010eDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * MyBatis Mapper for w_ja010e (주식체결LOAD(입고))
 * Query joins SJT1JG + szm0ia + sjm0jj (d_ja010e1.srd)
 */
@Mapper
public interface Ja010eMapper {

    List<Ja010eDto> selectJa010eList(@Param("corpGr") String corpGr,
                                     @Param("trYmd") String trYmd,
                                     @Param("trCoCd") String trCoCd);
}
