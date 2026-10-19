package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nJisuDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032nMasterDto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja032nService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 포트별 옵션수익실현현황 (W_JA032N) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja032nController {

    private final Ja032nService ja032nService;
    private final MenuService menuService;

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja032n", "/views/usportfoliomodel/w_ja032n"})
    public String viewJa032n(@AuthenticationPrincipal Object principalObj,
                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                             @RequestParam(name = "ymd", required = false) String paramYmd,
                             Model model) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA032N");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja032n");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 3519 포트별 옵션수익실현현황[ w_ja032n ]";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja032nService.getWorkDate(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja032n";
    }

    /**
     * 작업기준일 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja032n/workdate")
    @ResponseBody
    public Map<String, String> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = ja032nService.getWorkDate(corpGr);
        return Map.of("workDate", workDate != null ? workDate : "");
    }

    /**
     * 1. 좌측 마스터 펀드 목록 조회 API (d_ja032n1)
     */
    @GetMapping("/api/usportfoliomodel/ja032n/master")
    @ResponseBody
    public ResponseEntity<List<Ja032nMasterDto>> getMasterList(
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam(name = "ymd", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
            @AuthenticationPrincipal Object principalObj) {

        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : resolveCorpGr(null, principalObj);
        if (targetCorpGr == null || targetCorpGr.isBlank() || ymd == null) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja032nMasterDto> list = ja032nService.getMasterList(targetCorpGr, ymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 2. 우측 상단 지수 및 펀드 수익률 요약 조회 API (d_ja032n3 - F_JA032N)
     */
    @GetMapping("/api/usportfoliomodel/ja032n/jisu")
    @ResponseBody
    public ResponseEntity<Ja032nJisuDto> getJisuSummary(
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam(name = "ymd", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
            @RequestParam(name = "fundCd", required = false) String fundCd,
            @AuthenticationPrincipal Object principalObj) {

        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : resolveCorpGr(null, principalObj);
        if (targetCorpGr == null || targetCorpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank()) {
            return ResponseEntity.ok(new Ja032nJisuDto());
        }

        Ja032nJisuDto jisu = ja032nService.getJisuSummary(targetCorpGr, ymd, fundCd);
        return ResponseEntity.ok(jisu != null ? jisu : new Ja032nJisuDto());
    }

    /**
     * 3. 우측 하단 포트별 옵션수익실현 상세 목록 조회 API (d_ja032n2)
     */
    @GetMapping("/api/usportfoliomodel/ja032n/detail")
    @ResponseBody
    public ResponseEntity<List<Ja032nDetailDto>> getDetailList(
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam(name = "ymd", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate ymd,
            @RequestParam(name = "fundCd", required = false) String fundCd,
            @AuthenticationPrincipal Object principalObj) {

        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : resolveCorpGr(null, principalObj);
        if (targetCorpGr == null || targetCorpGr.isBlank() || ymd == null || fundCd == null || fundCd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja032nDetailDto> list = ja032nService.getDetailList(targetCorpGr, ymd, fundCd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    private String resolveCorpGr(String paramCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (principalObj instanceof UserPrincipal principal) {
            if (principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) {
                return principal.getCorpGr().trim();
            }
        }
        return "";
    }
}
