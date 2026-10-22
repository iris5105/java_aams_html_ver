package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032hDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032hService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * W_JA032H 해외 업종/지수/환율 코드 관리 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032hController {

    private final Ja032hService ja032hService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032h", "/views/usportfoliomodel/w_ja032h"})
    public String viewJa032h(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032H");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032h");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > 해외 업종/지수/환율 코드";

        // DB 영업일자 연동 (규정 01-3 Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032h";
    }

    /**
     * 해외 업종/지수/환율 코드 목록 조회
     */
    @GetMapping("/api/usportfoliomodel/ja032h/list")
    @ResponseBody
    public List<Ja032hDto> getList(@RequestParam(name = "frid", required = false) String frid,
                                   @RequestParam(name = "keyword", required = false) String keyword) {
        try {
            return ja032hService.searchList(frid, keyword);
        } catch (Exception e) {
            log.error("해외 업종/지수/환율 코드 목록 조회 오류: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 해외 코드 CUD 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/ja032h/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveList(@RequestBody List<Ja032hDto> list) {
        try {
            Map<String, Object> result = ja032hService.save(list);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("해외 코드 저장 오류: {}", e.getMessage(), e);
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(err);
        }
    }

    /**
     * 종목LOAD (MST 파일 업로드 및 일괄 등록)
     */
    @PostMapping("/api/usportfoliomodel/ja032h/upload-mst")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadMstFile(@RequestParam("file") MultipartFile file) {
        try {
            Map<String, Object> result = ja032hService.loadMstFile(file);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("MST 파일 업로드 실패: {}", e.getMessage(), e);
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "업로드 처리 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(err);
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
