package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja035b2Dto;
import com.kfp.aams.domain.usportfoliomodel.service.Ja035b2Service;
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
import java.util.List;
import java.util.Map;

/**
 * 해외 파생 PORT 매매관리 (W_JA035B2) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja035b2Controller {

    private final Ja035b2Service ja035b2Service;
    private final MenuService menuService;

    /**
     * 뷰 렌더링
     */
    @GetMapping({"/views/w_ja035b2", "/views/usportfoliomodel/w_ja035b2"})
    public String viewJa035b2(@AuthenticationPrincipal Object principalObj,
                              @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                              @RequestParam(name = "ymd", required = false) String paramYmd,
                              Model model) {
        String corpGr = resolveCorpGr(paramCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_JA035B2");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja035b2");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > USPM > 3520 해외 파생 PORT 매매관리[ w_ja035b2 ]";

        String workDate = (paramYmd != null && !paramYmd.isBlank()) ? paramYmd : ja035b2Service.getWorkDate(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_ja035b2";
    }

    /**
     * 작업기준일 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja035b2/workdate")
    @ResponseBody
    public Map<String, String> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr,
                                           @AuthenticationPrincipal Object principalObj) {
        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : resolveCorpGr(null, principalObj);
        String workDate = ja035b2Service.getWorkDate(targetCorpGr);
        return Map.of("workDate", workDate != null ? workDate : "");
    }

    /**
     * 해외파생 매매내역 목록 조회 API (d_ja035b2)
     */
    @GetMapping("/api/usportfoliomodel/ja035b2/list")
    @ResponseBody
    public ResponseEntity<List<Ja035b2Dto>> getList(
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam(name = "ymd", required = false) String ymd,
            @AuthenticationPrincipal Object principalObj) {

        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : resolveCorpGr(null, principalObj);
        if (targetCorpGr == null || targetCorpGr.isBlank() || ymd == null || ymd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyList());
        }

        List<Ja035b2Dto> list = ja035b2Service.getList(targetCorpGr, ymd);
        return ResponseEntity.ok(list != null ? list : Collections.emptyList());
    }

    /**
     * 종목 정보 단건 조회 API
     */
    @GetMapping("/api/usportfoliomodel/ja035b2/item-info")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getItemInfo(
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam(name = "jmCd", required = false) String jmCd,
            @AuthenticationPrincipal Object principalObj) {

        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : resolveCorpGr(null, principalObj);
        if (targetCorpGr == null || targetCorpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            return ResponseEntity.ok(Collections.emptyMap());
        }

        Map<String, Object> info = ja035b2Service.getItemInfo(targetCorpGr, jmCd);
        return ResponseEntity.ok(info != null ? info : Collections.emptyMap());
    }

    /**
     * 일괄 CUD 저장 API
     */
    @PostMapping("/api/usportfoliomodel/ja035b2/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveList(
            @RequestParam(name = "corpGr", required = false) String corpGr,
            @RequestParam(name = "ymd", required = false) String ymd,
            @RequestBody List<Ja035b2Dto> list,
            @AuthenticationPrincipal Object principalObj) {

        String targetCorpGr = (corpGr != null && !corpGr.isBlank()) ? corpGr : resolveCorpGr(null, principalObj);
        String userId = resolveUserId(principalObj);

        Map<String, Object> result = ja035b2Service.saveList(targetCorpGr, ymd, list, userId);
        return ResponseEntity.ok(result);
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

    private String resolveUserId(Object principalObj) {
        if (principalObj instanceof UserPrincipal principal) {
            if (principal.getUsername() != null && !principal.getUsername().isBlank()) {
                return principal.getUsername().trim();
            }
        }
        return "system";
    }
}
