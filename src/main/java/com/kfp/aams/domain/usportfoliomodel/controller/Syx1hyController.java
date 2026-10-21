package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Syx1hyDto;
import com.kfp.aams.domain.usportfoliomodel.service.Syx1hyService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 환율등록 (W_SYX1HY) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Syx1hyController {

    private final Syx1hyService syx1hyService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_syx1hy", "/views/usportfoliomodel/w_syx1hy", "/views/foreignassetmanagement/w_syx1hy"})
    public String viewSyx1hy(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_SYX1HY");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_syx1hy");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 환율등록";

        // DB 영업일자 (SZX0AA.HYUN_YMD) 연동 (규정 01-3 Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        boolean isAdmin = false;
        if (principalObj instanceof UserPrincipal userPrincipal) {
            isAdmin = userPrincipal.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equalsIgnoreCase("ROLE_ADMIN") || a.getAuthority().contains("ADMIN"));
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("isAdmin", isAdmin);

        return "views/usportfoliomodel/w_syx1hy";
    }

    /**
     * 통화별 기준환율 목록 조회 (최근 1년)
     */
    @GetMapping("/api/usportfoliomodel/syx1hy/list")
    @ResponseBody
    public List<Syx1hyDto> getExchangeRateList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "ymd") String ymd) {
        try {
            return syx1hyService.getExchangeRateList(corpGr, ymd);
        } catch (Exception e) {
            log.error("환율 목록 조회 실패 (corpGr: {}, ymd: {}): {}", corpGr, ymd, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 통화별 기준환율 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/syx1hy/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveExchangeRateList(@RequestParam(name = "corpGr") String corpGr,
                                                                    @RequestBody List<Syx1hyDto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            syx1hyService.saveExchangeRateList(corpGr, list);
            result.put("success", true);
            result.put("message", "환율 정보가 정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("환율 저장 실패 (corpGr: {}): {}", corpGr, e.getMessage(), e);
            result.put("success", false);
            result.put("message", "환율 정보 저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        if (principalObj instanceof UserPrincipal userPrincipal && userPrincipal.getCorpGr() != null && !userPrincipal.getCorpGr().isBlank()) {
            return userPrincipal.getCorpGr();
        }
        return "";
    }
}
