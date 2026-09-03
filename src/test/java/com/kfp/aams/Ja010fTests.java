package com.kfp.aams;

import com.kfp.aams.domain.daily.dto.Ja010fDto;
import com.kfp.aams.domain.daily.service.Ja010fService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class Ja010fTests {

    @Autowired
    private Ja010fService ja010fService;

    @Test
    @DisplayName("Guideline 1: Do not supply default values - returns empty if param is missing")
    void testGuideline1NoDefaults() {
        List<Ja010fDto> list1 = ja010fService.getList(null, null, null);
        assertThat(list1).isEmpty();

        List<Ja010fDto> list2 = ja010fService.getList("2402", null, null);
        assertThat(list2).isEmpty();

        List<Ja010fDto> list3 = ja010fService.getList(null, "2026-08-01", null);
        assertThat(list3).isEmpty();
    }

    @Test
    @DisplayName("Guideline 4: Multi-table join via MyBatis for d_ja010f1")
    void testMyBatisJa010fQuery() {
        List<Ja010fDto> listAll = ja010fService.getList("2402", "2026-08-01", "%");
        assertThat(listAll).isNotNull();

        List<Ja010fDto> listSpecific = ja010fService.getList("2402", "2026-08-01", "00010");
        assertThat(listSpecific).isNotNull();
    }
}
