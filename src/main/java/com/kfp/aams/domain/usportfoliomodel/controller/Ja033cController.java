package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja033cDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja033cService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * KRX 통화/금리/상품 선물/옵션 종목 (W_JA033C) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja033cController {

    private final Ja033cService ja033cService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja033c", "/views/usportfoliomodel/w_ja033c"})
    public String viewJa033c(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA033C");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja033c");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 > KRX 통화 선물/옵션 종목";

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

        return "views/usportfoliomodel/w_ja033c";
    }

    /**
     * 통화/금리/상품 선물/옵션 종목 목록 조회
     */
    @GetMapping("/api/usportfoliomodel/ja033c/list")
    @ResponseBody
    public List<Ja033cDto> getFoComCodeList(@RequestParam(name = "comType", required = false) String comType,
                                            @RequestParam(name = "infoType", required = false) String infoType) {
        try {
            return ja033cService.getFoComCodeList(comType, infoType);
        } catch (Exception e) {
            log.error("통화/금리/상품 선물/옵션 종목 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 통화/금리/상품 선물/옵션 종목 일괄 저장 (CUD)
     */
    @PostMapping("/api/usportfoliomodel/ja033c/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveFoComCodeList(@RequestBody List<Ja033cDto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            ja033cService.saveFoComCodeList(list);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("통화/금리/상품 선물/옵션 종목 저장 중 오류: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    /**
     * 관리자 전용: 마스터 파일(fo_com*.mst) 파싱 및 종목 일괄 업로드 (cb_load)
     */
    @PostMapping("/api/usportfoliomodel/ja033c/load-master-file")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> loadMasterFile(@RequestParam("file") MultipartFile file) {
        try {
            Map<String, Object> result = ja033cService.loadMasterFile(file);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("통화/금리/상품 마스터 파일 LOAD 중 오류: {}", e.getMessage(), e);
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "종목 LOAD 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principalObj instanceof UserPrincipal userPrincipal && userPrincipal.getCorpGr() != null && !userPrincipal.getCorpGr().isBlank()) {
            return userPrincipal.getCorpGr().trim();
        }
        return "2402";
    }
}
