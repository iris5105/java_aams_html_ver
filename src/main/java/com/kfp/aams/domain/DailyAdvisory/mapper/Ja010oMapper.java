package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja010oMasterDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * MyBatis Mapper for w_ja010o (d_ja010o1.srd / SJM0JM + SJM0JM_COLL + SJM0JJ)
 */
@Mapper
public interface Ja010oMapper {

    /**
     * 주식 신용/대출잔고 내역 조회 (d_ja010o1.srd)
     */
    List<Ja010oMasterDto> selectJa010oList(@Param("corpGr") String corpGr, 
                                          @Param("ymd") String ymd, 
                                          @Param("fundCd") String fundCd);

    /**
     * 펀드 선택 목록 조회 (corpGr 기준 유효 펀드 목록)
     */
    List<Map<String, Object>> selectFundList(@Param("corpGr") String corpGr);

    /**
     * SJM0JM_COLL 신용/대출 담보 저장 (MERGE INTO)
     */
    int mergeCollateral(Ja010oMasterDto dto);

    /**
     * SJM0JM_COLL 신용/대출 담보 삭제
     */
    int deleteCollateral(Ja010oMasterDto dto);
}
