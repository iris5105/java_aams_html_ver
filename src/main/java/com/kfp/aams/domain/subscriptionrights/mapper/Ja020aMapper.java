package com.kfp.aams.domain.subscriptionrights.mapper;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT1Dto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT4aDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT4bDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT5Dto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

/**
 * W_JA020A (공모청약 종목 및 배정등록) MyBatis 매퍼
 */
@Mapper
public interface Ja020aMapper {

    // 탭1: 기본정보 조회 (d_ja020a_t1a)
    List<Ja020aT1Dto> selectT1List(@Param("corpGr") String corpGr);

    // 신규 관리번호(jc_join) 채번
    String selectNextJcJoin();

    // SJG1JC 등록
    int insertSjg1jc(Ja020aT1Dto dto);

    // SJG1JC 수정
    int updateSjg1jc(Ja020aT1Dto dto);

    // SJG1JC 삭제
    int deleteSjg1jc(@Param("jcJoin") String jcJoin);

    // SJG1FC 신청/청약 데이터 존재 여부 확인
    int countSjg1fc(@Param("jcJoin") String jcJoin);

    // 탭2: 청약종목 목록 조회 (d_ja020a_t4a)
    List<Ja020aT4aDto> selectT4aList(@Param("corpGr") String corpGr);

    // 탭2: 펀드별 배정 목록 조회 (d_ja020a_t4b)
    List<Ja020aT4bDto> selectT4bList(@Param("corpGr") String corpGr,
                                     @Param("jcJoin") String jcJoin,
                                     @Param("jgTrCoCd") String jgTrCoCd,
                                     @Param("ymd") LocalDate ymd,
                                     @Param("workDate") LocalDate workDate);

    // 청약 헤더 저장 (sjg1jc_tr MERGE)
    int mergeSjg1jcTr(Ja020aT4aDto dto);

    // 펀드별 배정 저장 (sjg1fc UPDATE)
    int updateSjg1fc(Ja020aT4bDto dto);

    // 탭3: 수요예측참여총괄표 목록 조회 (d_ja020a_t5)
    List<Ja020aT5Dto> selectT5List(@Param("corpGr") String corpGr);
}
