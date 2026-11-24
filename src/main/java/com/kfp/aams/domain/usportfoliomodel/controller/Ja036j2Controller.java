package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja036j2Dto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja036j2HistoryDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja036j2SaveRequest;
import com.kfp.aams.domain.usportfoliomodel.service.Ja036j2Service;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * PowerBuilder W_JA036J2 (d_ja036j2a/d_ja036j2b) migration controller.
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja036j2Controller {

    private static final String PROGRAM_ID = "W_JA036J2";

    private final Ja036j2Service ja036j2Service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja036j2", "/views/usportfoliomodel/w_ja036j2"})
    public String view(@AuthenticationPrincipal Object principalObj,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       @CookieValue(name = "corpGr", required = false) String cookieCorpGr,
                       @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(corpGr, savedCorpGr, cookieCorpGr, principalObj);
        LocalDate resolvedYmd = ymd == null
                ? LocalDate.parse(workDateService.getWorkDateOrDefault(resolvedCorpGr)) : ymd;
        var menu = menuService.getMenuByPgmId(PROGRAM_ID);

        model.addAttribute("fullpgm2", menu != null && menu.getFullpgm2() != null
                ? menu.getFullpgm2() : "자산운용 > US Portfolio Model > 환율 관리");
        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("ymd", resolvedYmd);
        return "views/usportfoliomodel/w_ja036j2";
    }

    @GetMapping("/api/usportfoliomodel/ja036j2/list")
    @ResponseBody
    public List<Ja036j2Dto> list(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd) {
        return ja036j2Service.getList(ymd);
    }

    @GetMapping("/api/usportfoliomodel/ja036j2/history")
    @ResponseBody
    public List<Ja036j2HistoryDto> history(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
            @RequestParam String currency) {
        return ja036j2Service.getHistory(ymd, currency);
    }

    @PostMapping("/api/usportfoliomodel/ja036j2/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@RequestBody Ja036j2SaveRequest request) {
        try {
            int count = ja036j2Service.save(request);
            return ResponseEntity.ok(Map.of("success", true, "count", count, "message", "저장되었습니다."));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        } catch (Exception e) {
            log.error("W_JA036J2 저장 실패", e);
            return ResponseEntity.internalServerError()
                    .body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다."));
        }
    }

    private String resolveCorpGr(String parameter, String savedCookie, String cookie, Object principalObj) {
        if (parameter != null && !parameter.isBlank()) return parameter.trim();
        if (savedCookie != null && !savedCookie.isBlank()) return savedCookie.trim();
        if (cookie != null && !cookie.isBlank()) return cookie.trim();
        if (principalObj instanceof UserPrincipal principal && principal.getCorpGr() != null) {
            return principal.getCorpGr().trim();
        }
        return "";
    }
}
