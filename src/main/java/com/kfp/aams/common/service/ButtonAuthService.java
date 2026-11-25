package com.kfp.aams.common.service;

import com.kfp.aams.common.dto.ButtonAuthDto;
import com.kfp.aams.common.dto.ButtonAuthRawDto;
import com.kfp.aams.common.mapper.ButtonAuthMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.function.Function;

/**
 * 파워빌더 pf_n_buttonrole.sru 및 fw_d_commbtnauth.srd 기반 공통 버튼 권한 서비스
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ButtonAuthService {

    private final ButtonAuthMapper buttonAuthMapper;

    /**
     * 특정 사용자 및 프로그램(pgmNo)에 대한 버튼 권한 조회 및 판별
     *
     * @param userId  사용자 ID
     * @param corpGr  회사 그룹 코드
     * @param adminYn 슈퍼관리자 여부 ('Y'/'N')
     * @return ButtonAuthDto 최종 버튼별 boolean 권한 결과
     */
    public ButtonAuthDto getButtonAuth(String userId, String corpGr, String adminYn, String pgmNo) {
        return getButtonAuth(userId, corpGr, adminYn, null, pgmNo);
    }

    @SuppressWarnings("null")
    public ButtonAuthDto getButtonAuth(String userId, String corpGr, String adminYn, String userNm, String pgmNo) {
        if (pgmNo == null || pgmNo.trim().isEmpty()) {
            return ButtonAuthDto.allAllowed(pgmNo);
        }

        String cleanPgmNo = pgmNo.trim();
        String today = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE); // yyyyMMdd
        boolean isAdmin = "Y".equalsIgnoreCase(adminYn);

        // 1. 파워빌더 fw_d_commbtnauth.srd 쿼리 결과 조회 (사용자 역할 기반)
        List<ButtonAuthRawDto> authList = buttonAuthMapper.selectButtonAuthListByUser(userId, corpGr, cleanPgmNo,
                today, userNm);

        // 2. 관리자(adminYn='Y')인 경우에도 사용자 역할 매핑이 없으면 해당 화면(pgmNo)의 버튼 설정을 조회하여 따름
        if ((authList == null || authList.isEmpty()) && isAdmin) {
            authList = buttonAuthMapper.selectButtonAuthListByPgm(cleanPgmNo, today);
        }

        // 3. 권한 데이터가 존재하지 않는 경우
        if (authList == null || authList.isEmpty()) {
            if (isAdmin) {
                // DB에 등록되지 않은 프로그램에 대한 관리자 fallback
                return ButtonAuthDto.allAllowed(pgmNo);
            }
            log.warn("[ButtonAuthService] No button authority found for user: {}, pgmNo: {}", userId, pgmNo);
            return ButtonAuthDto.disabled(pgmNo);
        }

        // 3. pf_n_buttonrole.sru의 of_getcolumnmeanvalue 로직 재현:
        // 조회된 복수 행 중 하나라도 'Y'이면 True, 그렇지 않으면 False
        boolean commBtnAuthYn = isAnyColumnY(authList, ButtonAuthRawDto::getCommBtnAuthYn);

        // comm_btn_auth_yn이 False인 경우 모든 공통 버튼 권한은 False 처리 (pf_n_buttonrole Line 79-97
        // 동일)
        if (!commBtnAuthYn) {
            return ButtonAuthDto.disabled(pgmNo);
        }

        return ButtonAuthDto.builder()
                .pgmNo(pgmNo)
                .commBtnAuthYn(true)
                .cancelAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getCancelAuthYn)) // 새로고침 (.btn-refresh)
                .retrieveAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getRetrieveAuthYn)) // 조회 (.btn-search)
                .inputAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getInputAuthYn)) // 입력 (.btn-input)
                .ext1AuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getExt1AuthYn)) // 복사 (.btn-copy)
                .updateAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getUpdateAuthYn)) // 저장 (.btn-save)
                .deleteAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getDeleteAuthYn)) // 삭제 (.btn-delete)
                .printAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getPrintAuthYn)) // 인쇄 (.btn-print)
                .excelAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getExcelAuthYn)) // 엑셀 (.btn-excel)
                .executeAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getExecuteAuthYn)) // 실행
                .indivBtnAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getIndivBtnAuthYn)) // 개별버튼 권한
                .build();
    }

    /**
     * pf_n_buttonrole.sru의 of_getcolumnmeanvalue 핵심 로직:
     * 행 목록 중 지정한 컬럼 값이 하나라도 'Y'이면 true 반환
     */
    private boolean isAnyColumnY(List<ButtonAuthRawDto> list, Function<ButtonAuthRawDto, String> getter) {
        if (list == null || list.isEmpty())
            return false;
        return list.stream()
                .filter(java.util.Objects::nonNull)
                .map(getter)
                .anyMatch(val -> val != null && "Y".equalsIgnoreCase(val.trim()));
    }
}
