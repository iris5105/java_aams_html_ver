package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021aDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021aMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021aSaveDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja021aService;
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
public class Ja021aController {

    private final Ja021aService ja021aService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja021a", "/views/subscriptionrights/w_ja021a"})
    public String viewJa021a(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             @CookieValue(name = "userCorpGr", required = false) String cookieCorpGr3,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1
                : ((cookieCorpGr2 != null && !cookieCorpGr2.isBlank()) ? cookieCorpGr2 : cookieCorpGr3);
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA021A");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja021a");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > (자문사별)예상배당 공시등록";

        // 작업일자 연동 (SZX0AA.HYUN_YMD)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : ja021aService.getWorkDate(corpGr);

        // 운용사명 연동 (SZX0AA.COMPANY_NAME)
        // 1) corpGr이 존재하면 SZX0AA 테이블에서 실제 회사명 우선 조회
        String corpNm = "";
        if (corpGr != null && !corpGr.isBlank()) {
            corpNm = ja021aService.getCompanyName(corpGr);
        }

        // 2) corpNm이 비어있거나 조회가 안 된 경우 principal 정보 활용
        if ((corpNm == null || corpNm.isBlank()) && principal != null) {
            if (principal.getCompanyName() != null && !principal.getCompanyName().isBlank()) {
                corpNm = principal.getCompanyName().trim();
            }
            if ((corpGr == null || corpGr.isBlank()) && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
                corpGr = principal.getCorpGr().trim();
                if (corpNm == null || corpNm.isBlank()) {
                    corpNm = ja021aService.getCompanyName(corpGr);
                }
            }
        }

        log.info("[viewJa021a] paramCorpGr: {}, cookieCorpGr: {}, principalCorpGr: {}, resolved corpGr: '{}', corpNm: '{}'",
                paramCorpGr, cookieCorpGr, (principal != null ? principal.getCorpGr() : null), corpGr, corpNm);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr != null ? corpGr : "");
        model.addAttribute("corpNm", corpNm != null ? corpNm : "");
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/subscriptionrights/w_ja021a";
    }

    /**
     * 운용사명 비동기 조회 (회사변경 시 클라이언트 필터 갱신 지원)
     */
    @GetMapping("/api/subscriptionrights/ja021a/company-name")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getCompanyName(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String targetCorpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr.trim()
                : (principal != null && principal.getCorpGr() != null ? principal.getCorpGr().trim() : "");

        String name = "";
        if (!targetCorpGr.isBlank()) {
            name = ja021aService.getCompanyName(targetCorpGr);
        }
        if ((name == null || name.isBlank()) && principal != null && targetCorpGr.equals(principal.getCorpGr())) {
            name = principal.getCompanyName();
        }

        return ResponseEntity.ok(Map.of(
                "corpGr", targetCorpGr,
                "companyName", name != null ? name : ""
        ));
    }

    /**
     * 마스터 목록 조회 (d_ja021a1)
     */
    @GetMapping("/api/subscriptionrights/ja021a/master")
    @ResponseBody
    public ResponseEntity<List<Ja021aMasterDto>> getMasterList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "trCd", defaultValue = "G10") String trCd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        // 상단 배당적용대상이 '%'이면 paramCorpGr가 '%'로 넘어옴
        String targetCorpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr : corpGr;

        List<Ja021aMasterDto> list = ja021aService.getMasterList(targetCorpGr, ymd, trCd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 디테일 목록 조회 (d_ja021a2)
     */
    @GetMapping("/api/subscriptionrights/ja021a/detail")
    @ResponseBody
    public ResponseEntity<List<Ja021aDetailDto>> getDetailList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "trCd", defaultValue = "G10") String trCd,
            @RequestParam(name = "balhCo") String balhCo,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        String targetCorpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr : corpGr;

        List<Ja021aDetailDto> list = ja021aService.getDetailList(targetCorpGr, ymd, trCd, balhCo);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 발행기관 액면가 조회
     */
    @GetMapping("/api/subscriptionrights/ja021a/aekm")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getBalhAekm(@RequestParam("balhCo") String balhCo) {
        BigDecimal aekm = ja021aService.getBalhAekm(balhCo);
        Map<String, Object> res = new HashMap<>();
        res.put("balhCo", balhCo);
        res.put("aekm", aekm);
        return ResponseEntity.ok(res);
    }

    /**
     * 우선주 구분 조회
     */
    @GetMapping("/api/subscriptionrights/ja021a/check-woos")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkWoos(@RequestParam("balhCo") String balhCo) {
        String method = ja021aService.getWoosStockMethod(balhCo);
        Map<String, Object> res = new HashMap<>();
        res.put("balhCo", balhCo);
        res.put("method", method);
        return ResponseEntity.ok(res);
    }

    /**
     * CUD 일괄 저장
     */
    @PostMapping("/api/subscriptionrights/ja021a/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveData(@RequestBody Ja021aSaveDto saveDto) {
        Map<String, Object> result = new HashMap<>();
        try {
            ja021aService.save(saveDto);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("예상배당 공시등록 저장 실패", e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
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
