package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.ProposalCommentDto;
import com.kfp.aams.domain.daily.dto.ProposalMasterDto;
import com.kfp.aams.domain.daily.service.ProposalService;
import com.kfp.aams.domain.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ProposalController {

    private final ProposalService proposalService;
    private final MenuService menuService;
    private final com.kfp.aams.domain.common.service.DddwService dddwService;

    @GetMapping({"/views/w_proposal", "/views/daily/w_proposal"})
    public String viewProposal(@AuthenticationPrincipal UserPrincipal principal,
                               @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                               @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                               @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                               Model model,
                               jakarta.servlet.http.HttpSession session) {
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr1, cookieCorpGr2, principal);
        String adminYn = (principal != null && principal.getAdminYn() != null) ? principal.getAdminYn() : "N";

        String addWhere = null;
        if (!"Y".equalsIgnoreCase(adminYn)) {
            addWhere = "corp_gr = '" + corpGr + "'";
        }

        var corpList = dddwService.getDddwList("CORP_GR", 1, addWhere, null, session);

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("adminYn", adminYn);
        model.addAttribute("corpList", corpList);
        model.addAttribute("masterList", proposalService.getProposalMasterList(corpGr));

        var menuDto = menuService.getMenuByPgmId("w_proposal");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "시스템관리 > System > 건의사항/개선요청 관리";
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/daily/w_proposal";
    }

    @GetMapping("/api/proposal/master")
    @ResponseBody
    public List<ProposalMasterDto> getMasterList(@AuthenticationPrincipal UserPrincipal principal,
                                                 @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                 @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                                 @CookieValue(name = "corpGr", required = false) String cookieCorpGr2) {
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr1, cookieCorpGr2, principal);
        return proposalService.getProposalMasterList(corpGr);
    }

    @GetMapping("/api/proposal/comment")
    @ResponseBody
    public List<ProposalCommentDto> getCommentList(@AuthenticationPrincipal UserPrincipal principal,
                                                   @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                                   @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                                   @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                                   @RequestParam(name = "ymd", required = false) String ymd,
                                                   @RequestParam(name = "proposer", required = false) String proposer) {
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr1, cookieCorpGr2, principal);
        return proposalService.getProposalCommentList(corpGr, ymd, proposer);
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr1, String cookieCorpGr2, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr;
        if (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) return cookieCorpGr1;
        if (cookieCorpGr2 != null && !cookieCorpGr2.isBlank()) return cookieCorpGr2;
        if (principal != null && principal.getCorpGr() != null && !principal.getCorpGr().isBlank()) return principal.getCorpGr();
        return "";
    }
}
