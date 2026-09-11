package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.Ja010nDto;
import com.kfp.aams.domain.daily.dto.Ja010nSaveDto;
import com.kfp.aams.domain.daily.service.Ja010nService;
import com.kfp.aams.domain.menu.service.MenuService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class Ja010nController {

    private final Ja010nService ja010nService;
    private final MenuService menuService;

    @GetMapping({"/views/w_ja010n", "/views/daily/w_ja010n"})
    public String viewJa010n(Model model) {
        var menuDto = menuService.getMenuByPgmId("W_JA010N");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_ja010n");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > 자문일일 > 일일작업";

        model.addAttribute("fullpgm2", fullpgm2);

        return "views/daily/w_ja010n";
    }

    @GetMapping("/api/daily/ja010n/list")
    @ResponseBody
    public ResponseEntity<List<Ja010nDto>> getJa010nList() {
        List<Ja010nDto> list = ja010nService.getJa010nList();
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/ja010n/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveJa010n(@RequestBody Ja010nSaveDto saveDto) {
        try {
            ja010nService.saveJa010n(saveDto);
            return ResponseEntity.ok(Map.of("success", true, "message", "저장이 완료되었습니다."));
        } catch (Exception e) {
            log.error("Error saving ja010n:", e);
            return ResponseEntity.internalServerError().body(Map.of("success", false, "message", "저장 중 오류가 발생했습니다: " + e.getMessage()));
        }
    }
}
