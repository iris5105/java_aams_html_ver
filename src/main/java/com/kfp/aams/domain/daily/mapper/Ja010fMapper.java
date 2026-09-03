package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010fDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * MyBatis Mapper for w_ja010f (예수금잔액LOAD)
 * Query joins SHT0YE + SZM0IA (d_ja010f1.srd)
 */
@Mapper
public interface Ja010fMapper {

    List<Ja010fDto> selectJa010fList(@Param("corpGr") String corpGr,
                                     @Param("trYmd") String trYmd,
                                     @Param("trCoCd") String trCoCd);
}
