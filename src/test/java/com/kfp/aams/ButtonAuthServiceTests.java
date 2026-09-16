package com.kfp.aams;

import com.kfp.aams.common.dto.ButtonAuthDto;
import com.kfp.aams.common.service.ButtonAuthService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class ButtonAuthServiceTests {

    @Autowired
    private ButtonAuthService buttonAuthService;

    @Test
    @DisplayName("ButtonAuthService: Null 또는 빈 pgmNo 요청 시 기본 허용 객체 반환")
    void testEmptyPgmNo() {
        ButtonAuthDto auth = buttonAuthService.getButtonAuth("testUser", "2402", "N", "");
        assertThat(auth).isNotNull();
        assertThat(auth.isCommBtnAuthYn()).isTrue();
    }

    @Test
    @DisplayName("ButtonAuthService: 관리자(adminYn='Y') fallback 테스트")
    void testAdminFallback() {
        ButtonAuthDto auth = buttonAuthService.getButtonAuth("admin", "2402", "Y", "99999_NON_EXIST");
        assertThat(auth).isNotNull();
        assertThat(auth.isCommBtnAuthYn()).isTrue();
        assertThat(auth.isRetrieveAuthYn()).isTrue();
        assertThat(auth.isCancelAuthYn()).isTrue();
    }

    @Test
    @DisplayName("ButtonAuthService: 실제 DB 프로그램 번호(예: 00052)로 버튼 권한 조회 테스트")
    void testActualPgmNoQuery() {
        // 00052: fw_role_pgm에 등록된 프로그램
        ButtonAuthDto auth = buttonAuthService.getButtonAuth("admin", "2402", "Y", "00052");
        assertThat(auth).isNotNull();
        assertThat(auth.getPgmNo()).isEqualTo("00052");
    }
}
