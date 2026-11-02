package com.kfp.aams.domain.subscriptionrights.service;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020fDto;
import com.kfp.aams.domain.subscriptionrights.mapper.Ja020fMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja020fService {

    private final Ja020fMapper mapper;
    private final WorkDateService workDateService;

    public String getWorkDate(String corpGr) {
        return workDateService.getWorkDateOrDefault(corpGr);
    }

    /**
     * w_ja020f.srw wue_retrieve 명세:
     * 1) ymd > idt_workdate 이면 ymd = idt_workdate 로 보정
     * 2) gs_admin = 'Y' 이면 ls_corp = '%', 아니면 is_corp_gr
     * 3) KFP.SR_JA020F(is_corp_gr, ls_corp, ymd('yyyymmdd'), rcd, OUT R_SET) 호출
     * 4) d_ja020f1.srd 정렬 규격: corp_gr ASC, jm_sort ASC, koscom_cd ASC, fund_cd ASC
     */
    @Transactional
    @SuppressWarnings("unchecked")
    public List<Ja020fDto> getList(String corpGr, boolean isAdmin, LocalDate ymd, String balhCo) {
        if (corpGr == null || corpGr.isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        String cleanCorpGr = corpGr.trim();
        LocalDate workDate = LocalDate.parse(workDateService.getWorkDateOrDefault(cleanCorpGr));
        LocalDate targetYmd = (ymd != null && !ymd.isAfter(workDate)) ? ymd : workDate;

        String corpGr2 = isAdmin ? "%" : cleanCorpGr;
        String ymd8 = targetYmd.format(DateTimeFormatter.BASIC_ISO_DATE);
        String targetBalhCo = (balhCo != null && !balhCo.isBlank()) ? balhCo.trim() : "%";

        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", cleanCorpGr);
        params.put("corpGr2", corpGr2);
        params.put("ymd", ymd8);
        params.put("balhCo", targetBalhCo);
        params.put("rSet", null);

        mapper.callSrJa020f(params);
        List<Ja020fDto> list = (List<Ja020fDto>) params.get("rSet");
        if (list == null || list.isEmpty()) {
            return List.of();
        }

        return list.stream()
                .sorted(Comparator
                        .comparing((Ja020fDto d) -> safeStr(d.getCorpGr()))
                        .thenComparing(d -> safeStr(d.getJmSort()))
                        .thenComparing(d -> safeStr(d.getKoscomCd()))
                        .thenComparing(d -> safeStr(d.getFundCd())))
                .toList();
    }

    private static String safeStr(String s) {
        return s != null ? s : "";
    }
}

