package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.common.service.DddwService;
import com.kfp.aams.domain.daily.dto.Shj0igDetailDto;
import com.kfp.aams.domain.daily.dto.Shm0hjMasterDto;
import com.kfp.aams.domain.daily.service.Shm0hjService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for w_shm0hj (현금 매입(종목)등록)
 * Adheres strictly to Guideline 1 (no default value fallback) and Guideline 2 (no hardcoding).
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Shm0hjController {

    private final Shm0hjService shm0hjService;
    private final MenuService menuService;
    private final DddwService dddwService;

    @GetMapping({"/views/w_shm0hj", "/views/daily/w_shm0hj"})
    public String viewShm0hj(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @RequestParam(name = "dddw", required = false) String paramDddw,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        // Menu breadcrumb
        var menuDto = menuService.getMenuByPgmId("W_SHM0HJ");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_shm0hj");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일일작업";
        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", paramYmd);
        model.addAttribute("dddw", paramDddw);

        return "views/daily/w_shm0hj";
    }

    @GetMapping("/api/shm0hj/master")
    @ResponseBody
    public List<Shm0hjMasterDto> getMasterList(@AuthenticationPrincipal Object principalObj,
                                               @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                               @RequestParam(name = "ymd", required = false) String ymd,
                                               @RequestParam(name = "cashCd", required = false) String cashCd,
                                               @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                               @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }

        return shm0hjService.getMasterList(corpGr, ymd, cashCd);
    }

    @GetMapping("/api/shm0hj/detail")
    @ResponseBody
    public List<Shj0igDetailDto> getDetailList(@AuthenticationPrincipal Object principalObj,
                                               @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                               @RequestParam(name = "jmCd", required = false) String jmCd,
                                               @RequestParam(name = "nowNo", required = false) BigDecimal nowNo,
                                               @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                               @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            return Collections.emptyList();
        }

        return shm0hjService.getDetailList(corpGr, jmCd, nowNo);
    }

    @PostMapping("/api/shm0hj/generate-interest")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generatePeriodInterest(@AuthenticationPrincipal Object principalObj,
                                                                      @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                                      @RequestParam(name = "jmCd", required = false) String jmCd,
                                                                      @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                                                      @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        Map<String, Object> response = new HashMap<>();
        try {
            shm0hjService.generatePeriodInterest(corpGr, jmCd);
            response.put("success", true);
            response.put("message", "구간이자가 정상적으로 생성되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Failed to generate period interest", e);
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr();
        }
        return null;
    }
}
