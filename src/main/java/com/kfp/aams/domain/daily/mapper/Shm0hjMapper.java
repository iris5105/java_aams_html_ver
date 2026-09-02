package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Shm0hjMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * MyBatis Mapper for d_shm0hj.srd (multi-table join query: SHM0HJ, szx2mm, SZM0IA)
 * and procedure call SR_SHJ0IG.
 * Adheres to Guideline 3 (strict preservation of .srd SQL and types) and Guideline 4 (MyBatis for multi-table queries).
 */
@Mapper
public interface Shm0hjMapper {

    List<Shm0hjMasterDto> selectShm0hjList(@Param("corpGr") String corpGr,
                                          @Param("ymd") String ymd,
                                          @Param("cashCd") String cashCd);

    void callSrShj0ig(@Param("corpGr") String corpGr,
                      @Param("jmCd") String jmCd,
                      @Param("pDel") String pDel);
}
