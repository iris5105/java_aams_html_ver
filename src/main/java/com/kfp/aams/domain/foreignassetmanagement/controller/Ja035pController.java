package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pDetailDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pMasterDto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja035pSaveRequest;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja035pService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

/**
 * W_JA035P 상환유예 관리 컨트롤러
 */
@Controller
@RequiredArgsConstructor
public class Ja035pController {

    private final Ja035pService service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja035p", "/views/foreignassetmanagement/w_ja035p"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String ymd,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        String selectedYmd = (ymd == null || ymd.isBlank()) ? workDate : ymd;
        var menu = menuService.getMenuByPgmId("W_JA035P");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", selectedYmd);
        model.addAttribute("ymd", selectedYmd);
        model.addAttribute("trDates", service.getHighlightDates(resolvedCorpGr));
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 외화자산운용 > 외화자산운용 > 상환유예 관리");
        return "views/foreignassetmanagement/w_ja035p";
    }

    @GetMapping("/api/foreignassetmanagement/ja035p/master")
    @ResponseBody
    public List<Ja035pMasterDto> master(@AuthenticationPrincipal UserPrincipal principal,
                                        @RequestParam(required = false) String corpGr,
                                        @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                        @RequestParam String ymd) {
        return service.getMasterList(resolveCorpGr(principal, corpGr, savedCorpGr), ymd);
    }

    @GetMapping("/api/foreignassetmanagement/ja035p/detail")
    @ResponseBody
    public List<Ja035pDetailDto> detail(@AuthenticationPrincipal UserPrincipal principal,
                                        @RequestParam(required = false) String corpGr,
                                        @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                        @RequestParam String trYmd,
                                        @RequestParam String trCd,
                                        @RequestParam String fundCd,
                                        @RequestParam String hjCd,
                                        @RequestParam Long trSeq,
                                        @RequestParam String aekGb) {
        return service.getDetailList(
                resolveCorpGr(principal, corpGr, savedCorpGr),
                trYmd, trCd, fundCd, hjCd, trSeq, aekGb);
    }

    @GetMapping("/api/foreignassetmanagement/ja035p/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getHighlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    @PostMapping("/api/foreignassetmanagement/ja035p/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                    @RequestParam(required = false) String corpGr,
                                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                                    @RequestBody Ja035pSaveRequest request) {
        int count = service.save(resolveCorpGr(principal, corpGr, savedCorpGr), request);
        return ResponseEntity.ok(Map.of("success", true, "count", count, "message", "저장되었습니다."));
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (principal == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "로그인이 필요합니다.");
        }
        if ("Y".equalsIgnoreCase(principal.getAdminYn())) {
            if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
            if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        }
        return principal.getCorpGr() != null ? principal.getCorpGr().trim() : "";
    }
}
