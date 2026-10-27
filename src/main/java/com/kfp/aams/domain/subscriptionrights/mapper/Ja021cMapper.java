package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021cDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021cMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface Ja021cMapper {

    /**
     * 탭 1: 중간배당(G15) 마스터 목록 (d_ja021c_t1)
     */
    List<Ja021cMasterDto> selectT1MasterList(@Param("corpGr") String corpGr, @Param("workDate") String workDate);

    /**
     * 탭 1: 펀드별 배당권리 상세 (d_ja021c_t22)
     */
    List<Ja021cDetailDto> selectT1DetailList(@Param("corpGr") String corpGr,
                                            @Param("ymd") String ymd,
                                            @Param("balhCo") String balhCo);

    /**
     * 탭 2: 현금중간배당확정(G23) 마스터 목록 (d_ja021c_t31)
     */
    List<Ja021cMasterDto> selectT2MasterList(@Param("corpGr") String corpGr, @Param("workDate") String workDate);

    /**
     * 탭 2: 펀드별 배당권리 상세 (d_ja021c_t32)
     */
    List<Ja021cDetailDto> selectT2DetailList(@Param("corpGr") String corpGr,
                                            @Param("ymd") String ymd,
                                            @Param("balhCo") String balhCo);

    /**
     * 탭 3: 주식중간배당확정(G23) 마스터 목록 (d_ja021c_t41)
     */
    List<Ja021cMasterDto> selectT3MasterList(@Param("corpGr") String corpGr, @Param("workDate") String workDate);

    /**
     * 탭 3: 펀드별 배당권리 상세 (d_ja021c_t42)
     */
    List<Ja021cDetailDto> selectT3DetailList(@Param("corpGr") String corpGr,
                                            @Param("ymd") String ymd,
                                            @Param("brokYmd") String brokYmd,
                                            @Param("balhCo") String balhCo);

    /**
     * 발행기관 액면가 조회
     */
    BigDecimal selectBalhAekm(@Param("balhCo") String balhCo);

    /**
     * 배정방법 기본값 조회 (woos_ilban_gb <> '0')
     */
    String selectBaejMthDefault(@Param("balhCo") String balhCo);

    /**
     * 마스터 등록 (SJT0BK)
     */
    int insertMaster(Ja021cMasterDto dto);

    /**
     * 마스터 수정 (SJT0BK)
     */
    int updateMaster(Ja021cMasterDto dto);

    /**
     * 마스터 삭제 (SJT0BK)
     */
    int deleteMaster(Ja021cMasterDto dto);
}
