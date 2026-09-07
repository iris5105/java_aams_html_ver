package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010oFilterDto;
import com.kfp.aams.domain.daily.dto.Ja010oMasterDto;
import com.kfp.aams.domain.daily.dto.Ja010oSaveDto;
import com.kfp.aams.domain.daily.service.Ja010oService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * Controller for w_ja010o (Stock Credit/Loan Balance LOAD / 주식 신용/대출잔고 LOAD)
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010oController {

    private final Ja010oService ja010oService;
    private final MenuService menuService;

    /**
     * 뷰 템플릿 렌더링
     */
    @GetMapping({"/views/w_ja010o", "/views/daily/w_ja010o"})
    public String viewJa010o(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @RequestParam(name = "fundCd", required = false) String paramFundCd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model,
                             HttpSession session) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA010O");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010o");
        }
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "사무관리 > 자문일일 > 일일작업";
        String ymd = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd
                : LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("ymd", ymd);
        model.addAttribute("fundCd", paramFundCd != null ? paramFundCd : "");

        return "views/daily/w_ja010o";
    }

    /**
     * 신용/대출잔고 내역 조회 API
     */
    @GetMapping("/api/daily/ja010o/list")
    @ResponseBody
    public ResponseEntity<List<Ja010oMasterDto>> getJa010oList(
            @ModelAttribute Ja010oFilterDto filter,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(filter.getCorpGr(), cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank() || filter.getYmd() == null || filter.getYmd().isBlank()
                || filter.getFundCd() == null || filter.getFundCd().isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja010oMasterDto> list = ja010oService.getJa010oList(corpGr, filter.getYmd(), filter.getFundCd());
        return ResponseEntity.ok(list);
    }

    /**
     * 운용사별 펀드 목록 조회 API
     */
    @GetMapping("/api/daily/ja010o/funds")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getFundList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Map<String, Object>> list = ja010oService.getFundList(corpGr);
        return ResponseEntity.ok(list);
    }

    /**
     * 신용/대출 담보 내역 일괄 저장 API
     */
    @PostMapping("/api/daily/ja010o/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveCollateral(
            @RequestBody Ja010oSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);
        saveDto.setCorpGr(corpGr);

        try {
            ja010oService.saveCollateral(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving collateral in w_ja010o:", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다: " + e.getMessage()));
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr;
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) return cookieCorpGr;
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr();
        }
        return "";
    }
}
