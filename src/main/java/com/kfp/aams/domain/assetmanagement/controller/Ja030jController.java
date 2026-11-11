package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.Ja030jDetailDto;
import com.kfp.aams.domain.assetmanagement.dto.Ja030jDto;
import com.kfp.aams.domain.assetmanagement.service.Ja030jService;
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

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja030jController {

    private final WorkDateService workDateService;
    private final MenuService menuService;
    private final Ja030jService ja030jService;

    @GetMapping({"/views/w_ja030j", "/views/assetmanagement/w_ja030j"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(required = false) String corpGr,
                       @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr,
                       Model model) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        String workDate = workDateService.getWorkDateOrDefault(resolvedCorpGr);
        var menu = menuService.getMenuByPgmId("W_JA030J");

        model.addAttribute("corpGr", resolvedCorpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("pgmNo", menu == null ? "" : menu.getPgmNo());
        model.addAttribute("fullpgm2", menu == null ? "W_JA030J" : menu.getFullpgm2());

        return "views/assetmanagement/w_ja030j";
    }

    /**
     * 채권 잔고/수익 상세 목록 조회
     */
    @GetMapping("/api/assetmanagement/ja030j/list")
    @ResponseBody
    public ResponseEntity<List<Ja030jDto>> getList(@AuthenticationPrincipal UserPrincipal principal,
                                                   @RequestParam(required = false) String corpGr,
                                                   @RequestParam String fymd,
                                                   @RequestParam String tymd,
                                                   @RequestParam(defaultValue = "1") String gubun,
                                                   @RequestParam(required = false, defaultValue = "%") String cashCd,
                                                   @RequestParam(required = false) String hjCd,
                                                   @RequestParam(required = false) String fundCd,
                                                   @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        List<Ja030jDto> list = ja030jService.getJa030jList(resolvedCorpGr, fymd, tymd, gubun, cashCd, hjCd, fundCd);
        return ResponseEntity.ok(list);
    }

    /**
     * 채권 상세 정보 조회
     */
    @GetMapping("/api/assetmanagement/ja030j/detail")
    @ResponseBody
    public ResponseEntity<Ja030jDetailDto> getDetail(@AuthenticationPrincipal UserPrincipal principal,
                                                     @RequestParam(required = false) String corpGr,
                                                     @RequestParam String ymd,
                                                     @RequestParam String fundCd,
                                                     @RequestParam String jmCd,
                                                     @CookieValue(name = "savedCorpGr", required = false) String savedCorpGr) {
        String resolvedCorpGr = resolveCorpGr(principal, corpGr, savedCorpGr);
        Ja030jDetailDto detail = ja030jService.getJa030jDetail(resolvedCorpGr, ymd, fundCd, jmCd);
        return ResponseEntity.ok(detail);
    }

    private String resolveCorpGr(UserPrincipal principal, String requestCorpGr, String savedCorpGr) {
        if (requestCorpGr != null && !requestCorpGr.isBlank()) return requestCorpGr.trim();
        if (savedCorpGr != null && !savedCorpGr.isBlank()) return savedCorpGr.trim();
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr().trim();
        throw new IllegalArgumentException("회사그룹 정보가 없습니다.");
    }
}

