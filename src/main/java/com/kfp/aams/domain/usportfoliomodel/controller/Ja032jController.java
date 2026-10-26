package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032jDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032jMasterDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032jService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 해외주식종가/업종지수 등록 (W_JA032J) 컨트롤러
 */
@Slf4j
@Controller
public class Ja032jController {

    private final Ja032jService ja032jService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    // 명시적 생성자 주입 (Zero-Lombok-ECJ-Conflict 원칙, 규정 01-4)
    public Ja032jController(Ja032jService ja032jService, MenuService menuService, WorkDateService workDateService) {
        this.ja032jService = ja032jService;
        this.menuService = menuService;
        this.workDateService = workDateService;
    }

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032j", "/views/usportfoliomodel/w_ja032j"})
    public String viewJa032j(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032J");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032j");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 > 해외주식종가/업종지수 등록";

        // DB 영업일자 (SZX0AA.HYUN_YMD) 연동 (규정 01-3 Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032j";
    }

    /**
     * 1. 마스터 종가일자 목록 조회 (d_ja032j1)
     */
    @GetMapping("/api/usportfoliomodel/ja032j/master")
    @ResponseBody
    public List<Ja032jMasterDto> getMasterList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                               @AuthenticationPrincipal Object principalObj) {
        try {
            if (corpGr == null || corpGr.isBlank()) {
                corpGr = resolveCorpGr(null, null, principalObj);
            }
            return ja032jService.getMasterList(corpGr);
        } catch (Exception e) {
            log.error("해외주식종가 마스터 목록 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 2. 디테일 해외주식 종가 목록 조회 (d_ja032j2)
     */
    @GetMapping("/api/usportfoliomodel/ja032j/detail")
    @ResponseBody
    public List<Ja032jDetailDto> getDetailList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                               @RequestParam(name = "ymd") String ymd,
                                               @AuthenticationPrincipal Object principalObj) {
        try {
            if (corpGr == null || corpGr.isBlank()) {
                corpGr = resolveCorpGr(null, null, principalObj);
            }
            return ja032jService.getDetailList(corpGr, ymd);
        } catch (Exception e) {
            log.error("해외주식종가 디테일 목록 조회 실패 corpGr={}, ymd={}: {}", corpGr, ymd, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 3. 디테일 CUD 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/ja032j/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveDetailList(@RequestParam(name = "corpGr", required = false) String corpGr,
                                                              @RequestParam(name = "ymd") String ymd,
                                                              @RequestBody List<Ja032jDetailDto> list,
                                                              @AuthenticationPrincipal Object principalObj) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (corpGr == null || corpGr.isBlank()) {
                corpGr = resolveCorpGr(null, null, principalObj);
            }
            int savedCount = ja032jService.saveDetailList(corpGr, ymd, list);
            response.put("success", true);
            response.put("savedCount", savedCount);
            response.put("message", "정상적으로 저장되었습니다. (" + savedCount + "건 처리)");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("해외주식종가 디테일 저장 실패: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principalObj instanceof UserPrincipal userPrincipal) {
            if (userPrincipal.getCorpGr() != null && !userPrincipal.getCorpGr().isBlank()) {
                return userPrincipal.getCorpGr().trim();
            }
        }
        return "";
    }
}
