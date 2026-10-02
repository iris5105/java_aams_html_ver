package com.kfp.aams.domain.dailyadvisory.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010m3Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja010m3Mapper {

    List<Ja010m3Dto> selectJa010m3List(@Param("corpGr") String corpGr,
                                       @Param("gyulYmd") LocalDate gyulYmd,
                                       @Param("sortGb") String sortGb,
                                       @Param("chk") String chk);
}
