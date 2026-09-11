package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja990cDetailDto;
import com.kfp.aams.domain.daily.dto.Ja990cMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja990cMapper {

    List<Ja990cMasterDto> selectMasterList(@Param("sosokGb") String sosokGb, @Param("cdLen") String cdLen);

    List<Ja990cDetailDto> selectDetailList(@Param("balhCo") String balhCo);

    int checkBalhCoExists(@Param("balhCo") String balhCo);

    int insertMaster(Ja990cMasterDto dto);

    int updateMaster(Ja990cMasterDto dto);

    int deleteMaster(@Param("balhCo") String balhCo);

    int insertHistory(Ja990cDetailDto dto);
}
