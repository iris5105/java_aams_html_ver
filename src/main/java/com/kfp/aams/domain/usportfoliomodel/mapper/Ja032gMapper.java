package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032gDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032gMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface Ja032gMapper {

    /**
     * 해외 파생종목 목록 조회 (d_ja032g1)
     */
    List<Ja032gMasterDto> selectMasterList(@Param("corpGr") String corpGr,
                                           @Param("lsyYmd") String lsyYmd);

    /**
     * 해외옵션 일별 시세 내역 조회 (d_ja032g2)
     */
    List<Ja032gDetailDto> selectDetailList(@Param("corpGr") String corpGr,
                                           @Param("ymd") String ymd,
                                           @Param("jmCd") String jmCd);

    /**
     * 마스터 SYM0YA 등록
     */
    int insertMaster(Ja032gMasterDto dto);

    /**
     * 마스터 SYM0YA 수정
     */
    int updateMaster(Ja032gMasterDto dto);

    /**
     * 마스터 SYM0YA 삭제
     */
    int deleteMaster(@Param("corpGr") String corpGr,
                     @Param("jmCd") String jmCd,
                     @Param("jasanGb") String jasanGb,
                     @Param("sedol") String sedol);

    /**
     * 디테일 SYT0LP 등록
     */
    int insertDetail(Ja032gDetailDto dto);

    /**
     * 디테일 SYT0LP 수정
     */
    int updateDetail(Ja032gDetailDto dto);

    /**
     * 디테일 SYT0LP 삭제
     */
    int deleteDetail(@Param("corpGr") String corpGr,
                     @Param("ymd") String ymd,
                     @Param("jmCd") String jmCd);

    /**
     * 거래소 코드(stockGb) 기반 국가코드 조회
     */
    String selectNationByStockGb(@Param("stockGb") String stockGb);

    /**
     * 국가코드 기반 기본 통화 조회
     */
    String selectCurrencyByNation(@Param("nationCd") String nationCd);

    /**
     * 통화 기반 국가코드 조회
     */
    String selectNationByCurrency(@Param("currency") String currency);
}
