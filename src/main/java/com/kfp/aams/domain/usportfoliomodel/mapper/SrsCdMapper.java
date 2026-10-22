package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.SrsCdDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.SrsCdMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

/**
 * 해외파생 생성종목 (W_SRS_CD) MyBatis 매퍼
 */
@Mapper
public interface SrsCdMapper {

    /**
     * 해외파생 생성종목 마스터 목록 조회 (d_srs_cd1.srd)
     */
    List<SrsCdMasterDto> selectMasterList(@Param("isinCd") String isinCd);

    /**
     * 해외옵션 일별 시세 내역 조회 (d_srs_cd2.srd)
     */
    List<SrsCdDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                          @Param("jmCd") String jmCd,
                                          @Param("ymd") String ymd);

    /**
     * SZX0YM 참조하여 파생코드 자동 계산 (w_srs_cd dw_list::itemchanged_next)
     */
    String calcDerivedSrsCd(@Param("exprDate") String exprDate,
                            @Param("blbgTckr") String blbgTckr,
                            @Param("stkprc") BigDecimal stkprc,
                            @Param("isCallPut") String isCallPut);

    /**
     * SRS_CD 단건 등록
     */
    int insertMaster(SrsCdMasterDto dto);

    /**
     * SRS_CD 단건 수정
     */
    int updateMaster(SrsCdMasterDto dto);

    /**
     * SRS_CD 단건 삭제
     */
    int deleteMaster(SrsCdMasterDto dto);

    /**
     * SRS_CD 존재 여부 확인
     */
    int existsMaster(@Param("srsCd") String srsCd);
}
