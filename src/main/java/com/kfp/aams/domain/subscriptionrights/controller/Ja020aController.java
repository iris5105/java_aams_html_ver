package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja020aSaveDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT1Dto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT4aDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT4bDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja020aT5Dto;
import com.kfp.aams.domain.subscriptionrights.service.Ja020aService;
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

/**
 * W_JA020A (공모청약 종목 및 배정등록) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja020aController {

    private final Ja020aService ja020aService;
    private final MenuService menuService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja020a", "/views/subscriptionrights/w_ja020a"})
    public String viewJa020a(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA020A");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja020a");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모주청약 > 공모청약 종목 및 배정등록";

        // DB 영업일자(SZX0AA.HYUN_YMD) 연동 (Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : ja020aService.getWorkDate(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/subscriptionrights/w_ja020a";
    }

    /**
     * [탭1] 기본정보 종목 목록 조회 (d_ja020a_t1a)
     */
    @GetMapping("/api/subscriptionrights/ja020a/t1/list")
    @ResponseBody
    public ResponseEntity<List<Ja020aT1Dto>> getT1List(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        List<Ja020aT1Dto> list = ja020aService.getT1List(corpGr);
        return ResponseEntity.ok(list);
    }

    /**
     * [탭1] 기본정보 저장 (등록/수정)
     */
    @PostMapping("/api/subscriptionrights/ja020a/t1/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveT1(
            @RequestBody Ja020aT1Dto dto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(dto.getCorpGr(), cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "회사그룹 정보가 누락되었습니다.");
            return ResponseEntity.badRequest().body(err);
        }

        dto.setCorpGr(corpGr);
        String loginUser = (principal != null) ? principal.getUsername() : "admin";

        try {
            Ja020aT1Dto savedDto = ja020aService.saveT1(dto, loginUser);
            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("message", "기본정보가 정상적으로 저장되었습니다.");
            res.put("data", savedDto);
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            log.error("Failed to save ja020a t1 data:", e);
            Map<String, Object> res = new HashMap<>();
            res.put("success", false);
            res.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }

    /**
     * [탭1] 기본정보 종목 삭제
     */
    @PostMapping("/api/subscriptionrights/ja020a/t1/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteT1(
            @RequestBody Map<String, String> payload) {
        String jcJoin = payload.get("jcJoin");
        if (jcJoin == null || jcJoin.isBlank()) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "삭제할 종목 관리번호가 없습니다.");
            return ResponseEntity.badRequest().body(err);
        }

        try {
            ja020aService.deleteT1(jcJoin);
            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("message", "공모종목이 정상적으로 삭제되었습니다.");
            return ResponseEntity.ok(res);
        } catch (IllegalStateException e) {
            Map<String, Object> res = new HashMap<>();
            res.put("success", false);
            res.put("message", e.getMessage());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            log.error("Failed to delete ja020a t1 data:", e);
            Map<String, Object> res = new HashMap<>();
            res.put("success", false);
            res.put("message", "삭제 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }

    /**
     * [탭2] 배정등록 - 청약종목 목록 조회 (d_ja020a_t4a)
     */
    @GetMapping("/api/subscriptionrights/ja020a/t4/header-list")
    @ResponseBody
    public ResponseEntity<List<Ja020aT4aDto>> getT4aList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        List<Ja020aT4aDto> list = ja020aService.getT4aList(corpGr);
        return ResponseEntity.ok(list);
    }

    /**
     * [탭2] 배정등록 - 펀드별 청약/배정 상세 목록 조회 (d_ja020a_t4b)
     */
    @GetMapping("/api/subscriptionrights/ja020a/t4/detail-list")
    @ResponseBody
    public ResponseEntity<List<Ja020aT4bDto>> getT4bList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "jcJoin") String jcJoin,
            @RequestParam(name = "jgTrCoCd", required = false) String jgTrCoCd,
            @RequestParam(name = "ymd", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        String workDateStr = ja020aService.getWorkDate(corpGr);
        LocalDate workDate = (workDateStr != null && !workDateStr.isBlank()) ? LocalDate.parse(workDateStr.replace(".", "-")) : LocalDate.now();

        List<Ja020aT4bDto> list = ja020aService.getT4bList(corpGr, jcJoin, jgTrCoCd, ymd, workDate);
        return ResponseEntity.ok(list);
    }

    /**
     * [탭2] 배정등록 저장 API
     */
    @PostMapping("/api/subscriptionrights/ja020a/t4/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveT4(
            @RequestBody Ja020aSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "회사그룹 정보가 누락되었습니다.");
            return ResponseEntity.badRequest().body(err);
        }

        String loginUser = (principal != null) ? principal.getUsername() : "admin";

        try {
            int savedCount = ja020aService.saveT4(saveDto.getT4aData(), saveDto.getT4bList(), loginUser);
            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("message", "배정내역이 정상적으로 저장되었습니다.");
            res.put("savedCount", savedCount);
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            log.error("Failed to save ja020a t4 data:", e);
            Map<String, Object> res = new HashMap<>();
            res.put("success", false);
            res.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(res);
        }
    }

    /**
     * [탭3] 수요예측참여총괄표 종목 목록 조회 (d_ja020a_t5)
     */
    @GetMapping("/api/subscriptionrights/ja020a/t5/list")
    @ResponseBody
    public ResponseEntity<List<Ja020aT5Dto>> getT5List(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.badRequest().body(Collections.emptyList());
        }

        List<Ja020aT5Dto> list = ja020aService.getT5List(corpGr);
        return ResponseEntity.ok(list);
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
        return null;
    }
}
