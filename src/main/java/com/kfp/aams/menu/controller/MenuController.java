package com.kfp.aams.menu.controller;

import com.kfp.aams.menu.dto.MenuDto;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

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
    public List<MenuDto> getTopMenu(@AuthenticationPrincipal UserPrincipal principal) {
        validatePrincipal(principal);
        return menuService.getTopMenuList(principal.getUserId(), principal.getUserNm());
    }

    /**
     * Get Side navigation menu list for specified parent/top pgmNo
     */
    @GetMapping("/side")
    public List<MenuDto> getSideMenu(@RequestParam(name = "pgmNo", required = false) String pgmNo,
                                     @AuthenticationPrincipal UserPrincipal principal) {
        validatePrincipal(principal);
        return menuService.getSideMenuList(pgmNo, principal.getUserId(), principal.getUserNm());
    }

    /**
     * Get all menu items for global search
     */
    @GetMapping("/all")
    public List<MenuDto> getAllMenu(@AuthenticationPrincipal UserPrincipal principal) {
        validatePrincipal(principal);
        return menuService.getAllMenuList(principal.getUserId(), principal.getUserNm());
    }

    /**
     * 비정상 접근 및 미인증 사용자 차단
     */
    private void validatePrincipal(UserPrincipal principal) {
        if (principal == null || principal.getUserId() == null || principal.getUserId().isBlank()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "인증되지 않은 접근입니다.");
        }
    }
}
