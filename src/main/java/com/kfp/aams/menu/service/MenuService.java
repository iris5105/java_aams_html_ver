package com.kfp.aams.menu.service;

import com.kfp.aams.menu.dto.MenuDto;
import com.kfp.aams.menu.mapper.MenuMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@Service
@Transactional(readOnly = true)
public class MenuService {

    private final MenuMapper menuMapper;

    public MenuService(MenuMapper menuMapper) {
        this.menuMapper = menuMapper;
    }

    /**
     * Header top menu list
     */
    public List<MenuDto> getTopMenuList(String userId, String userNm) {
        if (menuMapper == null) {
            log.warn("[MenuService] menuMapper is null");
            return java.util.Collections.emptyList();
        }
        return menuMapper.selectTopMenuList(userId, userNm);
    }

    /**
     * Side navigation menu list for a given header pgmNo
     */
    public List<MenuDto> getSideMenuList(String pgmNo, String userId, String userNm) {
        if (menuMapper == null) return java.util.Collections.emptyList();
        if (pgmNo == null || pgmNo.isBlank()) {
            List<MenuDto> topList = getTopMenuList(userId, userNm);
            if (!topList.isEmpty()) {
                pgmNo = topList.get(0).getPgmNo();
            } else {
                pgmNo = "00804";
            }
        }
        return menuMapper.selectSideMenuList(pgmNo, userId, userNm);
    }

    /**
     * Get menu DTO by PGM_ID to fetch FULLPGM2
     */
    public MenuDto getMenuByPgmId(String pgmId) {
        if (menuMapper == null || pgmId == null || pgmId.isBlank())
            return null;
        return menuMapper.selectMenuByPgmId(pgmId);
    }

    /**
     * Get all menu items for global sidebar search
     */
    public List<MenuDto> getAllMenuList(String userId, String userNm) {
        if (menuMapper == null) return java.util.Collections.emptyList();
        return menuMapper.selectAllMenuList(userId, userNm);
    }

    /**
     * Get permitted program identifier set (PGM_ID, PGM_GO, PGM_NO) for access control
     */
    public Set<String> getPermittedPgmSet(String userId, String userNm) {
        Set<String> permittedSet = new HashSet<>();
        if (menuMapper == null) {
            log.warn("[MenuService] menuMapper is null in getPermittedPgmSet");
            return permittedSet;
        }
        List<MenuDto> permittedList = menuMapper.selectPermittedPgmList(userId, userNm);
        if (permittedList != null) {
            for (MenuDto menu : permittedList) {
                if (menu.getPgmId() != null && !menu.getPgmId().isBlank()) {
                    permittedSet.add(menu.getPgmId().trim().toUpperCase());
                }
                if (menu.getPgmGo() != null && !menu.getPgmGo().isBlank()) {
                    permittedSet.add(menu.getPgmGo().trim().toUpperCase());
                }
                if (menu.getPgmNo() != null && !menu.getPgmNo().isBlank()) {
                    permittedSet.add(menu.getPgmNo().trim().toUpperCase());
                }
            }
        }
        return permittedSet;
    }
}
