package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.ProposalCommentDto;
import com.kfp.aams.domain.daily.dto.ProposalMasterDto;
import com.kfp.aams.domain.daily.service.ProposalService;
import com.kfp.aams.domain.menu.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ProposalController {

    private final ProposalService proposalService;
    private final MenuService menuService;

    @GetMapping({"/views/w_proposal", "/views/daily/w_proposal"})
    public String viewProposal(@RequestParam(name = "corpGr", required = false) String corpGr, Model model) {
        if (corpGr == null || corpGr.trim().isEmpty()) {
            corpGr = "2200";
        }
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("masterList", proposalService.getProposalMasterList(corpGr));

        var menuDto = menuService.getMenuByPgmId("w_proposal");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "시스템관리 > 시스템 > 건의사항/개선요청 관리";
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/daily/w_proposal";
    }

    @GetMapping("/api/proposal/master")
    @ResponseBody
    public List<ProposalMasterDto> getMasterList(@RequestParam(name = "corpGr", required = false) String corpGr) {
        return proposalService.getProposalMasterList(corpGr);
    }

    @GetMapping("/api/proposal/comment")
    @ResponseBody
    public List<ProposalCommentDto> getCommentList(@RequestParam(name = "corpGr") String corpGr,
                                                   @RequestParam(name = "ymd", required = false) String ymd,
                                                   @RequestParam(name = "proposer", required = false) String proposer) {
        return proposalService.getProposalCommentList(corpGr, ymd, proposer);
    }
}
