package com.kfp.aams.domain.menu.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MenuDto {
    private String sysId;       // SYS_ID
    private String pgmNo;       // PGM_NO
    private String pgmId;       // PGM_ID
    private String pgmGo;       // PGM_GO
    private String pgmNm;       // PGM_NM
    private String pgmEnm;      // PGM_ENM
    private String pgmLnm;      // PGM_LNM
    private String pgmKindCode; // PGM_KIND_CODE
    private String pgmIcon;     // PGM_ICON
    private Integer sortOrder;  // SORT_ORDER
    private String parentPgm;   // PARENT_PGM
    private String menuUseYn;   // MENU_USE_YN
    private String pgmUseYn;    // PGM_USE_YN
    private String urlLinkYn;   // URL_LINK_YN
    private String linkedUrl;   // LINKED_URL
    private String pgmDesc;     // PGM_DESC
    private String ioType;      // IO_TYPE
    private String platformType;// PLATFORM_TYPE
    private Integer treeLevel;  // TREE_LEVEL
    private String regId;       // REG_ID
    private String regDt;       // REG_DT
    private String updId;       // UPD_ID
    private String updDt;       // UPD_DT
    private String treeLine;    // TREE_LINE
    private Integer maxlvl;     // MAXLVL
    private String fullpgm;     // FULLPGM
    private String fullpgm1;    // FULLPGM1
    private String fullpgm2;    // FULLPGM2
    private Integer childCnt;   // Child menu count for UI rendering

    /**
     * Side Navigation display name format: PGM_GO + ' ' + PGM_ID (or PGM_NO)
     */
    public String getDisplayNm() {
        String go = (pgmGo != null) ? pgmGo.trim() : "";
        String nm = (pgmNm != null && !pgmNm.isBlank()) ? pgmNm.trim() : ((pgmNo != null) ? pgmNo.trim() : "");
        if (go.isEmpty()) {
            return nm;
        }
        return go + " " + nm;
    }
}
