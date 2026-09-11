package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010kDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010kMasterDto;
import com.kfp.aams.domain.daily.dto.Ja010kSaveDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja010kMapper {

    List<Ja010kMasterDto> selectMasterList(@Param("corpGr") String corpGr, @Param("tymd") String tymd);

    List<Ja010kDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("fymd") String fymd,
                                           @Param("tymd") String tymd,
                                           @Param("fundCd") String fundCd);

    int updateVcOld(Ja010kSaveDto.Ja010kItemSaveDto item);
}
