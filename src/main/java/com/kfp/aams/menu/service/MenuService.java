package com.kfp.aams.menu.service;

import com.kfp.aams.menu.dto.MenuDto;
import com.kfp.aams.menu.mapper.MenuMapper;
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
    public List<MenuDto> getTopMenuList(String userId, String userNm) {
        return menuMapper.selectTopMenuList(userId, userNm);
    }

    /**
     * Side navigation menu list for a given header pgmNo
     */
    public List<MenuDto> getSideMenuList(String pgmNo, String userId, String userNm) {
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
        if (pgmId == null || pgmId.isBlank())
            return null;
        return menuMapper.selectMenuByPgmId(pgmId);
    }

    /**
     * Get all menu items for global sidebar search
     */
    public List<MenuDto> getAllMenuList(String userId, String userNm) {
        return menuMapper.selectAllMenuList(userId, userNm);
    }
}
