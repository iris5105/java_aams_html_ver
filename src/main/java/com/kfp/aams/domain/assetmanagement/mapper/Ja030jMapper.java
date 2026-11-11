package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030jDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface Ja030jMapper {

    /**
     * 채권 잔고/수익 상세 목록 조회
     */
    List<Ja030jDto> selectJa030jList(@Param("corpGr") String corpGr,
                                     @Param("fymd") String fymd,
                                     @Param("tymd") String tymd,
                                     @Param("gubun") String gubun,
                                     @Param("cashCd") String cashCd,
                                     @Param("hjCd") String hjCd,
                                     @Param("fundCd") String fundCd);

    /**
     * 채권 상세 정보 조회 프로시저 호출 (KFP.SR_JA030J)
     */
    void callSrJa030j(Map<String, Object> params);

    /**
     * 채권 상세 정보 직결 조회 Fallback
     */
    com.kfp.aams.domain.assetmanagement.dto.Ja030jDetailDto selectJa030jDetail(@Param("corpGr") String corpGr,
                                                                               @Param("ymd") String ymd,
                                                                               @Param("fundCd") String fundCd,
                                                                               @Param("jmCd") String jmCd);
}
