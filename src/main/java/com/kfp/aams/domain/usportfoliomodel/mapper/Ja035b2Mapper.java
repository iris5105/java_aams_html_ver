package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035b2Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface Ja035b2Mapper {

    /**
     * 해외파생 매매내역 목록 조회 (d_ja035b2)
     */
    List<Ja035b2Dto> selectList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * 종목 정보 단건 조회 (SYM0YA)
     */
    Map<String, Object> selectItemInfo(@Param("corpGr") String corpGr, @Param("jmCd") String jmCd);

    /**
     * 해당 일자 최대 TR_SEQ 조회
     */
    Long selectMaxTrSeq(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    /**
     * SYT1MG 매매내역 신규 등록
     */
    int insertSyt1mg(Ja035b2Dto dto);

    /**
     * SYT1MG 매매내역 수정
     */
    int updateSyt1mg(Ja035b2Dto dto);

    /**
     * SYT1MG 매매내역 삭제
     */
    int deleteSyt1mg(@Param("corpGr") String corpGr, @Param("trYmd") String trYmd, @Param("trSeq") Long trSeq);

    /**
     * 최종 영업일자(최신 거래일자) 조회
     */
    String selectLatestWorkDate(@Param("corpGr") String corpGr);
}
