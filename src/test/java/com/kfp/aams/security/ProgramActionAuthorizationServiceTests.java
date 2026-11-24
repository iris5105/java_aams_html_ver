package com.kfp.aams.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kfp.aams.auth.dto.UserDto;
import com.kfp.aams.common.dto.ButtonAuthDto;
import com.kfp.aams.common.service.ButtonAuthService;
import com.kfp.aams.menu.dto.MenuDto;
import com.kfp.aams.menu.service.MenuService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.access.AccessDeniedException;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProgramActionAuthorizationServiceTests {

    private static final String SAVE_URI = "/api/assetmanagement/ja031c/save";

    @Mock
    private MenuService menuService;

    @Mock
    private ButtonAuthService buttonAuthService;

    @InjectMocks
    private ProgramActionAuthorizationService authorizationService;

    @Test
    void administratorBypassesProgramAndActionAuthorization() {
        UserPrincipal administrator = principal("Y");

        assertThatCode(() -> authorizationService.assertMutationAuthorized(administrator, SAVE_URI))
                .doesNotThrowAnyException();

        verify(menuService, never()).getMenuByPgmId(anyString());
        verify(buttonAuthService, never()).getButtonAuth(anyString(), anyString(), anyString(), anyString(), anyString());
    }

    @Test
    void regularUserWithUpdatePermissionCanSave() {
        UserPrincipal user = principal("N");
        when(menuService.getMenuByPgmId("W_JA031C"))
                .thenReturn(MenuDto.builder().pgmNo("00052").build());
        when(buttonAuthService.getButtonAuth("user", "2402", "N", "User", "00052"))
                .thenReturn(ButtonAuthDto.builder().commBtnAuthYn(true).updateAuthYn(true).build());

        assertThatCode(() -> authorizationService.assertMutationAuthorized(user, SAVE_URI))
                .doesNotThrowAnyException();
    }

    @Test
    void deletedRowsRequireDeletePermissionEvenWhenSaveIsAllowed() throws Exception {
        UserPrincipal user = principal("N");
        when(menuService.getMenuByPgmId("W_JA031C"))
                .thenReturn(MenuDto.builder().pgmNo("00052").build());
        when(buttonAuthService.getButtonAuth("user", "2402", "N", "User", "00052"))
                .thenReturn(ButtonAuthDto.builder().commBtnAuthYn(true).updateAuthYn(true).deleteAuthYn(false).build());

        assertThatThrownBy(() -> authorizationService.assertPayloadAuthorized(
                user,
                SAVE_URI,
                new ObjectMapper().readTree("{\"deletedRows\":[{\"rowStatus\":\"D\"}]}")))
                .isInstanceOf(AccessDeniedException.class)
                .hasMessageContaining("삭제");
    }

    private UserPrincipal principal(String adminYn) {
        return new UserPrincipal(UserDto.builder()
                .userId("user")
                .userNm("User")
                .corpGr("2402")
                .adminYn(adminYn)
                .build());
    }
}
