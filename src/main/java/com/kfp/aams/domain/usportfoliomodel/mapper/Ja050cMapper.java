package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja050cFundDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja050cMapper {

    /**
     * w_ja050c 고객(펀드) 목록 조회 (d_fund_select)
     * 
     * @param corpGr 회사그룹코드
     * @param ymd 기준일자 (YYYYMMDD or YYYY-MM-DD)
     * @param procStep 구분 ('1': 일반, '9': 수기)
     * @return 펀드 목록
     */
    List<Ja050cFundDto> selectFundList(
            @Param("corpGr") String corpGr,
            @Param("ymd") String ymd,
            @Param("procStep") String procStep
    );
}
