package com.kfp.aams.domain.dailyadvisory;

import com.kfp.aams.domain.dailyadvisory.controller.Ja010jController;
import com.kfp.aams.security.UserPrincipal;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.format.support.DefaultFormattingConversionService;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
public class Ja010jTests {

    @Autowired
    private Ja010jController ja010jController;

    private MockMvc mockMvc;

    @BeforeEach
    void setup() {
        mockMvc = MockMvcBuilders.standaloneSetup(ja010jController)
                .setConversionService(new DefaultFormattingConversionService())
                .build();
    }

    @Test
    @DisplayName("w_ja010j 조회 API 날짜 포맷 (YYYYMMDD 및 YYYY-MM-DD) 바인딩 검증")
    void testGetListDateFormatBinding() throws Exception {
        // 1. yyyyMMdd (8자리 숫자: 20261012)
        mockMvc.perform(get("/api/daily/ja010j/list")
                        .param("corpGr", "2402")
                        .param("ymd", "20261012"))
                .andExpect(status().isOk());

        // 2. yyyy-MM-dd (표준 포맷: 2026-10-12)
        mockMvc.perform(get("/api/daily/ja010j/list")
                        .param("corpGr", "2402")
                        .param("ymd", "2026-10-12"))
                .andExpect(status().isOk());

        // 3. yyyy.MM.dd (점 구분자: 2026.10.12)
        mockMvc.perform(get("/api/daily/ja010j/list")
                        .param("corpGr", "2402")
                        .param("ymd", "2026.10.12"))
                .andExpect(status().isOk());
    }

    @Autowired
    private org.thymeleaf.spring6.SpringTemplateEngine templateEngine;

    @Test
    @DisplayName("w_ja010j 뷰 템플릿 파싱 및 렌더링 검증")
    void testJa010jTemplateRendering() {
        org.thymeleaf.context.Context context = new org.thymeleaf.context.Context();
        context.setVariable("fullpgm2", "사무관리 > 자문일일 > 공모청약 수요예측 참여표(회사)");
        context.setVariable("corpGr", "2402");
        context.setVariable("adminYn", "N");
        context.setVariable("isAdmin", false);
        context.setVariable("initialTymd", "2026-10-23");
        context.setVariable("initialFymd", "2026-07-23");
        context.setVariable("tymd", "2026-10-23");
        context.setVariable("fymd", "2026-07-23");
        context.setVariable("workDate", "2026-10-23");

        String result = templateEngine.process("views/dailyadvisory/w_ja010j", context);
        org.junit.jupiter.api.Assertions.assertNotNull(result);
        org.junit.jupiter.api.Assertions.assertTrue(result.contains("ja010j-container"));
    }

    @Test
    @DisplayName("w_ja010j 컨트롤러 뷰 엔드포인트 반환 및 모델 속성 검증")
    void testJa010jViewController() {
        org.springframework.ui.ConcurrentModel model = new org.springframework.ui.ConcurrentModel();
        UserPrincipal principal = new UserPrincipal("admin", "2402");
        org.springframework.mock.web.MockHttpServletRequest request = new org.springframework.mock.web.MockHttpServletRequest();

        String viewName = ja010jController.ja010jView(
                principal,
                "2402",
                java.time.LocalDate.parse("2026-07-23"),
                java.time.LocalDate.parse("2026-10-23"),
                null,
                null,
                null,
                request,
                model
        );

        org.junit.jupiter.api.Assertions.assertEquals("views/dailyadvisory/w_ja010j", viewName);
        org.junit.jupiter.api.Assertions.assertEquals("2402", model.get("corpGr"));
        org.junit.jupiter.api.Assertions.assertNotNull(model.get("initialTymd"));
        org.junit.jupiter.api.Assertions.assertNotNull(model.get("initialFymd"));
        org.junit.jupiter.api.Assertions.assertNotNull(model.get("workDate"));

        // 모델에 담긴 값으로 실제 템플릿 렌더링까지 연계 검증
        org.thymeleaf.context.Context context = new org.thymeleaf.context.Context();
        context.setVariables(model);
        String renderedHtml = templateEngine.process(viewName, context);
        org.junit.jupiter.api.Assertions.assertNotNull(renderedHtml);
        org.junit.jupiter.api.Assertions.assertTrue(renderedHtml.contains("W_JA010J"));
    }
}
