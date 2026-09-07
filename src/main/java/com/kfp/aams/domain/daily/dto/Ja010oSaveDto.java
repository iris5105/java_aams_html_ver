package com.kfp.aams.domain.daily.dto;

import lombok.*;
import java.util.List;

/**
 * Save DTO for w_ja010o (SJM0JM_COLL)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ja010oSaveDto {
    private String corpGr;
    private String ymd;
    private String fundCd;
    private List<Ja010oMasterDto> saveList;     // 저장/수정 대상 목록
    private List<Ja010oMasterDto> deleteList;   // 삭제 대상 목록
}
