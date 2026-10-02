package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020rDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020rMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020rSaveDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja020rService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020rController {

    private final Ja020rService ja020rService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja020r", "/views/subscriptionrights/w_ja020r"})
    public String viewJa020r(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @RequestParam(name = "dddw", required = false) String paramDddw,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020R");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020r");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모(청약)권리 > 수정취득가액 등록";

        // 파워빌더 w_ja020r.srw (wue_lastopen) 명세: SZX0AA.JUNYONG_YMD(2402) 또는 HYUN_YMD(기타) 작업일자 반영
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja020rService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }
        String dddw = (paramDddw != null && !paramDddw.isBlank()) ? paramDddw : "d_ja020r2c";

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("dddw", dddw);

        return "views/subscriptionrights/w_ja020r";
    }

    /**
     * 회사 변경 시 해당 회사의 기준일자 조회 API
     */
    @GetMapping("/api/subscriptionrights/ja020r/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja020rService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }
        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        return ResponseEntity.ok(response);
    }

    /**
     * 마스터 계좌 목록 조회 API (d_ja020r1)
     */
    @GetMapping("/api/subscriptionrights/ja020r/funds")
    @ResponseBody
    public ResponseEntity<List<Ja020rMasterDto>> getFunds(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate ymd,
            @RequestParam(name = "dw", defaultValue = "d_ja020r2c") String dw,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja020rMasterDto> list = ja020rService.getMasterList(corpGr, ymd, dw);
        return ResponseEntity.ok(list);
    }

    /**
     * 디테일 유가증권 취득액 목록 조회 API (d_ja020r2c, d_ja020r2h, d_ja020r2j)
     */
    @GetMapping("/api/subscriptionrights/ja020r/detail")
    @ResponseBody
    public ResponseEntity<List<Ja020rDetailDto>> getDetail(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate ymd,
            @RequestParam(name = "fundCd") String fundCd,
            @RequestParam(name = "dw", defaultValue = "d_ja020r2c") String dw,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja020rDetailDto> list = ja020rService.getDetailList(corpGr, ymd, fundCd, dw);
        return ResponseEntity.ok(list);
    }

    /**
     * 수정취득액 저장 API
     */
    @PostMapping("/api/subscriptionrights/ja020r/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja020rSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);
        saveDto.setCorpGr(corpGr);

        String loginUser = (principal != null) ? principal.getUsername() : "admin";

        try {
            ja020rService.save(saveDto, loginUser);
            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("message", "수정취득가액이 정상적으로 저장되었습니다.");
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            log.error("Failed to save ja020r alter amounts:", e);
            Map<String, Object> res = new HashMap<>();
            res.put("success", false);
            res.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "2402";
    }
}
