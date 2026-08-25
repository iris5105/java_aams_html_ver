package com.kfp.aams.domain.account.controller;

import com.kfp.aams.domain.account.dto.Ja010bDetailDto;
import com.kfp.aams.domain.account.dto.Ja010bIoDto;
import com.kfp.aams.domain.account.dto.Ja010bMasterDto;
import com.kfp.aams.domain.account.service.Ja010bService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class Ja010bController {

    private final Ja010bService ja010bService;
    private final com.kfp.aams.domain.menu.service.MenuService menuService;

    @GetMapping("/views/w_ja010b")
    public String viewJa010b(@AuthenticationPrincipal UserPrincipal principal,
                            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                            Model model) {
        String corpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr : (principal != null ? principal.getCorpGr() : "2200");
        String adminYn = (principal != null && principal.getAdminYn() != null) ? principal.getAdminYn() : "N";

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("adminYn", adminYn);
        model.addAttribute("masterList", ja010bService.getMasterList(corpGr));

        var menuDto = menuService.getMenuByPgmId("w_ja010b");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : null;
        model.addAttribute("fullpgm2", formatBreadcrumb(fullpgm2, "1011 계좌계약정보관리", "w_ja010b"));

        return "views/w_ja010b";
    }

    private String formatBreadcrumb(String fullpgm2, String title, String pgmId) {
        String base = (fullpgm2 != null && !fullpgm2.isBlank()) ? fullpgm2.trim() : "";
        String menuName = (title != null && !title.isBlank()) ? title.trim() : "";
        String pId = (pgmId != null && !pgmId.isBlank()) ? pgmId.trim() : "";

        if (base.isEmpty()) {
            return menuName.isEmpty() ? "[" + pId + "]" : menuName + " [" + pId + "]";
        }
        if (!menuName.isEmpty() && !base.endsWith(menuName)) {
            base += " > " + menuName;
        }
        if (!pId.isEmpty() && !base.endsWith("[" + pId + "]")) {
            base += " [" + pId + "]";
        }
        return base;
    }

    @GetMapping("/api/account/ja010b/master")
    @ResponseBody
    public List<Ja010bMasterDto> getMasterList(@AuthenticationPrincipal UserPrincipal principal,
                                                @RequestParam(name = "corpGr", required = false) String paramCorpGr) {
        String corpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr : (principal != null ? principal.getCorpGr() : "2200");
        return ja010bService.getMasterList(corpGr);
    }

    @GetMapping("/api/account/ja010b/detail")
    @ResponseBody
    public List<Ja010bDetailDto> getDetailList(@AuthenticationPrincipal UserPrincipal principal,
                                                @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                @RequestParam(name = "fundCd") String fundCd) {
        String corpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr : (principal != null ? principal.getCorpGr() : "2200");
        return ja010bService.getDetailList(corpGr, fundCd);
    }

    @GetMapping("/api/account/ja010b/io")
    @ResponseBody
    public List<Ja010bIoDto> getIoList(@AuthenticationPrincipal UserPrincipal principal,
                                        @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                        @RequestParam(name = "fundCd") String fundCd) {
        String corpGr = (paramCorpGr != null && !paramCorpGr.isBlank()) ? paramCorpGr : (principal != null ? principal.getCorpGr() : "2200");
        return ja010bService.getIoList(corpGr, fundCd);
    }
}
