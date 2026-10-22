package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fMasterDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032fService;
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
 * W_JA032F 해외주식 종목정보 및 USPM 등록 관리 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032fController {

    private final Ja032fService ja032fService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032f", "/views/usportfoliomodel/w_ja032f"})
    public String viewJa032f(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                             Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032F");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032f");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > 해외주식 종목정보";

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

        return "views/usportfoliomodel/w_ja032f";
    }

    /**
     * 해외주식 마스터 및 USPM 등록 종목 목록 조회 (마스터)
     */
    @GetMapping("/api/usportfoliomodel/ja032f/master")
    @ResponseBody
    public List<Ja032fMasterDto> getMasterList(@RequestParam(name = "corpGr", required = false) String corpGr) {
        try {
            return ja032fService.getMasterList(corpGr);
        } catch (Exception e) {
            log.error("해외주식 마스터 목록 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 종목 일별 시세 내역 조회 (디테일)
     */
    @GetMapping("/api/usportfoliomodel/ja032f/detail")
    @ResponseBody
    public List<Ja032fDetailDto> getDetailList(@RequestParam(name = "corpGr") String corpGr,
                                               @RequestParam(name = "ymd") String ymd,
                                               @RequestParam(name = "jmCd") String jmCd) {
        try {
            return ja032fService.getDetailList(corpGr, ymd, jmCd);
        } catch (Exception e) {
            log.error("종목 일별 시세 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 마스터 종목 등록 및 수정 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/ja032f/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveMasterList(@RequestBody List<Ja032fMasterDto> list,
                                                              @RequestParam(name = "corpGr") String corpGr,
                                                              @RequestParam(name = "workDate", required = false) String workDate) {
        try {
            Map<String, Object> result = ja032fService.saveMasterList(list, corpGr, workDate);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("마스터 저장 오류: {}", e.getMessage(), e);
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(err);
        }
    }

    /**
     * 해외종목 파일(*.cod) 업로드 LOAD
     */
    @PostMapping("/api/usportfoliomodel/ja032f/load-cod")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> loadCodFile(@RequestParam("file") MultipartFile file) {
        try {
            Map<String, Object> result = ja032fService.loadCodFile(file);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("종목 파일 업로드 오류: {}", e.getMessage(), e);
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "파일 업로드 처리 중 오류 발생: " + e.getMessage());
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
