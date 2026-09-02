package com.kfp.aams;

import com.kfp.aams.domain.daily.dto.Shj0igDetailDto;
import com.kfp.aams.domain.daily.dto.Shm0hjMasterDto;
import com.kfp.aams.domain.daily.service.Shm0hjService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class Shm0hjTests {

    @Autowired
    private Shm0hjService shm0hjService;

    @Test
    @DisplayName("Guideline 1: Do not supply default values - returns empty if param is missing")
    void testGuideline1NoDefaults() {
        List<Shm0hjMasterDto> list = shm0hjService.getMasterList(null, null, null);
        assertThat(list).isEmpty();

        List<Shj0igDetailDto> details = shm0hjService.getDetailList(null, null, null);
        assertThat(details).isEmpty();
    }

    @Test
    @DisplayName("Guideline 4: Multi-table join via MyBatis for d_shm0hj")
    void testMyBatisMasterQuery() {
        // Querying with actual parameters without errors
        List<Shm0hjMasterDto> list = shm0hjService.getMasterList("00804", "2026-08-01", "%");
        assertThat(list).isNotNull();
        System.out.println("Master list count: " + list.size());
        if (!list.isEmpty()) {
            System.out.println("First row: " + list.get(0).getHjNm() + " / " + list.get(0).getJmCd());
        }
    }

    @Test
    @DisplayName("Guideline 4: Single table query via QueryDSL for d_shj0ig")
    void testQueryDslDetailQuery() {
        List<Shj0igDetailDto> list = shm0hjService.getDetailList("00804", "TEST_JM", BigDecimal.ONE);
        assertThat(list).isNotNull();
        System.out.println("Detail list count: " + list.size());
    }
}
