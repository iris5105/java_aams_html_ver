package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010m3Dto;
import com.kfp.aams.domain.daily.dto.Ja010m3SaveDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010m3Mapper {

    List<Ja010m3Dto> selectJa010m3List(@Param("corpGr") String corpGr,
                                       @Param("gyulYmd") String gyulYmd,
                                       @Param("sortGb") String sortGb,
                                       @Param("chk") String chk);

    int updateJa010m3(Ja010m3SaveDto.Ja010m3ItemSaveDto item);
}
