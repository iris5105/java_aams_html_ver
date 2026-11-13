package com.kfp.aams.domain.assetmanagement.mapper;

import com.kfp.aams.domain.assetmanagement.dto.Ja030mDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030mCopyDateDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

@Mapper
public interface Ja030mMapper {
    List<Ja030mDto> selectList(@Param("corpGr") String corpGr,
                               @Param("workDate") LocalDate workDate,
                               @Param("allCorp") boolean allCorp);
    String selectNextJmCd(@Param("corpGr") String corpGr, @Param("balhYmd") LocalDate balhYmd, @Param("cashCd") String cashCd);
    LocalDate selectSanghwYmdForBalhYmd(@Param("balhYmd") LocalDate balhYmd);
    Ja030mCopyDateDto selectCopyDates(@Param("balhYmd") LocalDate balhYmd, @Param("sanghwYmd") LocalDate sanghwYmd);
    int insert(Ja030mDto row);
    int update(Ja030mDto row);
    int delete(@Param("corpGr") String corpGr, @Param("jmCd") String jmCd);
}
