package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aPortDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032aSaveRequestDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032aService;
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

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032aController {

    private final Ja032aService ja032aService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja032a", "/views/usportfoliomodel/w_ja032a"})
    public String viewJa032a(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        var menuDto = menuService.getMenuByPgmId("W_JA032A");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032a");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "일별자문 > US포트폴리오모델 > 포트폴리오 모델 등록";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja032aService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032a";
    }

    /**
     * 회사 변경 시 작업일자 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja032a/workdate")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja032aService.getWorkDate(corpGr);
        if (workDate == null || workDate.isBlank()) {
            workDate = LocalDate.now().toString();
        }
        Map<String, String> response = new HashMap<>();
        response.put("workDate", workDate);
        return ResponseEntity.ok(response);
    }

    /**
     * 1. 마스터 펀드 목록 조회 API (d_ja032a1)
     */
    @GetMapping("/api/usportfoliomodel/ja032a/master")
    @ResponseBody
    public ResponseEntity<List<Ja032aMasterDto>> getMasterList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja032aMasterDto> list = ja032aService.getMasterList(corpGr, ymd);
        return ResponseEntity.ok(list);
    }

    /**
     * 2. 포트 목록 조회 API (d_ja032a2)
     */
    @GetMapping("/api/usportfoliomodel/ja032a/port")
    @ResponseBody
    public ResponseEntity<List<Ja032aPortDto>> getPortList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "fundCd") String fundCd,
            @RequestParam(name = "trYmd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate trYmd,
            @RequestParam(name = "fundJmPer", required = false) BigDecimal fundJmPer,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja032aPortDto> list = ja032aService.getPortList(corpGr, fundCd, trYmd, fundJmPer);
        return ResponseEntity.ok(list);
    }

    /**
     * 3. 종목 상세 목록 조회 API (d_ja032a3 / d_ja032a3a)
     */
    @GetMapping("/api/usportfoliomodel/ja032a/detail")
    @ResponseBody
    public ResponseEntity<List<Ja032aDetailDto>> getDetailList(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @RequestParam(name = "fundCd") String fundCd,
            @RequestParam(name = "portNum") String portNum,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        if (corpGr == null || corpGr.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja032aDetailDto> list = ja032aService.getDetailList(corpGr, ymd, fundCd, portNum);
        return ResponseEntity.ok(list);
    }

    /**
     * 4. 환율 조회 API (SYX1HY)
     */
    @GetMapping("/api/usportfoliomodel/ja032a/exchange-rate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getExchangeRate(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "trYmd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate trYmd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        BigDecimal rate = ja032aService.getUsdExchangeRate(corpGr, trYmd);
        Map<String, Object> res = new HashMap<>();
        res.put("rate", rate);
        return ResponseEntity.ok(res);
    }

    /**
     * 5. 일괄 저장 API (마스터, 포트, 종목 상세)
     */
    @PostMapping("/api/usportfoliomodel/ja032a/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveAll(
            @RequestBody Ja032aSaveRequestDto saveDto,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(saveDto.getCorpGr(), cookieCorpGr, principal);
        saveDto.setCorpGr(corpGr);

        Map<String, Object> result = ja032aService.saveAll(saveDto);
        return ResponseEntity.ok(result);
    }

    /**
     * 6. 마스터 펀드 삭제 API
     */
    @PostMapping("/api/usportfoliomodel/ja032a/delete-master")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteMaster(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
            @RequestParam(name = "fundCd") String fundCd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        Map<String, Object> result = ja032aService.deleteMaster(corpGr, ymd, fundCd);
        return ResponseEntity.ok(result);
    }

    /**
     * 7. 변동성 재계산 API (SR_JA032A)
     */
    @PostMapping("/api/usportfoliomodel/ja032a/recalculate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> recalculate(
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd") String ymd,
            @AuthenticationPrincipal Object principalObj,
            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {

        UserPrincipal principal = (principalObj instanceof UserPrincipal p) ? p : null;
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principal);

        Map<String, Object> result = ja032aService.recalculateVolatility(corpGr, ymd);
        return ResponseEntity.ok(result);
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
