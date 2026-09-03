package com.kfp.aams;

import com.kfp.aams.domain.daily.dto.Ja010eDto;
import com.kfp.aams.domain.daily.service.Ja010eService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class Ja010eTests {

    @Autowired
    private Ja010eService ja010eService;

    @Test
    @DisplayName("Guideline 1: Do not supply default values - returns empty if param is missing")
    void testGuideline1NoDefaults() {
        List<Ja010eDto> list1 = ja010eService.getList(null, null, null);
        assertThat(list1).isEmpty();

        List<Ja010eDto> list2 = ja010eService.getList("2402", null, null);
        assertThat(list2).isEmpty();

        List<Ja010eDto> list3 = ja010eService.getList(null, "2026-08-01", null);
        assertThat(list3).isEmpty();
    }

    @Test
    @DisplayName("Guideline 4: Multi-table join via MyBatis for d_ja010e1")
    void testMyBatisJa010eQuery() {
        List<Ja010eDto> listAll = ja010eService.getList("2402", "2026-08-01", "%");
        assertThat(listAll).isNotNull();

        List<Ja010eDto> listSpecific = ja010eService.getList("2402", "2026-08-01", "00010");
        assertThat(listSpecific).isNotNull();
    }
}
