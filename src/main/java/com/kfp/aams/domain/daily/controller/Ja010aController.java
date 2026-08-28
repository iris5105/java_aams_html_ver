package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010aDetailDto;
import com.kfp.aams.domain.daily.dto.Ja010aMasterDto;
import com.kfp.aams.domain.daily.service.Ja010aService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class Ja010aController {

    private final Ja010aService ja010aService;
    private final com.kfp.aams.domain.menu.service.MenuService menuService;

    @GetMapping({"/views/w_ja010a", "/views/daily/w_ja010a"})
    public String viewJa010a(Model model) {
        model.addAttribute("masterList", ja010aService.getMasterList());

        var menuDto = menuService.getMenuByPgmId("w_ja010a");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "자분관리 > 일별작업 > 1001 회사 기본정보 관리";
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/daily/w_ja010a";
    }

    @GetMapping("/api/company/ja010a/master")
    @ResponseBody
    public List<Ja010aMasterDto> getMasterList() {
        return ja010aService.getMasterList();
    }

    @GetMapping("/api/company/ja010a/detail")
    @ResponseBody
    public List<Ja010aDetailDto> getDetailList(@RequestParam(name = "corpGr") String corpGr) {
        return ja010aService.getDetailList(corpGr);
    }
}
