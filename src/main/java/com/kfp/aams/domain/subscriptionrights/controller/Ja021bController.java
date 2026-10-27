package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.domain.subscriptionrights.dto.Ja021bCorpDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bFundDetailDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bItemDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bMasterDto;
import com.kfp.aams.domain.subscriptionrights.dto.Ja021bSaveDto;
import com.kfp.aams.domain.subscriptionrights.service.Ja021bService;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja021bController {

    private final Ja021bService ja021bService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja021b", "/views/subscriptionrights/w_ja021b"})
    public String viewJa021b(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @RequestParam(name = "ym", required = false) String paramYm,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA021B");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja021b");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 공모청약(권리) > 공모청약(권리)관리 > (자문사별)예상배당 확정등록";

        // 작업일자 연동 (SZX0AA.HYUN_YMD)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : ja021bService.getWorkDate(corpGr);

        // PB wue_lastopen 로직: workDate 일자가 10일 미만이면 전월, 아니면 당월 (YYYY-MM)
        String initialYm = paramYm;
        if (initialYm == null || initialYm.isBlank()) {
            try {
                LocalDate date = LocalDate.parse(workDate.replace(".", "-"));
                if (date.getDayOfMonth() < 10) {
                    date = date.minusMonths(1);
                }
                initialYm = date.format(DateTimeFormatter.ofPattern("yyyy-MM"));
            } catch (Exception e) {
                initialYm = (workDate.length() >= 7) ? workDate.substring(0, 7) : "2026-10";
            }
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("initialYm", initialYm);
        model.addAttribute("ym", initialYm);

        return "views/subscriptionrights/w_ja021b";
    }

    /**
     * 좌측 회사 목록 조회 (dl_corp_gr)
     */
    @GetMapping("/api/subscriptionrights/ja021b/corps")
    @ResponseBody
    public ResponseEntity<List<Ja021bCorpDto>> getCorpList(
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "customerGr", defaultValue = "자산운용") String customerGr,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        // aams 사용자이거나 paramCorpGr가 '%'이면 전체 조회
        String targetCorpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr : "%";

        List<Ja021bCorpDto> list = ja021bService.getCorpList(ym, customerGr, targetCorpGr);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 탭 1: 예상배당공시 마스터 목록 조회 (d_ja021b_t11)
     */
    @GetMapping("/api/subscriptionrights/ja021b/t1/master")
    @ResponseBody
    public ResponseEntity<List<Ja021bMasterDto>> getT1MasterList(
            @RequestParam(name = "corpGr", defaultValue = "%") String corpGr,
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "customerGr", defaultValue = "자산운용") String customerGr) {

        List<Ja021bMasterDto> list = ja021bService.getT1MasterList(corpGr, ym, customerGr);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 종목별 배당 상세 조회 (d_ja021b_t12, d_ja021b_p1)
     */
    @GetMapping("/api/subscriptionrights/ja021b/items")
    @ResponseBody
    public ResponseEntity<List<Ja021bItemDto>> getItemList(
            @RequestParam(name = "corpGr", defaultValue = "%") String corpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "trCd", defaultValue = "G10") String trCd,
            @RequestParam(name = "balhCo") String balhCo) {

        List<Ja021bItemDto> list = ja021bService.getItemList(corpGr, ymd, trCd, balhCo);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 탭 2: 운용사별 예상배당 마스터 목록 조회 (d_ja021b_t21)
     */
    @GetMapping("/api/subscriptionrights/ja021b/t2/master")
    @ResponseBody
    public ResponseEntity<List<Ja021bMasterDto>> getT2MasterList(
            @RequestParam(name = "corpGr") String corpGr,
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "workDate", required = false) String workDate) {

        String queryWorkDate = (workDate != null && !workDate.isBlank())
                ? workDate
                : ja021bService.getWorkDate(corpGr);

        List<Ja021bMasterDto> list = ja021bService.getT2MasterList(corpGr, ym, queryWorkDate);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 탭 2: 펀드별 배당권리 상세 조회 (d_ja021b_t22)
     */
    @GetMapping("/api/subscriptionrights/ja021b/t2/detail")
    @ResponseBody
    public ResponseEntity<List<Ja021bFundDetailDto>> getT2DetailList(
            @RequestParam(name = "corpGr") String corpGr,
            @RequestParam(name = "ymd") String ymd,
            @RequestParam(name = "balhCo") String balhCo) {

        List<Ja021bFundDetailDto> list = ja021bService.getT2DetailList(corpGr, ymd, balhCo);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 탭 3: 현금확정배당(G20) 마스터 목록 조회 (d_ja021b_t31)
     */
    @GetMapping("/api/subscriptionrights/ja021b/t3/master")
    @ResponseBody
    public ResponseEntity<List<Ja021bMasterDto>> getT3MasterList(
            @RequestParam(name = "customerGr", defaultValue = "자산운용") String customerGr,
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "workDate", required = false) String workDate,
            @RequestParam(name = "corpGr", required = false) String corpGr) {

        String queryWorkDate = (workDate != null && !workDate.isBlank())
                ? workDate
                : ja021bService.getWorkDate(corpGr != null ? corpGr : "2402");

        List<Ja021bMasterDto> list = ja021bService.getT3MasterList(customerGr, ym, queryWorkDate);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 탭 3~5: 펀드별 배당권리 상세 조회 (d_ja021b_t32, t42, t52)
     */
    @GetMapping("/api/subscriptionrights/ja021b/t3/detail")
    @ResponseBody
    public ResponseEntity<List<Ja021bFundDetailDto>> getT3DetailList(
            @RequestParam(name = "corpGr", defaultValue = "%") String corpGr,
            @RequestParam(name = "customerGr", defaultValue = "자산운용") String customerGr,
            @RequestParam(name = "brokYmd") String brokYmd,
            @RequestParam(name = "balhCo") String balhCo) {

        List<Ja021bFundDetailDto> list = ja021bService.getT3DetailList(corpGr, customerGr, brokYmd, balhCo);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 탭 4: 주식확정배당(G20) 마스터 목록 조회 (d_ja021b_t41)
     */
    @GetMapping("/api/subscriptionrights/ja021b/t4/master")
    @ResponseBody
    public ResponseEntity<List<Ja021bMasterDto>> getT4MasterList(
            @RequestParam(name = "customerGr", defaultValue = "자산운용") String customerGr,
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "workDate", required = false) String workDate,
            @RequestParam(name = "corpGr", required = false) String corpGr) {

        String queryWorkDate = (workDate != null && !workDate.isBlank())
                ? workDate
                : ja021bService.getWorkDate(corpGr != null ? corpGr : "2402");

        List<Ja021bMasterDto> list = ja021bService.getT4MasterList(customerGr, ym, queryWorkDate);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 탭 5: 2차(주총)확정(G25) 마스터 목록 조회 (d_ja021b_t51)
     */
    @GetMapping("/api/subscriptionrights/ja021b/t5/master")
    @ResponseBody
    public ResponseEntity<List<Ja021bMasterDto>> getT5MasterList(
            @RequestParam(name = "customerGr", defaultValue = "자산운용") String customerGr,
            @RequestParam(name = "ym") String ym,
            @RequestParam(name = "workDate", required = false) String workDate,
            @RequestParam(name = "corpGr", required = false) String corpGr) {

        String queryWorkDate = (workDate != null && !workDate.isBlank())
                ? workDate
                : ja021bService.getWorkDate(corpGr != null ? corpGr : "2402");

        List<Ja021bMasterDto> list = ja021bService.getT5MasterList(customerGr, ym, queryWorkDate);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 발행사 액면가 조회
     */
    @GetMapping("/api/subscriptionrights/ja021b/aekm")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getBalhAekm(@RequestParam("balhCo") String balhCo) {
        BigDecimal aekm = ja021bService.getBalhAekm(balhCo);
        Map<String, Object> res = new HashMap<>();
        res.put("balhCo", balhCo);
        res.put("aekm", aekm);
        return ResponseEntity.ok(res);
    }

    /**
     * CUD 일괄 저장
     */
    @PostMapping("/api/subscriptionrights/ja021b/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveData(@RequestBody Ja021bSaveDto saveDto) {
        Map<String, Object> result = new HashMap<>();
        try {
            ja021bService.save(saveDto);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("[JA021B] 저장 실패", e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.badRequest().body(result);
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
        return "";
    }
}
