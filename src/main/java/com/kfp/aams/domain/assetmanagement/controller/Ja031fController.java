package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja031fDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031fMasterDto;
import com.kfp.aams.domain.assetmanagement.service.Ja031fService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031fController {

    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja031fService ja031fService;

    @GetMapping({"/views/w_ja031f", "/views/assetmanagement/w_ja031f"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031F");

        // PB w_ja031f::wue_lastopen: fymd는 해당 월의 1일, tymd는 기준일자
        String fymd = calculateMonthFirstDay(workDate);
        String tymd = workDate;

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fymd", fymd);
        model.addAttribute("tymd", tymd);
        model.addAttribute("pgmNo", menu == null ? "00075" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA031F" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja031f";
    }

    @GetMapping("/api/assetmanagement/ja031f/funds")
    @ResponseBody
    public ResponseEntity<List<Ja031fMasterDto>> getFundList(@RequestParam String corpGr,
                                                            @RequestParam String fymd,
                                                            @RequestParam String tymd) {
        List<Ja031fMasterDto> list = ja031fService.getFundList(corpGr, fymd, tymd);
        return ResponseEntity.ok(list);
    }

    @GetMapping("/api/assetmanagement/ja031f/details")
    @ResponseBody
    public ResponseEntity<List<Ja031fDetailDto>> getDetailList(@RequestParam String corpGr,
                                                              @RequestParam String fymd,
                                                              @RequestParam String tymd,
                                                              @RequestParam(required = false) String fundCd) {
        List<Ja031fDetailDto> list = ja031fService.getDetailList(corpGr, fymd, tymd, fundCd);
        return ResponseEntity.ok(list);
    }

    private String calculateMonthFirstDay(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return LocalDate.now().withDayOfMonth(1).toString();
        }
        String clean = dateStr.trim().replaceAll("[^0-9]", "");
        if (clean.length() == 8) {
            try {
                LocalDate date = LocalDate.parse(clean, DateTimeFormatter.ofPattern("yyyyMMdd"));
                return date.withDayOfMonth(1).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            } catch (Exception e) {
                log.warn("[Ja031fController] calculateMonthFirstDay error: {}", dateStr, e);
            }
        }
        return dateStr;
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

