package com.kfp.aams.domain.subscriptionrights.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.subscriptionrights.dto.*;
import com.kfp.aams.domain.subscriptionrights.service.Ja021eService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
public class Ja021eController {
    private final Ja021eService service;
    private final WorkDateService workDates;
    private final MenuService menus;
    public Ja021eController(Ja021eService service,WorkDateService workDates,MenuService menus) {
        this.service=service; this.workDates=workDates; this.menus=menus;
    }

    @GetMapping({"/views/w_ja021e","/views/subscriptionrights/w_ja021e"})
    public String view(@AuthenticationPrincipal UserPrincipal principal,
                       @RequestParam(name="corpGr",required=false) String paramCorpGr,
                       @RequestParam(name="ymd",required=false) String paramYmd,
                       @CookieValue(name="savedCorpGr",required=false) String savedCorpGr,
                       @CookieValue(name="corpGr",required=false) String cookieCorpGr, Model model) {
        String corp=company(principal,paramCorpGr,savedCorpGr,cookieCorpGr);
        String workDate=workDates.getWorkDateOrDefault(corp);
        String initial=paramYmd!=null && !paramYmd.isBlank() ? paramYmd : workDate;
        var menu=menus.getMenuByPgmId("W_JA021E");
        if (menu==null) menu=menus.getMenuByPgmId("w_ja021e");
        model.addAttribute("corpGr",corp); model.addAttribute("workDate",workDate);
        model.addAttribute("initialYmd",initial); model.addAttribute("ymd",initial);
        model.addAttribute("fullpgm2",menu!=null ? menu.getFullpgm2() : "");
        return "views/subscriptionrights/w_ja021e";
    }

    @GetMapping("/api/subscriptionrights/ja021e/data")
    @ResponseBody
    public Ja021eDataDto data(@ModelAttribute Ja021eFilterDto filter,
                              @AuthenticationPrincipal UserPrincipal principal,
                              @CookieValue(name="savedCorpGr",required=false) String savedCorpGr,
                              @CookieValue(name="corpGr",required=false) String cookieCorpGr) {
        filter.setCorpGr(company(principal,filter.getCorpGr(),savedCorpGr,cookieCorpGr));
        return service.query(filter);
    }

    @GetMapping("/api/subscriptionrights/ja021e/dates")
    @ResponseBody
    public List<LocalDate> dates(@RequestParam(name="trCd") String trCd,
                                 @RequestParam(name="corpGr",required=false) String corpGr,
                                 @AuthenticationPrincipal UserPrincipal principal,
                                 @CookieValue(name="savedCorpGr",required=false) String savedCorpGr,
                                 @CookieValue(name="corpGr",required=false) String cookieCorpGr) {
        return service.dates(company(principal,corpGr,savedCorpGr,cookieCorpGr),trCd);
    }

    @PostMapping("/api/subscriptionrights/ja021e/save")
    @ResponseBody
    public Map<String,Object> save(@RequestBody Ja021eSaveDto request,
                                   @AuthenticationPrincipal UserPrincipal principal,
                                   @CookieValue(name="savedCorpGr",required=false) String savedCorpGr,
                                   @CookieValue(name="corpGr",required=false) String cookieCorpGr) {
        if (request==null || request.getFilter()==null) throw new IllegalArgumentException("조회 조건이 없습니다.");
        request.getFilter().setCorpGr(company(principal,request.getFilter().getCorpGr(),savedCorpGr,cookieCorpGr));
        int count=service.save(request);
        return Map.of("success",true,"count",count,"message","정상적으로 저장되었습니다.");
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseBody
    public ResponseEntity<Map<String,Object>> invalid(IllegalArgumentException exception) {
        return ResponseEntity.badRequest().body(Map.of("success",false,"message",exception.getMessage()));
    }

    private String company(UserPrincipal principal,String requested,String saved,String cookie) {
        if (principal==null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        if (!"Y".equalsIgnoreCase(principal.getAdminYn())) {
            String corp=principal.getCorpGr()!=null ? principal.getCorpGr().trim() : null;
            if (requested!=null && !requested.isBlank() && !requested.trim().equals(corp))
                throw new ResponseStatusException(HttpStatus.FORBIDDEN);
            if (corp==null || corp.isBlank()) throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"회사그룹이 없습니다.");
            return corp.trim();
        }
        for (String value:new String[]{requested,saved,cookie,principal.getCorpGr()})
            if (value!=null && !value.isBlank()) return value.trim();
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST,"회사그룹이 없습니다.");
    }
}
