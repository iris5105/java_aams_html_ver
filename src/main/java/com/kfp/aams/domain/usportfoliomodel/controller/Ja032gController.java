package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032gDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032gMasterDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032gService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
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
 * W_JA032G 해외 파생종목정보 관리 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032gController {

    private final Ja032gService ja032gService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032g", "/views/usportfoliomodel/w_ja032g"})
    public String viewJa032g(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032G");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032g");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > 해외 파생종목정보";

        // DB 영업일자 (SZX0AA.HYUN_YMD) 연동 (규정 01-3 Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032g";
    }

    /**
     * 해외 파생종목 마스터 목록 조회
     */
    @GetMapping("/api/usportfoliomodel/ja032g/master")
    @ResponseBody
    public List<Ja032gMasterDto> getMasterList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "lsyYmd", required = false) String lsyYmd) {
        try {
            return ja032gService.getMasterList(corpGr, lsyYmd);
        } catch (Exception e) {
            log.error("해외 파생종목 마스터 조회 오류: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 해외옵션 일별 시세 내역 조회
     */
    @GetMapping("/api/usportfoliomodel/ja032g/detail")
    @ResponseBody
    public List<Ja032gDetailDto> getDetailList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "ymd") String ymd,
                                               @RequestParam(name = "jmCd") String jmCd) {
        try {
            return ja032gService.getDetailList(corpGr, ymd, jmCd);
        } catch (Exception e) {
            log.error("해외옵션 일별 시세 조회 오류: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 마스터 파생종목 CUD 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/ja032g/save-master")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveMasterList(@RequestBody List<Ja032gMasterDto> list,
                                                              @RequestParam(name = "corpGr") String corpGr) {
        try {
            Map<String, Object> result = ja032gService.saveMasterList(list, corpGr);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("마스터 저장 실패: {}", e.getMessage(), e);
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(err);
        }
    }

    /**
     * 디테일 일별 시세 CUD 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/ja032g/save-detail")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveDetailList(@RequestBody List<Ja032gDetailDto> list,
                                                              @RequestParam(name = "corpGr") String corpGr,
                                                              @RequestParam(name = "jmCd") String jmCd) {
        try {
            Map<String, Object> result = ja032gService.saveDetailList(list, corpGr, jmCd);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("디테일 저장 실패: {}", e.getMessage(), e);
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "일별 시세 저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(err);
        }
    }

    /**
     * 종목코드 수기 입력 시 국가/통화 자동 연동 조회
     */
    @GetMapping("/api/usportfoliomodel/ja032g/code-info")
    @ResponseBody
    public Map<String, String> getCodeInfo(@RequestParam(name = "stockGb", required = false) String stockGb,
                                           @RequestParam(name = "balhNation", required = false) String balhNation,
                                           @RequestParam(name = "currency", required = false) String currency) {
        return ja032gService.getCodeInfo(stockGb, balhNation, currency);
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
