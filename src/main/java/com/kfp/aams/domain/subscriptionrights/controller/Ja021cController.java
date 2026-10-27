package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021cDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021cMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021cSaveDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja021cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja021cController {

    private final Ja021cService ja021cService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja021c", "/views/subscriptionrights/w_ja021c"})
    public String viewJa021c(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA021C");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja021c");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > 중간배당 및 확정등록";

        // DB 영업일자 연동 (SZX0AA.HYUN_YMD, Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : ja021cService.getWorkDate(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/subscriptionrights/w_ja021c";
    }

    /**
     * 탭 1: 중간배당(G15) 마스터 목록
     */
    @GetMapping("/api/subscriptionrights/ja021c/t1/master")
    @ResponseBody
    public ResponseEntity<List<Ja021cMasterDto>> getT1MasterList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd", required = false) String paramYmd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja021cService.getWorkDate(corpGr);

        return ResponseEntity.ok(ja021cService.getT1MasterList(corpGr, workDate));
    }

    /**
     * 탭 1: 펀드별 배당권리 상세
     */
    @GetMapping("/api/subscriptionrights/ja021c/t1/detail")
    @ResponseBody
    public ResponseEntity<List<Ja021cDetailDto>> getT1DetailList(
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "balhCo") String balhCo,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        return ResponseEntity.ok(ja021cService.getT1DetailList(corpGr, ymd, balhCo));
    }

    /**
     * 탭 2: 현금중간배당확정(G23) 마스터 목록
     */
    @GetMapping("/api/subscriptionrights/ja021c/t2/master")
    @ResponseBody
    public ResponseEntity<List<Ja021cMasterDto>> getT2MasterList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd", required = false) String paramYmd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja021cService.getWorkDate(corpGr);

        return ResponseEntity.ok(ja021cService.getT2MasterList(corpGr, workDate));
    }

    /**
     * 탭 2: 펀드별 배당권리 상세
     */
    @GetMapping("/api/subscriptionrights/ja021c/t2/detail")
    @ResponseBody
    public ResponseEntity<List<Ja021cDetailDto>> getT2DetailList(
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "balhCo") String balhCo,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        return ResponseEntity.ok(ja021cService.getT2DetailList(corpGr, ymd, balhCo));
    }

    /**
     * 탭 3: 주식중간배당확정(G23) 마스터 목록
     */
    @GetMapping("/api/subscriptionrights/ja021c/t3/master")
    @ResponseBody
    public ResponseEntity<List<Ja021cMasterDto>> getT3MasterList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd", required = false) String paramYmd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);
        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja021cService.getWorkDate(corpGr);

        return ResponseEntity.ok(ja021cService.getT3MasterList(corpGr, workDate));
    }

    /**
     * 탭 3: 펀드별 배당권리 상세
     */
    @GetMapping("/api/subscriptionrights/ja021c/t3/detail")
    @ResponseBody
    public ResponseEntity<List<Ja021cDetailDto>> getT3DetailList(
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "brokYmd", required = false) String brokYmd,
            @RequestParam(name = "balhCo") String balhCo,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        return ResponseEntity.ok(ja021cService.getT3DetailList(corpGr, ymd, brokYmd != null ? brokYmd : ymd, balhCo));
    }

    /**
     * 발행기관 정보 (액면가, 배정방법 기본값)
     */
    @GetMapping("/api/subscriptionrights/ja021c/balh-info")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getBalhInfo(@RequestParam("balhCo") String balhCo) {
        BigDecimal aekm = ja021cService.getBalhAekm(balhCo);
        String baejMth = ja021cService.getBaejMthDefault(balhCo);
        Map<String, Object> map = new HashMap<>();
        map.put("aekm", aekm);
        map.put("baejMth", baejMth);
        return ResponseEntity.ok(map);
    }

    /**
     * 저장 (CUD)
     */
    @PostMapping("/api/subscriptionrights/ja021c/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(
            @RequestBody Ja021cSaveDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        Map<String, Object> result = new HashMap<>();
        try {
            UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
            String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;

            if (saveDto != null && saveDto.getMasterList() != null) {
                for (Ja021cMasterDto m : saveDto.getMasterList()) {
                    if (m.getCorpGr() == null || m.getCorpGr().isBlank()) {
                        m.setCorpGr(resolveCorpGr(null, cookieCorpGr, principal));
                    }
                }
            }

            ja021cService.save(saveDto);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("JA021C 저장 실패", e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.badRequest().body(result);
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
        return "";
    }
}
