package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021aDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021aMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface Ja021aMapper {

    /**
     * 마스터 목록 조회 (d_ja021a1)
     */
    List<Ja021aMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                           @Param("ymd") String ymd,
                                           @Param("trCd") String trCd,
                                           @Param("workDate") String workDate);

    /**
     * 디테일 목록 조회 (d_ja021a2)
     */
    List<Ja021aDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("ymd") String ymd,
                                           @Param("trCd") String trCd,
                                           @Param("balhCo") String balhCo,
                                           @Param("workDate") String workDate);

    /**
     * 발행기관 액면가 조회
     */
    BigDecimal selectBalhAekm(@Param("balhCo") String balhCo);

    /**
     * 우선주 존재 여부 확인 (3 or 1)
     */
    String selectWoosStockMethod(@Param("balhCo") String balhCo);

    // --- 마스터(SJT0BK) CUD ---
    int insertMaster(Ja021aMasterDto dto);
    int updateMaster(Ja021aMasterDto dto);
    int deleteMaster(Ja021aMasterDto dto);

    // --- 디테일(SJT0BJ) CUD ---
    int insertDetail(Ja021aDetailDto dto);
    int updateDetail(Ja021aDetailDto dto);
    int deleteDetail(Ja021aDetailDto dto);
    int deleteDetailsByMaster(Ja021aMasterDto dto);

    /**
     * 운용사명 조회 (SZX0AA.COMPANY_NAME)
     */
    String selectCompanyName(@Param("corpGr") String corpGr);
}
