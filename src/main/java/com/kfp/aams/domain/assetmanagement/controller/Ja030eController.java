package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja030eMasterDto;
import com.kfp.aams.domain.assetmanagement.service.Ja030eService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;

/**
 * W_JA030E 채권 종목정보 및 보유현황 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja030eController {

    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja030eService ja030eService;

    @GetMapping({"/views/w_ja030e", "/views/assetmanagement/w_ja030e"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @RequestParam(required = false) String corpNm,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       @CookieValue(name = "corpNm", required = false) String cookieCorpNm,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA030E");

        String resolvedCorpNm = resolveCorpNm(principal, resolvedCorpGr, corpNm, cookieCorpNm);

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("corpNm", resolvedCorpNm);
        model.addAttribute("companyName", resolvedCorpNm);
        model.addAttribute("workDate", workDate);
        model.addAttribute("pgmNo", menu == null ? "3101" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA030E" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja030e";
    }

    /**
     * 상단 보유 채권 종목 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja030e/list")
    @ResponseBody
    public ResponseEntity<List<Ja030eMasterDto>> getList(@AuthenticationPrincipal UserPrincipal principal,
                                                         @RequestParam(required = false) String corpGr,
                                                         @RequestParam String ymd,
                                                         @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        List<Ja030eMasterDto> list = ja030eService.getMasterList(resolvedCorpGr, ymd);
        return ResponseEntity.ok(list);
    }

    /**
     * 하단 채권 종목 기본 정보 및 펀드별 보유현황 조회
     */
    @GetMapping("/api/assetmanagement/ja030e/detail")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDetail(@AuthenticationPrincipal UserPrincipal principal,
                                                         @RequestParam(required = false) String corpGr,
                                                         @RequestParam String jmCd,
                                                         @RequestParam String ymd,
                                                         @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        Map<String, Object> detail = ja030eService.getDetailInfo(resolvedCorpGr, jmCd, ymd);
        detail.put("corpNm", ja030eService.getCompanyName(resolvedCorpGr));
        return ResponseEntity.ok(detail);
    }

    private String resolveCorpNm(UserPrincipal principal, String corpGr, String requestCorpNm, String cookieCorpNm) {
        if (requestCorpNm != null && !requestCorpNm.isBlank()) return requestCorpNm.trim();
        String dbName = ja030eService.getCompanyName(corpGr);
        if (dbName != null && !dbName.isBlank()) return dbName.trim();
        if (principal != null && principal.getCompanyName() != null && !principal.getCompanyName().isBlank()) {
            return principal.getCompanyName().trim();
        }
        if (cookieCorpNm != null && !cookieCorpNm.isBlank()) return cookieCorpNm.trim();
        return "";
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

