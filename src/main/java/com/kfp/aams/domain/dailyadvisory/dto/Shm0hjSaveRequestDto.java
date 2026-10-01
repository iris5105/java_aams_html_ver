package com.kfp.aams.domain.dailyadvisory.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Save request DTO for w_shm0hj (SHM0HJ table)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Shm0hjSaveRequestDto {
    private String corpGr;
    private List<Shm0hjMasterDto> insertList;
    private List<Shm0hjMasterDto> updateList;
    private List<Shm0hjMasterDto> deleteList;
}
