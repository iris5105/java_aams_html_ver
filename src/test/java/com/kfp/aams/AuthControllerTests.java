package com.kfp.aams;

import com.kfp.aams.auth.controller.AuthController;
import com.kfp.aams.auth.dto.LoginRequestDto;
import com.kfp.aams.auth.dto.UserDto;
import com.kfp.aams.auth.mapper.querydsl.UserQueryDslRepository;
import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.security.JwtProvider;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.Cookie;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.context.SecurityContextHolder;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class AuthControllerTests {
    @AfterEach
    void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    @ParameterizedTest
    @CsvSource({"Y, 9999, 9999, RICO", "N, 9999, 2402, KFP", "Y, , 2402, KFP", "Y, 9999, 9999, "})
    void loginUsesActiveCompanyNameInTokenContextCookiesAndResponse(
            String adminYn, String savedCorpGr, String expectedCorpGr, String resolvedName) {
        JwtProvider jwtProvider = mock(JwtProvider.class);
        UserQueryDslRepository repository = mock(UserQueryDslRepository.class);
        WorkDateService workDates = mock(WorkDateService.class);
        AuthController controller = new AuthController(jwtProvider, repository, workDates);
        UserDto account = UserDto.builder().userId("101").userNm("tester")
                .corpGr("2402").adminYn(adminYn).companyName("Account company").build();
        when(repository.findUserForLogin("101", "password")).thenReturn(account);
        when(repository.findCompanyNameByCorpGr(expectedCorpGr)).thenReturn(resolvedName);
        when(workDates.getWorkDateOrDefault(expectedCorpGr)).thenReturn("20261028");
        when(workDates.getJunyongDateOrDefault(expectedCorpGr)).thenReturn("20261028");
        String expectedName = resolvedName != null ? resolvedName : "";
        when(jwtProvider.createAccessToken(any(UserDto.class))).thenAnswer(invocation -> {
            UserDto tokenUser = invocation.getArgument(0);
            assertThat(tokenUser.getCorpGr()).isEqualTo(expectedCorpGr);
            assertThat(tokenUser.getCompanyName()).isEqualTo(expectedName);
            return "access-token";
        });
        MockHttpServletRequest request = new MockHttpServletRequest();
        if (savedCorpGr != null) request.setCookies(new Cookie("savedCorpGr", savedCorpGr));
        MockHttpServletResponse response = new MockHttpServletResponse();

        var body = controller.login(new LoginRequestDto("101", "password", null), request, response).getBody();

        assertThat(body).isNotNull();
        assertThat(body.getCorpGr()).isEqualTo(expectedCorpGr);
        assertThat(body.getCorpNm()).isEqualTo(expectedName);
        assertThat(body.getCompanyName()).isEqualTo(expectedName);
        UserPrincipal principal = (UserPrincipal) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        assertThat(principal.getCompanyName()).isEqualTo(expectedName);
        for (String name : new String[]{"corpNm", "companyName"}) {
            assertThat(response.getCookie(name)).isNotNull();
            assertThat(URLDecoder.decode(response.getCookie(name).getValue(), StandardCharsets.UTF_8))
                    .isEqualTo(expectedName);
        }
        verify(jwtProvider).createAccessToken(any(UserDto.class));
    }
}
