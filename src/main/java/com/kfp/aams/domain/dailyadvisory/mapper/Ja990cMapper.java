package com.kfp.aams.domain.dailyadvisory.mapper;

import com.kfp.aams.domain.dailyadvisory.dto.Ja990cDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja990cMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja990cMapper {

    List<Ja990cMasterDto> selectMasterList(@Param("sosokGb") String sosokGb, @Param("cdLen") String cdLen);

    List<Ja990cDetailDto> selectDetailList(@Param("balhCo") String balhCo);
}
