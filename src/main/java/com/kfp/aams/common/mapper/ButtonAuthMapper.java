package com.kfp.aams.common.mapper;

import com.kfp.aams.common.dto.ButtonAuthRawDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 파워빌더 fw_d_commbtnauth.srd 기반 버튼 권한 조회 Mapper
 */
@Mapper
public interface ButtonAuthMapper {

    /**
     * 사용자의 유효한 role_no 목록 조회 (n_authority.of_getuserroleinfo 기반)
     */
    List<String> selectUserRoleNos(@Param("userId") String userId,
                                   @Param("corpGr") String corpGr,
                                   @Param("today") String today);

    /**
     * fw_d_commbtnauth.srd 원본 쿼리: role_no 목록 및 pgm_no로 버튼 권한 목록 조회
     */
    List<ButtonAuthRawDto> selectButtonAuthList(@Param("roleNos") List<String> roleNos,
                                                @Param("pgmNo") String pgmNo,
                                                @Param("today") String today);

    /**
     * userId, corpGr, pgmNo를 통한 원스톱 버튼 권한 목록 조회
     */
    List<ButtonAuthRawDto> selectButtonAuthListByUser(@Param("userId") String userId,
                                                     @Param("corpGr") String corpGr,
                                                     @Param("pgmNo") String pgmNo,
                                                     @Param("today") String today);
}
