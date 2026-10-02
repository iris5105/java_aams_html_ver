package com.kfp.aams.domain.dailyadvisory.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import java.time.LocalDate;
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

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;

    private String fundCd;
    private List<Ja010oMasterDto> saveList;     // 저장/수정 대상 목록
    private List<Ja010oMasterDto> deleteList;   // 삭제 대상 목록
}
