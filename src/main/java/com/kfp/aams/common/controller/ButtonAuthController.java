package com.kfp.aams.common.controller;

import com.kfp.aams.common.dto.ButtonAuthDto;
import com.kfp.aams.common.service.ButtonAuthService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * 접속 사용자의 프로그램별 공통 버튼 권한 조회 Controller
 * (PowerBuilder pf_n_buttonrole + fw_d_commbtnauth.srd 연동)
 */
@Slf4j
@RestController
@RequestMapping("/api/common/button-auth")
@RequiredArgsConstructor
public class ButtonAuthController {

    private final ButtonAuthService buttonAuthService;

    /**
     * 특정 프로그램(pgmNo)에 대한 로그인 사용자의 버튼 권한 조회
     *
     * @param pgmNo     프로그램 번호 (예: '00052', '00804')
     * @param principal 로그인 사용자 인증 주체
     * @return ButtonAuthDto
     */
    @GetMapping
    public ButtonAuthDto getButtonAuth(@RequestParam(name = "pgmNo") String pgmNo,
                                       @AuthenticationPrincipal UserPrincipal principal) {
        if (principal == null || principal.getUserId() == null || principal.getUserId().isBlank()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "인증되지 않은 접근입니다.");
        }

        return buttonAuthService.getButtonAuth(
                principal.getUserId(),
                principal.getCorpGr(),
                principal.getAdminYn(),
                pgmNo
        );
    }
}
