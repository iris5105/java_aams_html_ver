package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010aDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010aMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010aMapper {

    /**
     * Select Company Master List (SZX0AA / d_ja010a1.srd)
     */
    List<Ja010aMasterDto> selectJa010aMasterList();

    /**
     * Select Company Contract History Detail List (SZX0AB / d_ja010a2.srd)
     */
    List<Ja010aDetailDto> selectJa010aDetailList(@Param("corpGr") String corpGr);
}
