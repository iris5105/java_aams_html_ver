package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021bCorpDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bFundDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bItemDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface Ja021bMapper {

    /**
     * 좌측 회사 목록 조회 (dl_corp_gr)
     */
    List<Ja021bCorpDto> selectCorpList(@Param("ym") String ym,
                                       @Param("customerGr") String customerGr,
                                       @Param("corpGr") String corpGr);

    /**
     * 탭 1: 예상배당공시 마스터 목록 조회 (d_ja021b_t11)
     */
    List<Ja021bMasterDto> selectT1MasterList(@Param("corpGr") String corpGr,
                                            @Param("ym") String ym,
                                            @Param("customerGr") String customerGr);

    /**
     * 탭 1 & 팝업: 종목별 배당 목록 조회 (d_ja021b_t12, d_ja021b_p1)
     */
    List<Ja021bItemDto> selectItemList(@Param("corpGr") String corpGr,
                                       @Param("ymd") String ymd,
                                       @Param("trCd") String trCd,
                                       @Param("balhCo") String balhCo);

    /**
     * 팝업: 종목마스터에서 초기 종목 목록 가져오기 (sjm0jj)
     */
    List<Ja021bItemDto> selectInitialBalhItems(@Param("corpGr") String corpGr,
                                              @Param("balhCo") String balhCo);

    /**
     * 탭 2: 운용사별 예상배당 마스터 목록 조회 (d_ja021b_t21)
     */
    List<Ja021bMasterDto> selectT2MasterList(@Param("corpGr") String corpGr,
                                            @Param("ym") String ym,
                                            @Param("workDate") String workDate);

    /**
     * 탭 2: 펀드별 배당권리 상세 조회 (d_ja021b_t22)
     */
    List<Ja021bFundDetailDto> selectT2DetailList(@Param("corpGr") String corpGr,
                                                @Param("ymd") String ymd,
                                                @Param("balhCo") String balhCo);

    /**
     * 탭 3: 현금확정배당(G20) 마스터 목록 조회 (d_ja021b_t31)
     */
    List<Ja021bMasterDto> selectT3MasterList(@Param("customerGr") String customerGr,
                                            @Param("ym") String ym,
                                            @Param("workDate") String workDate);

    /**
     * 탭 3~5: 펀드별 배당권리 상세 조회 (d_ja021b_t32, t42, t52)
     */
    List<Ja021bFundDetailDto> selectT3DetailList(@Param("corpGr") String corpGr,
                                                @Param("customerGr") String customerGr,
                                                @Param("brokYmd") String brokYmd,
                                                @Param("balhCo") String balhCo);

    /**
     * 탭 4: 주식확정배당(G20) 마스터 목록 조회 (d_ja021b_t41)
     */
    List<Ja021bMasterDto> selectT4MasterList(@Param("customerGr") String customerGr,
                                            @Param("ym") String ym,
                                            @Param("workDate") String workDate);

    /**
     * 탭 5: 2차(주총)확정(G25) 마스터 목록 조회 (d_ja021b_t51)
     */
    List<Ja021bMasterDto> selectT5MasterList(@Param("customerGr") String customerGr,
                                            @Param("ym") String ym,
                                            @Param("workDate") String workDate);

    /**
     * 발행사 액면가 조회 (sjx0jb.aekm)
     */
    BigDecimal selectBalhAekm(@Param("balhCo") String balhCo);

    /**
     * 마스터 (SJT0BK) CUD
     */
    int insertMaster(Ja021bMasterDto dto);

    int updateMaster(Ja021bMasterDto dto);

    int deleteMaster(Ja021bMasterDto dto);

    /**
     * 종목별 상세 (SJT0BJ) CUD
     */
    int insertItem(Ja021bItemDto dto);

    int updateItem(Ja021bItemDto dto);

    int deleteItem(Ja021bItemDto dto);

    int deleteItemsByMaster(Ja021bMasterDto dto);
}
