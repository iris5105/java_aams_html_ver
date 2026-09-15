package com.kfp.aams.common.mapper;

import com.kfp.aams.common.dto.WdddwctlDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface DddwMapper {

    /**
     * Fetch WDDDWCTL metadata by dddwId and seq (e.g., dddwId='CORP_GR', seq=1)
     */
    WdddwctlDto selectWdddwctl(@Param("dddwId") String dddwId,
                               @Param("seq") Integer seq);
}
