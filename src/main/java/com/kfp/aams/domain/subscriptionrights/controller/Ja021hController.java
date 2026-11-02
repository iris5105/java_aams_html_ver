package com.kfp.aams.domain.subscriptionrights.controller;
import com.kfp.aams.common.service.WorkDateService; import com.kfp.aams.domain.subscriptionrights.dto.*; import com.kfp.aams.domain.subscriptionrights.service.Ja021hService; import com.kfp.aams.menu.service.MenuService; import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor; import org.springframework.security.core.annotation.AuthenticationPrincipal; import org.springframework.stereotype.Controller; import org.springframework.ui.Model; import org.springframework.web.bind.annotation.*; import org.springframework.web.server.ResponseStatusException; import org.springframework.http.HttpStatus; import java.time.LocalDate; import java.util.List;
@Controller @RequiredArgsConstructor public class Ja021hController {
 private final WorkDateService dates; private final MenuService menus; private final Ja021hService service;
 @GetMapping({"/views/w_ja021h","/views/subscriptionrights/w_ja021h"}) public String view(@AuthenticationPrincipal UserPrincipal p,@RequestParam(required=false) String corpGr,@CookieValue(name="savedCorpGr",required=false) String saved,Model m){String c=company(p,corpGr,saved);String d=dates.getWorkDateOrDefault(c);var menu=menus.getMenuByPgmId("W_JA021H");if(menu==null)menu=menus.getMenuByPgmId("w_ja021h");m.addAttribute("corpGr",c);m.addAttribute("workDate",d);m.addAttribute("initialYmd",d);m.addAttribute("ymd",d);m.addAttribute("fullpgm2",menu==null?"":menu.getFullpgm2());return "views/subscriptionrights/w_ja021h";}
 @GetMapping("/api/subscriptionrights/ja021h/data") @ResponseBody public List<Ja021hMasterDto> data(@AuthenticationPrincipal UserPrincipal p,@RequestParam(required=false) String corpGr,@CookieValue(name="savedCorpGr",required=false) String saved,@RequestParam String tab){String c=company(p,corpGr,saved);return service.master(tab,LocalDate.parse(dates.getWorkDateOrDefault(c)));}
 @GetMapping("/api/subscriptionrights/ja021h/detail") @ResponseBody public List<Ja021hDetailDto> detail(@AuthenticationPrincipal UserPrincipal p,@RequestParam String jmCd,@RequestParam String ymd){
  requireUser(p);
  String corpGr=isAdmin(p)?"%":p.getCorpGr();
  String workDate=dates.getWorkDateOrDefault(p.getCorpGr()).replace("-","");
  String issueDate=ymd.replace("-","");
  String queryYmd=issueDate.compareTo(workDate)>0?workDate:issueDate;
  return service.detail(corpGr,jmCd,queryYmd);
 }
 private boolean isAdmin(UserPrincipal p){return p!=null&&"Y".equalsIgnoreCase(p.getAdminYn());}
 private void requireUser(UserPrincipal p){if(p==null)throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,"로그인이 필요합니다.");}
 private String company(UserPrincipal p,String r,String s){requireUser(p);if(isAdmin(p))return r!=null&&!r.isBlank()?r:s!=null&&!s.isBlank()?s:p.getCorpGr();return p.getCorpGr();}
}
