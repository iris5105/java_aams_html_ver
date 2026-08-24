package com.kfp.aams.domain.home.dto;

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
public class ChtDataDto {
    private String chtYn;
    private String cv2Chtnm;
    private Double cv2Chtvalue001;
    private Double cv2Chtvalue002;
}
