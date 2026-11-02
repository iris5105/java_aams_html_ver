package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021fDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021fMasterDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja021fMapper;
import com.kfp.aams.domain.subscriptionrights.mapper.querydsl.Ja021fJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.time.LocalDate;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja021fService {
    private final Ja021fJpaRepository jpaRepository;
    private final Ja021fMapper myBatisMapper;

    private static final Map<String, String> TRADE_CODES = Map.of(
            "t1", "G31",
            "t2", "G32",
            "t3", "G35",
            "t4", "G36"
    );

    public Map<String, Object> selectTab(String tab, String corpGr, String workDate) {
        String trCd = TRADE_CODES.get(tab);
        if (trCd == null) throw new IllegalArgumentException("지원하지 않는 탭입니다.");

        List<Ja021fMasterDto> master = ("t2".equals(tab) || "t4".equals(tab))
                ? myBatisMapper.selectChangeMaster(trCd)
                : jpaRepository.selectSimpleMaster(trCd);
        applyControlVisibility(master, workDate);
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("master", master);
        result.put("detail", List.of());
        if (!master.isEmpty()) {
            Ja021fMasterDto first = master.get(0);
            result.put("detail", selectDetail(corpGr, first.getTrYmd(), first.getBalhCo(), first.getJeungjMth()));
        }
        return result;
    }

    private void applyControlVisibility(List<Ja021fMasterDto> master, String workDate) {
        if (workDate == null || workDate.isBlank()) return;
        String normalized = workDate.trim().replace('.', '-');
        if (normalized.length() > 10) normalized = normalized.substring(0, 10);
        LocalDate workDay;
        try {
            workDay = LocalDate.parse(normalized);
        } catch (RuntimeException ignored) {
            return;
        }
        for (Ja021fMasterDto row : master) {
            row.setPVisible(row.getTrYmd() != null && !row.getTrYmd().isBefore(workDay) ? 1 : 0);
        }
    }

    public List<Ja021fDetailDto> selectDetail(String corpGr, Object ymd, Object balhCo, Object jeungjMth) {
        if (corpGr == null || corpGr.isBlank() || ymd == null || balhCo == null || jeungjMth == null) return List.of();
        String ymdValue = String.valueOf(ymd).substring(0, Math.min(10, String.valueOf(ymd).length()));
        return jpaRepository.selectDetail(corpGr, ymdValue, String.valueOf(balhCo), String.valueOf(jeungjMth));
    }
}
