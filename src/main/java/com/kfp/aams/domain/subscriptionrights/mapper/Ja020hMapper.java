package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020hDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * W_JA020H (채권 펀드/종목별 시가등록) MyBatis 매퍼
 */
@Mapper
public interface Ja020hMapper {

    /**
     * 채권 펀드/종목별 시가 목록 조회 (d_ja020h.srd)
     */
    List<Ja020hDto> selectJa020hList(@Param("corpGr") String corpGr,
                                     @Param("ymd") LocalDate ymd);

    /**
     * 채권 시가평가액 수정 (SCM0CM)
     */
    int updateSigaAek(Ja020hDto dto);
}
