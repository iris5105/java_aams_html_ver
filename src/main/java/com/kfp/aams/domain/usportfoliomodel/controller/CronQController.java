package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.CronQDto;
import com.kfp.aams.domain.usportfoliomodel.dto.CronStatusDto;
import com.kfp.aams.domain.usportfoliomodel.service.CronQService;
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
 * CRON 작업 및 프로시저 관리 (W_CRON_Q) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class CronQController {

    private final CronQService cronQService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_cron_q", "/views/usportfoliomodel/w_cron_q"})
    public String viewCronQ(@AuthenticationPrincipal Object principalObj,
                            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                            @RequestParam(name = "ymd", required = false) String paramYmd,
                            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                            Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_CRON_Q");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_cron_q");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > CRON";

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

        return "views/usportfoliomodel/w_cron_q";
    }

    /**
     * CRON 큐 목록 조회
     */
    @GetMapping("/api/usportfoliomodel/cron-q/list")
    @ResponseBody
    public List<CronQDto> getCronQList() {
        try {
            return cronQService.getCronQList();
        } catch (Exception e) {
            log.error("CRON 큐 목록 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * CRON 실행 이력/상태 목록 조회
     */
    @GetMapping("/api/usportfoliomodel/cron-q/status")
    @ResponseBody
    public List<CronStatusDto> getCronStatusList(@RequestParam(name = "cronKey", required = false) String cronKey) {
        try {
            return cronQService.getCronStatusList(cronKey);
        } catch (Exception e) {
            log.error("CRON 상태 이력 조회 실패 (cronKey: {}): {}", cronKey, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * CRON 큐 변경 데이터 일괄 저장 (CUD)
     */
    @PostMapping("/api/usportfoliomodel/cron-q/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveCronQList(@RequestBody List<CronQDto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            cronQService.saveCronQList(list);
            result.put("success", true);
            result.put("message", "CRON 정보가 정상적으로 저장되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("CRON 큐 저장 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "CRON 정보 저장 중 오류가 발생했습니다: " + e.getMessage());
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
