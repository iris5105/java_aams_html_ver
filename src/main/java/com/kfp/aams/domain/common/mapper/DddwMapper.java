package com.kfp.aams.domain.common.mapper;

import com.kfp.aams.domain.common.dto.WdddwctlDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface DddwMapper {

    /**
     * Fetch WDDDWCTL metadata by dddwNm (e.g., 'corp_gr_1' or dddwId='corp_gr', seq=1)
     */
    WdddwctlDto selectWdddwctl(@Param("dddwNm") String dddwNm,
                               @Param("dddwId") String dddwId,
                               @Param("seq") Integer seq);
}
