package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fKrxDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja991a2Dto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032fKrxService;
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
 * KRX 주식종목정보 (W_JA032F_KRX) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032fKrxController {

    private final Ja032fKrxService ja032fKrxService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032f_krx", "/views/usportfoliomodel/w_ja032f_krx"})
    public String viewJa032fKrx(@AuthenticationPrincipal Object principalObj,
                                @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                @RequestParam(name = "ymd", required = false) String paramYmd,
                                @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032F_KRX");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032f_krx");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > KRX 종목정보";

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
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("isAdmin", isAdmin);

        return "views/usportfoliomodel/w_ja032f_krx";
    }

    /**
     * KRX 주식 종목정보 목록 조회 (마스터)
     */
    @GetMapping("/api/usportfoliomodel/ja032f-krx/master")
    @ResponseBody
    public List<Ja032fKrxDto> getKrxStockList() {
        try {
            return ja032fKrxService.getKrxStockList();
        } catch (Exception e) {
            log.error("KRX 종목정보 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 특정 종목의 일별 시세 목록 조회 (상세)
     */
    @GetMapping("/api/usportfoliomodel/ja032f-krx/detail")
    @ResponseBody
    public List<Ja991a2Dto> getDailyPriceList(@RequestParam(name = "koscomCd") String koscomCd,
                                              @RequestParam(name = "ymd") String ymd) {
        try {
            return ja032fKrxService.getDailyPriceList(koscomCd, ymd);
        } catch (Exception e) {
            log.error("종목 일별 시세 조회 실패 (koscomCd: {}, ymd: {}): {}", koscomCd, ymd, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * USPM 등록종목 변경사항 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/ja032f-krx/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveKrxStockUspmList(@RequestParam(name = "corpGr") String corpGr,
                                                                    @RequestParam(name = "ymd") String ymd,
                                                                    @RequestBody List<Ja032fKrxDto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            ja032fKrxService.saveKrxStockUspmList(corpGr, ymd, list);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("USPM 등록정보 저장 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    /**
     * 특정 종목 일별 시세(d_ja991a2) 인라인 편집 변경사항 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/ja032f-krx/detail/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveDailyPriceList(@RequestBody List<Ja991a2Dto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            ja032fKrxService.saveDailyPriceList(list);
            result.put("success", true);
            result.put("message", "일별 시세가 정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("일별 시세 저장 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "일별 시세 저장 중 오류가 발생했습니다: " + e.getMessage());
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
