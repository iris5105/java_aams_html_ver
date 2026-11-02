package com.kfp.aams.domain.assetmanagement.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.assetmanagement.dto.*;
import com.kfp.aams.domain.assetmanagement.service.Ja030dService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import java.time.LocalDate; import java.util.*;

@Controller @RequiredArgsConstructor
public class Ja030dController {
    private final Ja030dService service; private final WorkDateService workDateService; private final MenuService menuService;
    @GetMapping({"/views/w_ja030d","/views/assetmanagement/w_ja030d"}) public String view(@AuthenticationPrincipal UserPrincipal p,@RequestParam(required=false) String corpGr,@CookieValue(name="savedCorpGr",required=false) String saved,Model m){String c=corp(p,corpGr,saved);var menu=menuService.getMenuByPgmId("W_JA030D");m.addAttribute("corpGr",c);m.addAttribute("ymd",workDateService.getWorkDateOrDefault(c));m.addAttribute("fullpgm2",menu==null?"":menu.getFullpgm2());return "views/assetmanagement/w_ja030d";}
    @GetMapping("/api/assetmanagement/ja030d/list") @ResponseBody public List<Ja030dDto> list(@AuthenticationPrincipal UserPrincipal p,@RequestParam(required=false) String corpGr,@CookieValue(name="savedCorpGr",required=false) String saved,@RequestParam @DateTimeFormat(pattern="yyyy-MM-dd",fallbackPatterns={"yyyyMMdd","yyyy.MM.dd"}) LocalDate ymd,@RequestParam String trCd){return service.list(corp(p,corpGr,saved),ymd,trCd);}
    @PostMapping("/api/assetmanagement/ja030d/save") @ResponseBody public Map<String,Object> save(@AuthenticationPrincipal UserPrincipal p,@RequestParam(required=false) String corpGr,@CookieValue(name="savedCorpGr",required=false) String saved,@RequestBody Ja030dSaveRequest r){String c=corp(p,corpGr,saved);if(!"Y".equalsIgnoreCase(p.getAdminYn())&&r!=null&&r.getYmd()!=null&&r.getYmd().isBefore(LocalDate.parse(workDateService.getWorkDateOrDefault(c))))throw new ResponseStatusException(HttpStatus.FORBIDDEN,"기준일 이전 거래는 수정할 수 없습니다.");return Map.of("success",true,"count",service.save(c,r),"message","저장되었습니다.");}
    private String corp(UserPrincipal p,String requested,String saved){if(p==null)throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,"로그인이 필요합니다.");if("Y".equalsIgnoreCase(p.getAdminYn())){if(requested!=null&&!requested.isBlank())return requested;if(saved!=null&&!saved.isBlank())return saved;}return p.getCorpGr();}
}
