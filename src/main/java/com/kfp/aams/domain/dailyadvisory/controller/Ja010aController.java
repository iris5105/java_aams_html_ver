package com.kfp.aams.domain.dailyadvisory.controller;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010aDetailDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010aMasterDto;
import com.kfp.aams.domain.dailyadvisory.service.Ja010aService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010aController {

    private final Ja010aService ja010aService;
    private final com.kfp.aams.menu.service.MenuService menuService;

    @GetMapping({"/views/w_ja010a", "/views/dailyadvisory/w_ja010a"})
    public String viewJa010a(Model model) {
        model.addAttribute("masterList", ja010aService.getMasterList());

        var menuDto = menuService.getMenuByPgmId("w_ja010a");
        String fullpgm2 = (menuDto != null) ? menuDto.getFullpgm2() : "자분관리 > 일별작업 > 1001 회사 기본정보 관리";
        model.addAttribute("fullpgm2", fullpgm2);

        return "views/dailyadvisory/w_ja010a";
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

    @GetMapping("/api/company/ja010a/next-corp-gr")
    @ResponseBody
    public java.util.Map<String, String> getNextCorpGr() {
        return java.util.Map.of("nextCorpGr", ja010aService.getNextCorpGr());
    }

    @org.springframework.web.bind.annotation.PostMapping("/api/company/ja010a/save")
    @ResponseBody
    public java.util.Map<String, Object> saveJa010a(@org.springframework.web.bind.annotation.RequestBody com.kfp.aams.domain.dailyadvisory.dto.Ja010aSaveRequestDto request) {
        try {
            ja010aService.saveJa010a(request);
            return java.util.Map.of("success", true, "message", "정상적으로 저장되었습니다.");
        } catch (Exception e) {
            log.error("w_ja010a 저장 중 오류 발생: {}", e.getMessage(), e);
            return java.util.Map.of("success", false, "message", "저장 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
