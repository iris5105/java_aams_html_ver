package com.kfp.aams.common.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * 파워빌더 pf_n_buttonrole 집계 결과 DTO (웹 툴바 버튼 노출 제어용)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ButtonAuthDto implements Serializable {
    private static final long serialVersionUID = 1L;

    private String pgmNo;
    private boolean commBtnAuthYn;
    private boolean cancelAuthYn;    // 새로고침 (.btn-refresh)
    private boolean retrieveAuthYn;  // 조회 (.btn-search)
    private boolean inputAuthYn;     // 입력 (.btn-input)
    private boolean ext1AuthYn;      // 복사 (.btn-copy)
    private boolean updateAuthYn;    // 저장 (.btn-save)
    private boolean deleteAuthYn;    // 삭제 (.btn-delete)
    private boolean printAuthYn;     // 인쇄 (.btn-print)
    private boolean excelAuthYn;     // 엑셀 (.btn-excel)
    private boolean executeAuthYn;   // 실행
    private boolean indivBtnAuthYn;  // 개별버튼 권한

    /**
     * 모든 버튼 권한을 활성화한 기본 객체 생성 (관리자 fallback 등)
     */
    public static ButtonAuthDto allAllowed(String pgmNo) {
        return ButtonAuthDto.builder()
                .pgmNo(pgmNo)
                .commBtnAuthYn(true)
                .cancelAuthYn(true)
                .retrieveAuthYn(true)
                .inputAuthYn(true)
                .ext1AuthYn(true)
                .updateAuthYn(true)
                .deleteAuthYn(true)
                .printAuthYn(true)
                .excelAuthYn(true)
                .executeAuthYn(true)
                .indivBtnAuthYn(true)
                .build();
    }

    /**
     * 공통 버튼 비활성화 (comm_btn_auth_yn = false) 상태 객체 생성
     */
    public static ButtonAuthDto disabled(String pgmNo) {
        return ButtonAuthDto.builder()
                .pgmNo(pgmNo)
                .commBtnAuthYn(false)
                .cancelAuthYn(false)
                .retrieveAuthYn(false)
                .inputAuthYn(false)
                .ext1AuthYn(false)
                .updateAuthYn(false)
                .deleteAuthYn(false)
                .printAuthYn(false)
                .excelAuthYn(false)
                .executeAuthYn(false)
                .indivBtnAuthYn(false)
                .build();
    }
}
