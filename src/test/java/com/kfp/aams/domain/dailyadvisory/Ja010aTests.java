package com.kfp.aams.domain.dailyadvisory;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010aMasterDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010aSaveRequestDto;
import com.kfp.aams.domain.dailyadvisory.service.Ja010aService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
public class Ja010aTests {

    @Autowired
    private Ja010aService ja010aService;

    @Test
    @DisplayName("w_ja010a 마스터 조회 및 수정 저장 검증 (날짜 컬럼 ORA-01861 방지)")
    void testSaveMasterWithDateUpdate() {
        List<Ja010aMasterDto> masterList = ja010aService.getMasterList();
        assertThat(masterList).isNotEmpty();

        Ja010aMasterDto target = masterList.get(0);
        target.setIsUpdated(true);
        target.setBigo("회사 기본정보 수정 테스트");
        target.setHyunYmd("2026-10-08");
        target.setGijungaYmd("2026.10.07");

        Ja010aSaveRequestDto request = new Ja010aSaveRequestDto();
        request.setMasterList(List.of(target));

        ja010aService.saveJa010a(request);
        System.out.println("w_ja010a 마스터 저장 검증 성공: " + target.getCorpGr());
    }
}
