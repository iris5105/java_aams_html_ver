package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020jDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * W_JA020J (현금 펀드/종목별 시가등록) MyBatis 매퍼
 */
@Mapper
public interface Ja020jMapper {

    /**
     * 현금 펀드/종목별 시가 목록 조회 (d_ja020j.srd)
     */
    List<Ja020jDto> selectJa020jList(@Param("corpGr") String corpGr,
                                     @Param("ymd") LocalDate ymd);

    /**
     * 현금 시가평가액 수정 (SHM0HM)
     */
    int updateSigaAek(Ja020jDto dto);
}
