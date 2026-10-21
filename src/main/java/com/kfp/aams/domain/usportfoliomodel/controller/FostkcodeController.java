package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.FostkcodeDto;
import com.kfp.aams.domain.usportfoliomodel.service.FostkcodeService;
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
 * 해외파생 종목코드 (W_FOSTKCODE) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class FostkcodeController {

    private final FostkcodeService fostkcodeService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_fostkcode", "/views/usportfoliomodel/w_fostkcode", "/views/foreignassetmanagement/w_fostkcode"})
    public String viewFostkcode(@AuthenticationPrincipal Object principalObj,
                                @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                @RequestParam(name = "ym", required = false) String paramYm,
                                @RequestParam(name = "ymd", required = false) String paramYmd,
                                @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_FOSTKCODE");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_fostkcode");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 해외파생 종목코드";

        // DB 영업일자 (SZX0AA.HYUN_YMD) 연동 (규정 01-3 Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        // 기본 만기월: 파워빌더 w_fostkcode.srw::wue_lastopen -> string(idt_workdate, 'yyyymm')
        String ym = (paramYm != null && !paramYm.isBlank())
                ? paramYm
                : (workDate.length() >= 7 ? workDate.substring(0, 7) : workDate);

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
        model.addAttribute("ym", ym);
        model.addAttribute("isAdmin", isAdmin);

        return "views/usportfoliomodel/w_fostkcode";
    }

    /**
     * 해외파생 종목코드 목록 조회
     */
    @GetMapping("/api/usportfoliomodel/fostkcode/list")
    @ResponseBody
    public List<FostkcodeDto> getFostkcodeList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "ym") String ym,
                                               @RequestParam(name = "symbol", required = false) String symbol) {
        try {
            return fostkcodeService.getFostkcodeList(corpGr, ym, symbol);
        } catch (Exception e) {
            log.error("종목코드 목록 조회 실패 (corpGr: {}, ym: {}): {}", corpGr, ym, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 종목코드 데이터 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/fostkcode/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveFostkcodeList(@RequestParam(name = "corpGr") String corpGr,
                                                                 @RequestBody List<FostkcodeDto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            fostkcodeService.saveFostkcodeList(corpGr, list);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("종목코드 저장 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    /**
     * 종목LOAD (.mst 파생종목파일 업로드)
     */
    @PostMapping("/api/usportfoliomodel/fostkcode/load")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadMstFile(@RequestParam("file") MultipartFile file) {
        Map<String, Object> result = new HashMap<>();
        try {
            int count = fostkcodeService.loadMstFile(file);
            result.put("success", true);
            result.put("message", "해외 종목정보 LOAD를 완료했습니다. (신규 등록: " + count + "건)");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("해외 종목정보 LOAD 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "종목LOAD 중 오류가 발생했습니다: " + e.getMessage());
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
