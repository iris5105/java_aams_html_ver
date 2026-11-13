package com.kfp.aams.domain.assetmanagement.dto;

import lombok.Data;

import java.time.LocalDate;

/** W_JA030M 복사 행의 발행일자·만기인출일. */
@Data
public class Ja030mCopyDateDto {
    private LocalDate balhYmd;
    private LocalDate sanghwYmd;
}
