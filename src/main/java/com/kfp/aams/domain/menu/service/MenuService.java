package com.kfp.aams.domain.menu.service;

import com.kfp.aams.domain.menu.dto.MenuDto;
import com.kfp.aams.domain.menu.mapper.MenuMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MenuService {

    private final MenuMapper menuMapper;

    /**
     * Header top menu list
     */
    public List<MenuDto> getTopMenuList() {
        return menuMapper.selectTopMenuList();
    }

    /**
     * Side navigation menu list for a given header pgmNo
     */
    public List<MenuDto> getSideMenuList(String pgmNo) {
        if (pgmNo == null || pgmNo.isBlank()) {
            List<MenuDto> topList = getTopMenuList();
            if (!topList.isEmpty()) {
                pgmNo = topList.get(0).getPgmNo();
            } else {
                pgmNo = "01000";
            }
        }
        return menuMapper.selectSideMenuList(pgmNo);
    }

    /**
     * Get menu DTO by PGM_ID to fetch FULLPGM2
     */
    public MenuDto getMenuByPgmId(String pgmId) {
        if (pgmId == null || pgmId.isBlank()) return null;
        return menuMapper.selectMenuByPgmId(pgmId);
    }
}
