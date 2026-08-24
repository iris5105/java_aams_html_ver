package com.kfp.aams.domain.home.controller;

import com.kfp.aams.domain.auth.dto.*;
import com.kfp.aams.domain.home.dto.*;
import com.kfp.aams.domain.menu.dto.*;
import com.kfp.aams.security.UserPrincipal;
import com.kfp.aams.domain.home.service.HomeService;
import com.kfp.aams.domain.menu.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class HomeController {

    private final HomeService homeService;
    private final MenuService menuService;

    @GetMapping({ "/", "/home", "/w_home5" })
    public String homePage(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            Model model) {

        if (principal == null || principal.getUserId() == null) {
            return "redirect:/login";
        }

        String corpGr = resolveCorpGr(principal, paramCorpGr);
        String userId = resolveUserId(principal);
        String userNm = resolveUserNm(principal);
        String lastConnect = principal.getLastConnect();

        String today = java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

        List<MenuDto> topMenuList = menuService.getTopMenuList();
        String activePgmNo = (topMenuList != null && !topMenuList.isEmpty()) ? topMenuList.get(0).getPgmNo() : "01000";
        List<MenuDto> sideMenuList = menuService.getSideMenuList(activePgmNo);

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("companyName", principal.getCompanyName());
        model.addAttribute("userNm", userNm);
        model.addAttribute("userId", userId);
        model.addAttribute("adminYn", principal.getAdminYn() != null ? principal.getAdminYn() : "N");
        model.addAttribute("lastConnect", lastConnect);
        model.addAttribute("today", today);
        model.addAttribute("topMenuList", topMenuList);
        model.addAttribute("sideMenuList", sideMenuList);
        model.addAttribute("activePgmNo", activePgmNo);
        model.addAttribute("publicStockList", homeService.getPublicStockList(corpGr));
        model.addAttribute("dayTrList", homeService.getDayTrList(corpGr));
        model.addAttribute("gyulList", homeService.getGyulAccountList(corpGr));
        model.addAttribute("noticeList", homeService.getNoticeList(userId));
        return "w_home5";
    }

    @GetMapping("/api/home/companies")
    @ResponseBody
    public List<CompanyDto> getCompanies() {
        return homeService.getCompanyList();
    }

    @GetMapping("/api/home/day-tr")
    @ResponseBody
    public List<DayTrDto> getDayTr(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr) {
        return homeService.getDayTrList(resolveCorpGr(principal, paramCorpGr));
    }

    @GetMapping("/api/home/gyul-accounts")
    @ResponseBody
    public List<GyulAccountDto> getGyulAccounts(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr) {
        return homeService.getGyulAccountList(resolveCorpGr(principal, paramCorpGr));
    }

    @GetMapping("/api/home/rate-changes")
    @ResponseBody
    public List<RateChangeDto> getRateChanges(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr) {
        return homeService.getRateChangeList(resolveCorpGr(principal, paramCorpGr));
    }

    @GetMapping("/api/home/public-stocks")
    @ResponseBody
    public List<PublicStockDto> getPublicStocks(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr) {
        return homeService.getPublicStockList(resolveCorpGr(principal, paramCorpGr));
    }

    @GetMapping("/api/home/subscriptions")
    @ResponseBody
    public List<SubscriptionDto> getSubscriptions(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr) {
        return homeService.getSubscriptionList(resolveCorpGr(principal, paramCorpGr));
    }

    @GetMapping("/api/home/proposals")
    @ResponseBody
    public List<ProposalDto> getProposals(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr) {
        return homeService.getProposalList(resolveCorpGr(principal, paramCorpGr));
    }

    @GetMapping("/api/home/notices")
    @ResponseBody
    public List<NoticeDto> getNotices(@AuthenticationPrincipal UserPrincipal principal) {
        return homeService.getNoticeList(resolveUserId(principal));
    }

    @GetMapping("/api/home/chart-data")
    @ResponseBody
    public List<ChtDataDto> getChartData(@AuthenticationPrincipal UserPrincipal principal,
            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
            @RequestParam(name = "ymd", required = false) String ymd) {
        return homeService.getChtDataList(resolveCorpGr(principal, paramCorpGr), ymd);
    }

    private String resolveCorpGr(UserPrincipal principal, String paramCorpGr) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (principal != null) {
            return principal.getCorpGr();
        }
        return null;
    }

    private String resolveUserId(UserPrincipal principal) {
        if (principal != null && principal.getUserId() != null) {
            return principal.getUserId();
        }
        return "ADMIN";
    }

    private String resolveUserNm(UserPrincipal principal) {
        if (principal != null && principal.getUserNm() != null) {
            return principal.getUserNm();
        }
        return null;
    }
}
