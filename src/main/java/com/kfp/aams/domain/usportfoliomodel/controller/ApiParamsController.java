package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.ApiParamsDto;
import com.kfp.aams.domain.usportfoliomodel.service.ApiParamsService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
 * API PARAMETER 관리 (W_API_PARAMS) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class ApiParamsController {

    private final ApiParamsService apiParamsService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_api_params", "/views/usportfoliomodel/w_api_params"})
    public String viewApiParams(@AuthenticationPrincipal Object principalObj,
                                @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                @RequestParam(name = "ymd", required = false) String paramYmd,
                                @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_API_PARAMS");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_api_params");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > API PARAMETER 관리";

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
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);
        model.addAttribute("isAdmin", isAdmin);

        return "views/usportfoliomodel/w_api_params";
    }

    /**
     * API 파라미터 목록 조회
     */
    @GetMapping("/api/usportfoliomodel/api-params/list")
    @ResponseBody
    public List<ApiParamsDto> getApiParamsList(@RequestParam(name = "trCoCd", required = false) String trCoCd) {
        try {
            return apiParamsService.getApiParamsList(trCoCd);
        } catch (Exception e) {
            log.error("API 파라미터 목록 조회 실패 (trCoCd: {}): {}", trCoCd, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * API 파라미터 변경 데이터 일괄 저장 (CUD)
     */
    @PostMapping("/api/usportfoliomodel/api-params/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveApiParamsList(@RequestBody List<ApiParamsDto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            apiParamsService.saveApiParamsList(list);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("API 파라미터 일괄 저장 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    /**
     * API_Q 요청 레코드 생성 (단건)
     */
    @PostMapping("/api/usportfoliomodel/api-params/create-q")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createApiQRequest(@RequestBody ApiParamsDto dto) {
        Map<String, Object> result = new HashMap<>();
        try {
            apiParamsService.createApiQRequest(dto);
            result.put("success", true);
            result.put("message", "API_Q에 요청자료가 성공적으로 생성되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("API_Q 요청 레코드 생성 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "요청자료 생성 중 오류가 발생했습니다: " + e.getMessage());
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
        return "";
    }
}
