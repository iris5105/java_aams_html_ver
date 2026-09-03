package com.kfp.aams;

import com.kfp.aams.domain.daily.dto.Ja020nSigaDto;
import com.kfp.aams.domain.daily.dto.Ja020nStatusDto;
import com.kfp.aams.domain.daily.dto.Ja020nTrDto;
import com.kfp.aams.domain.daily.service.Ja020nService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class Ja020nTests {

    @Autowired
    private Ja020nService ja020nService;

    @Test
    @DisplayName("Guideline 1: Do not supply default values - returns empty if param is missing")
    void testGuideline1NoDefaults() {
        List<Ja020nStatusDto> statusList = ja020nService.getStatusList(null, null);
        assertThat(statusList).isEmpty();

        List<Ja020nSigaDto> sigaList = ja020nService.getSigaList("", "");
        assertThat(sigaList).isEmpty();

        List<Ja020nTrDto> trList = ja020nService.getTrList(null, "2026-08-01");
        assertThat(trList).isEmpty();
    }

    @Test
    @DisplayName("Guideline 4: Multi-table join via MyBatis for d_ja020n, d_ja020n_siga, d_ja020n_tr")
    void testMyBatisQueries() {
        List<Ja020nStatusDto> statusList = ja020nService.getStatusList("2402", "2026-08-01");
        assertThat(statusList).isNotNull();
        System.out.println("Status list count: " + statusList.size());

        List<Ja020nSigaDto> sigaList = ja020nService.getSigaList("2402", "2026-08-01");
        assertThat(sigaList).isNotNull();
        System.out.println("Siga list count: " + sigaList.size());

        List<Ja020nTrDto> trList = ja020nService.getTrList("2402", "2026-08-01");
        assertThat(trList).isNotNull();
        System.out.println("Tr list count: " + trList.size());
    }
}
