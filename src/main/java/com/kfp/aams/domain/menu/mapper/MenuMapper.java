package com.kfp.aams.domain.menu.mapper;

import com.kfp.aams.domain.menu.dto.MenuDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface MenuMapper {

    /**
     * Header top menu list (PGM_KIND_CODE = 'M', PARENT_PGM = '00000')
     */
    List<MenuDto> selectTopMenuList();

    /**
     * Side navigation menu list (Hierarchical CONNECT BY ISLEAF = 1 query starting with pgmNo)
     */
    List<MenuDto> selectSideMenuList(@Param("pgmNo") String pgmNo);

    /**
     * Get menu DTO by PGM_ID to fetch FULLPGM2 breadcrumb info
     */
    MenuDto selectMenuByPgmId(@Param("pgmId") String pgmId);
}
