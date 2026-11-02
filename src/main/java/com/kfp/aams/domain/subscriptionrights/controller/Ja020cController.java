package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020cDataDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020cFilterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020cSaveDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja020cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * W_JA020C (배당금/단주대금 입금) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020cController {

    private final Ja020cService service;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja020c", "/views/subscriptionrights/w_ja020c"})
    public String view(@AuthenticationPrincipal Object principalObj,
                       @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                       @RequestParam(name = "ymd", required = false) String paramYmd,
                       @RequestParam(name = "trCd", required = false) String paramTrCd,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       @CookieValue(name = "corpGr", required = false) String cookieCorpGr,
                       Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String corpGr = resolveCorpGr(paramCorpGr, savedCorpGr, cookieCorpGr, principal);
        String workDate = service.getWorkDate(corpGr);
        String initialYmd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd.trim() : workDate;

        // dw_c::ue_getdate 기준 데이터 존재 일자 조회 (하이라이트 달력 초기화용)
        List<LocalDate> trDates = service.getDates(corpGr, paramTrCd);

        var menu = menuService.getMenuByPgmId("W_JA020C");
        if (menu == null) {
            menu = menuService.getMenuByPgmId("w_ja020c");
        }
        String fullpgm2 = (menu != null && menu.getFullpgm2() != null)
                ? menu.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > 배당금/단주대금 입금";

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", initialYmd);
        model.addAttribute("ymd", initialYmd);
        model.addAttribute("trDates", trDates);

        return "views/subscriptionrights/w_ja020c";
    }

    @GetMapping("/api/subscriptionrights/ja020c/data")
    @ResponseBody
    public Ja020cDataDto data(@ModelAttribute Ja020cFilterDto filter,
                              @AuthenticationPrincipal Object principalObj,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                              @CookieValue(name = "corpGr", required = false) String cookieCorpGr) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String corpGr = resolveCorpGr(filter.getCorpGr(), savedCorpGr, cookieCorpGr, principal);
        if (corpGr == null || corpGr.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "회사그룹 정보가 누락되었습니다.");
        }
        filter.setCorpGr(corpGr);
        return service.query(filter);
    }

    @GetMapping("/api/subscriptionrights/ja020c/dates")
    @ResponseBody
    public List<LocalDate> dates(@RequestParam(name = "trCd", required = false) String trCd,
                                 @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                 @AuthenticationPrincipal Object principalObj,
                                 @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                 @CookieValue(name = "corpGr", required = false) String cookieCorpGr) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String corpGr = resolveCorpGr(paramCorpGr, savedCorpGr, cookieCorpGr, principal);
        return service.getDates(corpGr, trCd);
    }

    @PostMapping("/api/subscriptionrights/ja020c/save")
    @ResponseBody
    public Map<String, Object> save(@RequestBody Ja020cSaveDto request,
                                    @AuthenticationPrincipal Object principalObj,
                                    @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                    @CookieValue(name = "corpGr", required = false) String cookieCorpGr) {
        if (request == null || request.getFilter() == null) {
            throw new IllegalArgumentException("조회 조건이 없습니다.");
        }
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String corpGr = resolveCorpGr(request.getFilter().getCorpGr(), savedCorpGr, cookieCorpGr, principal);
        if (corpGr == null || corpGr.isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        request.getFilter().setCorpGr(corpGr);
        String loginUser = (principal != null && principal.getUsername() != null) ? principal.getUsername() : "SYSTEM";

        int count = service.save(request, loginUser);
        return Map.of("success", true, "count", count, "message", "정상적으로 저장되었습니다.");
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleInvalid(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "message", ex.getMessage()));
    }

    private String resolveCorpGr(String paramCorpGr, String savedCorpGr, String cookieCorpGr, UserPrincipal principal) {
        for (String val : new String[]{paramCorpGr, savedCorpGr, cookieCorpGr,
                principal != null ? principal.getCorpGr() : null}) {
            if (val != null && !val.isBlank()) {
                return val.trim();
            }
        }
        return "";
    }
}

