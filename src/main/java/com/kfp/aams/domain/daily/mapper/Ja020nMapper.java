package com.kfp.aams.domain.daily.mapper;

import com.kfp.aams.domain.daily.dto.Ja020nSigaDto;
import com.kfp.aams.domain.daily.dto.Ja020nStatusDto;
import com.kfp.aams.domain.daily.dto.Ja020nTrDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * MyBatis Mapper for w_ja020n (국내 체결/잔고 엑셀자료 LOAD)
 * Multi-table joins:
 *   1. selectStatusList: LOAD_STATUS + FW_USER_MST (d_ja020n.srd)
 *   2. selectSigaList: SHM0HM_SIGA, SJM0JM_SIGA, SCM0CM_SIGA, SJM5SM_SIGA + SZM0IA (d_ja020n_siga.srd)
 *   3. selectTrList: SJT1JG + SZM0IA (d_ja020n_tr.srd)
 */
@Mapper
public interface Ja020nMapper {

    List<Ja020nStatusDto> selectStatusList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    List<Ja020nSigaDto> selectSigaList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);

    List<Ja020nTrDto> selectTrList(@Param("corpGr") String corpGr, @Param("ymd") String ymd);
}
