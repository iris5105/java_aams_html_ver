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
     * @param pgmNo   프로그램 번호 (예: '00052', '00804')
     * @return ButtonAuthDto 최종 버튼별 boolean 권한 결과
     */
    public ButtonAuthDto getButtonAuth(String userId, String corpGr, String adminYn, String pgmNo) {
        if (pgmNo == null || pgmNo.trim().isEmpty()) {
            return ButtonAuthDto.allAllowed(pgmNo);
        }

        String today = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE); // yyyyMMdd

        // 1. 파워빌더 fw_d_commbtnauth.srd 쿼리 결과 조회
        List<ButtonAuthRawDto> authList = buttonAuthMapper.selectButtonAuthListByUser(userId, corpGr, pgmNo.trim(), today);

        // 2. 권한 데이터가 존재하지 않는 경우
        if (authList == null || authList.isEmpty()) {
            // 관리자 계정이거나 미지정 프로그램인 경우 기본 허용 fallback
            if ("Y".equalsIgnoreCase(adminYn)) {
                log.info("[ButtonAuthService] Admin fallback allAllowed for user: {}, pgmNo: {}", userId, pgmNo);
                return ButtonAuthDto.allAllowed(pgmNo);
            }
            log.warn("[ButtonAuthService] No button authority found for user: {}, pgmNo: {}", userId, pgmNo);
            return ButtonAuthDto.disabled(pgmNo);
        }

        // 3. pf_n_buttonrole.sru의 of_getcolumnmeanvalue 로직 재현:
        //    조회된 복수 행 중 하나라도 'Y'이면 True, 그렇지 않으면 False
        boolean commBtnAuthYn = isAnyColumnY(authList, ButtonAuthRawDto::getCommBtnAuthYn);

        // comm_btn_auth_yn이 False인 경우 모든 공통 버튼 권한은 False 처리 (pf_n_buttonrole Line 79-97 동일)
        if (!commBtnAuthYn) {
            return ButtonAuthDto.disabled(pgmNo);
        }

        return ButtonAuthDto.builder()
                .pgmNo(pgmNo)
                .commBtnAuthYn(true)
                .cancelAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getCancelAuthYn))     // 새로고침 (.btn-refresh)
                .retrieveAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getRetrieveAuthYn)) // 조회 (.btn-search)
                .inputAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getInputAuthYn))       // 입력 (.btn-input)
                .ext1AuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getExt1AuthYn))         // 복사 (.btn-copy)
                .updateAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getUpdateAuthYn))     // 저장 (.btn-save)
                .deleteAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getDeleteAuthYn))     // 삭제 (.btn-delete)
                .printAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getPrintAuthYn))       // 인쇄 (.btn-print)
                .excelAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getExcelAuthYn))       // 엑셀 (.btn-excel)
                .executeAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getExecuteAuthYn))   // 실행
                .indivBtnAuthYn(isAnyColumnY(authList, ButtonAuthRawDto::getIndivBtnAuthYn)) // 개별버튼 권한
                .build();
    }

    /**
     * pf_n_buttonrole.sru의 of_getcolumnmeanvalue 핵심 로직:
     * 행 목록 중 지정한 컬럼 값이 하나라도 'Y'이면 true 반환
     */
    private boolean isAnyColumnY(List<ButtonAuthRawDto> list, Function<ButtonAuthRawDto, String> getter) {
        if (list == null || list.isEmpty()) return false;
        return list.stream()
                .map(getter)
                .anyMatch(val -> val != null && "Y".equalsIgnoreCase(val.trim()));
    }
}
