package com.kfp.aams.domain.home.mapper;

import com.kfp.aams.domain.auth.dto.*;
import com.kfp.aams.domain.home.dto.*;
import com.kfp.aams.domain.menu.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface HomeMapper {

    /**
     * d_home02: Multi-table JOIN (SZM0GI + SZM0IA)
     */
    List<GyulAccountDto> selectHome02List(@Param("corpGr") String corpGr);

    /**
     * d_home03: Multi-table JOIN (SCM0CM + SCJ0IG + SCM0CJ + SZM0IA)
     */
    List<RateChangeDto> selectHome03List(@Param("corpGr") String corpGr);

    /**
     * d_home04: Multi-table Subquery (SJG1JC + SZX0AA)
     */
    List<PublicStockDto> selectHome04List(@Param("corpGr") String corpGr);

    /**
     * d_home05: Multi-table JOIN (sjg1jc_tr + sjg1jc)
     */
    List<SubscriptionDto> selectHome05List(@Param("corpGr") String corpGr);

    /**
     * d_home5_notice_1: Multi-table Subquery (fw_docu_mst + fw_docu_log)
     */
    List<NoticeDto> selectHome5NoticeList(@Param("userId") String userId);

    /**
     * 순자산 및 계좌현황 Chart (uo_cht1 / dw_cht9): fw_day_chtdata
     */
    List<ChtDataDto> selectChtDataList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);
}
