package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.RunCheckResultDto;
import com.kfp.aams.domain.daily.dto.RunItemDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface RunMapper {

    List<RunItemDto> selectRunProgramList();

    void callSrExec(Map<String, Object> paramMap);

    int deleteWfrmerr();

    List<RunCheckResultDto> selectCheckResults(@Param("corpGr") String corpGr);
}
