package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032kFundDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface Ja032kMapper {

    /**
     * w_ja032k 자산현황 펀드 목록 조회 (d_ja036e.srd 매핑)
     *
     * @param corpGr 회사그룹코드
     * @param ymd    조회일자 (YYYY-MM-DD 또는 YYYYMMDD)
     * @param mgCd   증권사코드 (기본값 '%')
     * @return 펀드 목록
     */
    List<Ja032kFundDto> selectFundList(@Param("corpGr") String corpGr,
                                       @Param("ymd") String ymd,
                                       @Param("mgCd") String mgCd);

    /**
     * 증권사 선택 드롭다운 목록 (szm0ia.mg_cd 기준)
     *
     * @param corpGr 회사그룹코드
     * @return [ {code: '00020', name: '...'}, ... ]
     */
    List<Map<String, String>> selectBrokerList(@Param("corpGr") String corpGr);
}
