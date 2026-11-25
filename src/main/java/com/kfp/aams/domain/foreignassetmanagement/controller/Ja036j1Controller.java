package com.kfp.aams.domain.foreignassetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036j1Dto;
import com.kfp.aams.domain.foreignassetmanagement.dto.Ja036j1ImportDto;
import com.kfp.aams.domain.foreignassetmanagement.service.Ja036j1Service;
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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja036j1Controller {
    private final Ja036j1Service ja036j1Service;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    @GetMapping({"/views/w_ja036j1", "/views/foreignassetmanagement/w_ja036j1"})
    public String view(@AuthenticationPrincipal Object principalObj,
                       @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                       @RequestParam(name = "ymd", required = false) String paramYmd,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       @CookieValue(name = "corpGr", required = false) String cookieCorpGr,
                       Model model) {
        String corpGr = resolveCorpGr(paramCorpGr, savedCorpGr, cookieCorpGr, principalObj);
        String workDate = paramYmd == null || paramYmd.isBlank()
                ? workDateService.getWorkDateOrDefault(corpGr) : paramYmd;
        var menu = menuService.getMenuByPgmId("W_JA036J1");
        String fullpgm2 = menu != null && menu.getFullpgm2() != null
                ? menu.getFullpgm2() : "업무관리 > US Portfolio Model > 해외주식 종가 관리";
        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        return "views/foreignassetmanagement/w_ja036j1";
    }

    @GetMapping("/api/usportfoliomodel/ja036j1/list")
    @ResponseBody
    public List<Ja036j1Dto> list(@RequestParam String corpGr, @RequestParam String ymd) {
        return ja036j1Service.getList(corpGr, ymd);
    }

    @PostMapping("/api/usportfoliomodel/ja036j1/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@RequestParam String corpGr, @RequestParam String ymd,
                                                     @RequestBody List<Ja036j1Dto> rows) {
        try {
            return ResponseEntity.ok(Map.of("success", true, "count", ja036j1Service.save(corpGr, ymd, rows), "message", "저장되었습니다."));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        } catch (Exception e) {
            log.error("W_JA036J1 저장 실패", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다."));
        }
    }

    @PostMapping("/api/usportfoliomodel/ja036j1/import")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> importCloses(@RequestParam String corpGr, @RequestParam String ymd,
                                                             @RequestBody List<Ja036j1ImportDto> rows) {
        try {
            int count = ja036j1Service.importCloses(corpGr, ymd, rows);
            return ResponseEntity.ok(Map.of("success", true, "count", count, "message", count + "건의 종가를 반영했습니다."));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        } catch (Exception e) {
            log.error("W_JA036J1 종가 반영 실패", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "종가 반영 중 오류가 발생했습니다."));
        }
    }

    private String resolveCorpGr(String paramCorpGr, String savedCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr.trim();
        if (principalObj instanceof UserPrincipal principal && principal.getCorpGr() != null) return principal.getCorpGr().trim();
        return "";
    }
}
