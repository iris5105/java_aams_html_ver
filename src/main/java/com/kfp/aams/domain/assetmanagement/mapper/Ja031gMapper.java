package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja031gDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031gMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja031gMapper {

    /**
     * 현금/단기금융 매매현황 펀드 마스터 목록 조회 (d_ja031g.srd)
     */
    List<Ja031gMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                          @Param("fYmd") String fYmd,
                                          @Param("tYmd") String tYmd);

    /**
     * 현금/단기금융 매매내역 상세 목록 조회 (d_ja031g1.srd)
     */
    List<Ja031gDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                          @Param("fYmd") String fYmd,
                                          @Param("tYmd") String tYmd,
                                          @Param("fundCd") String fundCd);
}

