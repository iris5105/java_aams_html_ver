package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja031kDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja031kSaveRequest;
import com.kfp.aams.domain.assetmanagement.service.Ja031kService;
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
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja031kController {

    private final Ja031kService service;
    private final WorkDateService workDateService;
    private final MenuService menuService;

    /**
     * W_JA031K 화면 뷰 매핑
     */
    @GetMapping({"/views/w_ja031k", "/views/assetmanagement/w_ja031k"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA031K");
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("ymd", workDate);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fullpgm2", menu != null ? menu.getFullpgm2() : "사무관리 > 자산운용 > 3022 기타수입 입금등록 [W_JA031K]");
        return "views/assetmanagement/w_ja031k";
    }

    /**
     * 입금거래 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja031k/list")
    @ResponseBody
    public List<Ja031kDto> list(@AuthenticationPrincipal UserPrincipal principal,
                                @RequestParam(required = false) String corpGr,
                                @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd", fallbackPatterns = {"yyyyMMdd", "yyyy.MM.dd"}) LocalDate ymd,
                                @RequestParam String trCd) {
        return service.list(resolveCorpGr(principal, corpGr, savedCorpGr), ymd, trCd);
    }

    /**
     * 달력 하이라이트 일자 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja031k/dates")
    @ResponseBody
    public List<String> dates(@AuthenticationPrincipal UserPrincipal principal,
                              @RequestParam(required = false) String corpGr,
                              @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        return service.getHighlightDates(resolveCorpGr(principal, corpGr, savedCorpGr));
    }

    /**
     * 펀드 및 수탁사 정보 조회
     */
    @GetMapping("/api/assetmanagement/ja031k/fund-info")
    @ResponseBody
    public Map<String, Object> fundInfo(@AuthenticationPrincipal UserPrincipal principal,
                                        @RequestParam(required = false) String corpGr,
                                        @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                                        @RequestParam String fundCd) {
        return service.getFundInfo(resolveCorpGr(principal, corpGr, savedCorpGr), fundCd);
    }

    /**
     * CUD 일괄 저장
     */
    @PostMapping("/api/assetmanagement/ja031k/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> save(@AuthenticationPrincipal UserPrincipal principal,
                                                    @RequestBody Ja031kSaveRequest request) {
        if (request != null && (request.getCorpGr() == null || request.getCorpGr().isBlank())) {
            request.setCorpGr(resolveCorpGr(principal, null, null));
        }
        try {
            Map<String, Object> res = service.save(request);
            return ResponseEntity.ok(res);
        } catch (IllegalArgumentException e) {
            log.warn("[Ja031kController] 저장 검증 오류: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        } catch (Exception e) {
            log.error("[Ja031kController] 저장 처리 중 오류 발생", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 처리 중 오류가 발생했습니다: " + e.getMessage()));
        }
    }

    private String resolveCorpGr(UserPrincipal principal, String corpGr, String savedCorpGr) {
        if (corpGr != null && !corpGr.isBlank()) return corpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
            return principal.getCorpGr().trim();
        }
        return "2402";
    }
}

