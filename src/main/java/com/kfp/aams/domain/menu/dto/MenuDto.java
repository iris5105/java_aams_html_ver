package com.kfp.aams.dto;

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
    private String pgmNo; // PGM_NO
    private String pgmId; // PGM_ID
    private String pgmNm; // PGM_NM
    private String pgmGo; // PGM_GO
    private String parentPgm; // PARENT_PGM
    private String pgmKindCode; // PGM_KIND_CODE
    private String menuUseYn; // MENU_USE_YN
    private String pgmUseYn; // PGM_USE_YN
    private Long sortOrder; // SORT_ORDER
    private String updId; // UPD_ID
    private Integer treeLevel; // TREE_LEVEL
    private String treeLine; // TREE_LINE
    private Integer childCnt; // childCnt

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
