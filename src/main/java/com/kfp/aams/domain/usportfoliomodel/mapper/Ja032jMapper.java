package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032jDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032jMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 해외주식종가/업종지수 등록 (W_JA032J) 매퍼
 */
@Mapper
public interface Ja032jMapper {

    /**
     * 1. 마스터 종가일자 및 주차 목록 조회 (d_ja032j1)
     */
    List<Ja032jMasterDto> selectMasterList(@Param("corpGr") String corpGr);

    /**
     * 2. 디테일 해외주식 종가 목록 조회 (d_ja032j2)
     */
    List<Ja032jDetailDto> selectDetailList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 3. 디테일 등록 (SYT0LP)
     */
    int insertDetail(Ja032jDetailDto dto);

    /**
     * 4. 디테일 수정 (SYT0LP)
     */
    int updateDetail(Ja032jDetailDto dto);

    /**
     * 5. 디테일 삭제 (SYT0LP)
     */
    int deleteDetail(@Param("corpGr") String corpGr, @Param("ymd") String ymd, @Param("jmCd") String jmCd);
}
