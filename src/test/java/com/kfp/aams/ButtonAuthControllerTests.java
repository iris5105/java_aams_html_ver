package com.kfp.aams;

import com.kfp.aams.common.controller.ButtonAuthController;
import com.kfp.aams.common.dto.ButtonAuthDto;
import com.kfp.aams.security.UserPrincipal;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.web.server.ResponseStatusException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
public class ButtonAuthControllerTests {

    @Autowired
    private ButtonAuthController buttonAuthController;

    @Test
    @DisplayName("ButtonAuthController: 미인증 사용자의 API 요청 시 ResponseStatusException(UNAUTHORIZED) 발생")
    void testUnauthorizedAccess() {
        assertThatThrownBy(() -> buttonAuthController.getButtonAuth("00052", null))
                .isInstanceOf(ResponseStatusException.class)
                .hasMessageContaining("인증되지 않은 접근입니다.");
    }

    @Test
    @DisplayName("ButtonAuthController: 인증된 사용자(UserPrincipal)의 프로그램(00052) 버튼 권한 정상 반환")
    void testAuthorizedUserButtonAuth() {
        UserPrincipal principal = new UserPrincipal("admin", "2402");

        ButtonAuthDto auth = buttonAuthController.getButtonAuth("00052", principal);

        assertThat(auth).isNotNull();
        assertThat(auth.getPgmNo()).isEqualTo("00052");
        assertThat(auth.isCommBtnAuthYn()).isTrue();
    }
}
