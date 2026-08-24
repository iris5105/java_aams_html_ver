package com.kfp.aams.domain.menu.controller;

import com.kfp.aams.domain.menu.dto.MenuDto;
import com.kfp.aams.domain.menu.service.MenuService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/menu")
@RequiredArgsConstructor
public class MenuController {

    private final MenuService menuService;

    /**
     * Get Header top menu list
     */
    @GetMapping("/top")
    public List<MenuDto> getTopMenu() {
        return menuService.getTopMenuList();
    }

    /**
     * Get Side navigation menu list for specified parent/top pgmNo
     */
    @GetMapping("/side")
    public List<MenuDto> getSideMenu(@RequestParam(name = "pgmNo", required = false) String pgmNo) {
        return menuService.getSideMenuList(pgmNo);
    }
}
