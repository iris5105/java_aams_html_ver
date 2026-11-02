package com.kfp.aams.domain.subscriptionrights.mapper;
import com.kfp.aams.domain.subscriptionrights.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDate;
import java.util.List;
@Mapper public interface Ja021hMapper {
 List<Ja021hMasterDto> selectMaster(@Param("tab") String tab,@Param("workDate") LocalDate workDate);
 List<Ja021hDetailDto> selectDetail(@Param("corpGr") String corpGr,@Param("jmCd") String jmCd,@Param("ymd") String ymd);
}
