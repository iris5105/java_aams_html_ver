package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dStatusDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032dService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
 * API 자료요청 현황 (W_JA032D) 컨트롤러
 */
@Controller
public class Ja032dController {

    private static final Logger log = LoggerFactory.getLogger(Ja032dController.class);

    private final Ja032dService ja032dService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    // 명시적 생성자 주입 (Zero-Lombok-ECJ-Conflict 원칙, 규정 01-4)
    public Ja032dController(Ja032dService ja032dService, MenuService menuService, WorkDateService workDateService) {
        this.ja032dService = ja032dService;
        this.menuService = menuService;
        this.workDateService = workDateService;
    }

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032d", "/views/usportfoliomodel/w_ja032d"})
    public String viewJa032d(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032D");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032d");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > API 자료요청 현황";

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

        return "views/usportfoliomodel/w_ja032d";
    }

    /**
     * 1. 마스터 API 요청 현황 목록 조회 (d_ja032d1)
     */
    @GetMapping("/api/usportfoliomodel/ja032d/master-list")
    @ResponseBody
    public List<Ja032dMasterDto> getMasterList(@RequestParam(name = "ymd", required = false) String ymd) {
        try {
            return ja032dService.getMasterList(ymd);
        } catch (Exception e) {
            log.error("마스터 목록 조회 실패 ymd={}: {}", ymd, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 2. 상세 API 요청 건별 목록 조회 (d_ja032d2)
     */
    @GetMapping("/api/usportfoliomodel/ja032d/detail-list")
    @ResponseBody
    public List<Ja032dDetailDto> getDetailList(@RequestParam(name = "company") String company,
                                              @RequestParam(name = "url") String url,
                                              @RequestParam(name = "dt") String dt) {
        try {
            return ja032dService.getDetailList(company, url, dt);
        } catch (Exception e) {
            log.error("상세 건별 목록 조회 실패 company={}, url={}, dt={}: {}", company, url, dt, e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 3. API 처리상태 요약 조회 (d_ja032d3)
     */
    @GetMapping("/api/usportfoliomodel/ja032d/status")
    @ResponseBody
    public Ja032dStatusDto getStatus(@RequestParam(name = "apiKey") String apiKey) {
        try {
            return ja032dService.getStatus(apiKey);
        } catch (Exception e) {
            log.error("상태 요약 조회 실패 apiKey={}: {}", apiKey, e.getMessage(), e);
            return null;
        }
    }

    /**
     * 4. 테이블 컬럼 메타정보 및 실제 데이터 값 조회 (d_ja032d4)
     */
    @GetMapping("/api/usportfoliomodel/ja032d/column-data")
    @ResponseBody
    public Map<String, Object> getColumnDataList(@RequestParam(name = "tableName") String tableName,
                                                @RequestParam(name = "apiKey") String apiKey,
                                                @RequestParam(name = "pageIndex", required = false) Integer pageIndex) {
        try {
            return ja032dService.getColumnDataList(tableName, apiKey, pageIndex);
        } catch (Exception e) {
            log.error("컬럼 데이터 조회 실패 tableName={}, apiKey={}: {}", tableName, apiKey, e.getMessage(), e);
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("curRow", 0);
            errorMap.put("allRow", 0);
            errorMap.put("list", Collections.emptyList());
            return errorMap;
        }
    }

    /**
     * 5. 프로시저 실행: 한투파생시가 (SR_JA032D)
     */
    @PostMapping("/api/usportfoliomodel/ja032d/execute/cre")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> executeCre(@RequestParam(name = "corpGr") String corpGr,
                                                         @RequestParam(name = "ymd") String ymd) {
        Map<String, Object> response = new HashMap<>();
        try {
            String retMsg = ja032dService.executeSrJa032d(corpGr, ymd);
            response.put("success", true);
            response.put("message", (retMsg != null && !retMsg.isBlank()) ? retMsg + " 요청완료!" : "요청이 정상 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("한투파생시가 실행 실패 corpGr={}, ymd={}: {}", corpGr, ymd, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "실행 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 6. 프로시저 실행: 국내주식요청 (API_KSE)
     */
    @PostMapping("/api/usportfoliomodel/ja032d/execute/kse")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> executeKse(@RequestParam(name = "corpGr") String corpGr,
                                                         @RequestParam(name = "ymd") String ymd) {
        Map<String, Object> response = new HashMap<>();
        try {
            String retMsg = ja032dService.executeApiKse(corpGr, ymd);
            response.put("success", true);
            response.put("message", (retMsg != null && !retMsg.isBlank()) ? retMsg + " 요청완료!" : "국내주식 요청이 정상 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("국내주식요청 실행 실패 corpGr={}, ymd={}: {}", corpGr, ymd, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "실행 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 7. 프로시저 실행: 해외주식신규 (API_13_02)
     */
    @PostMapping("/api/usportfoliomodel/ja032d/execute/1302")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> execute1302(@RequestParam(name = "corpGr") String corpGr) {
        Map<String, Object> response = new HashMap<>();
        try {
            String retMsg = ja032dService.executeApi1302(corpGr);
            response.put("success", true);
            response.put("message", (retMsg != null && !retMsg.isBlank()) ? retMsg + " 요청완료!" : "해외주식신규 요청이 정상 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("해외주식신규 실행 실패 corpGr={}: {}", corpGr, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "실행 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 8. 프로시저 실행: 한투파생종가 (API_17_16)
     */
    @PostMapping("/api/usportfoliomodel/ja032d/execute/1716")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> execute1716(@RequestParam(name = "corpGr") String corpGr,
                                                         @RequestParam(name = "ymd") String ymd) {
        Map<String, Object> response = new HashMap<>();
        try {
            String retMsg = ja032dService.executeApi1716(corpGr, ymd);
            response.put("success", true);
            response.put("message", (retMsg != null && !retMsg.isBlank()) ? retMsg + " 요청완료!" : "한투파생종가 요청이 정상 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("한투파생종가 실행 실패 corpGr={}, ymd={}: {}", corpGr, ymd, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "실행 중 오류 발생: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 9. 프로시저 실행: 해외일괄재신청 (NEW_13_02)
     */
    @PostMapping("/api/usportfoliomodel/ja032d/execute/all")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> executeAll(@RequestParam(name = "corpGr") String corpGr,
                                                         @RequestParam(name = "ymd") String ymd) {
        Map<String, Object> response = new HashMap<>();
        try {
            String retMsg = ja032dService.executeNew1302(corpGr, ymd);
            response.put("success", true);
            response.put("message", (retMsg != null && !retMsg.isBlank()) ? retMsg + " 요청완료!" : "해외일괄재신청이 정상 완료되었습니다.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("해외일괄재신청 실행 실패 corpGr={}, ymd={}: {}", corpGr, ymd, e.getMessage(), e);
            response.put("success", false);
            response.put("message", "실행 중 오류 발생: " + e.getMessage());
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
