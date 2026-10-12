package com.kfp.aams.domain.dailyadvisory;

import com.kfp.aams.domain.dailyadvisory.controller.Ja010jController;
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
}
