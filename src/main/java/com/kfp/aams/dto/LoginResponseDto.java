package com.kfp.aams.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponseDto {
    private boolean success;
    private String message;
    private String accessToken;
    private String refreshToken;
    private String userId;
    private String corpGr;
    private String encEMail;
    private String companyName;
    private String hyunYmd;
    private String customerGr;
}
