package com.kfp.aams.domain.usportfoliomodel.mapper;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032hDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface Ja032hMapper {

    /**
     * 해외 업종/지수/환율 코드 목록 조회
     */
    List<Ja032hDto> selectList(@Param("frid") String frid, @Param("keyword") String keyword);

    /**
     * 단건 존재 여부 카운트
     */
    int selectCountById(@Param("frid") String frid, @Param("frgn") String frgn);

    /**
     * 단건 등록
     */
    int insert(Ja032hDto dto);

    /**
     * 단건 수정
     */
    int update(Ja032hDto dto);

    /**
     * 단건 삭제
     */
    int delete(@Param("frid") String frid, @Param("frgn") String frgn);
}
