package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA020A 탭2: 배정등록 상단 청약종목 DTO (d_ja020a_t4a)
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020aT4aDto {

    private String corpGr;
    private String jcJoin;
    private String jgTrCoCd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate scYmd;        // 신청일자
    private BigDecimal scJusu;      // 신청수량
    private BigDecimal scDanga;     // 신청단가
    private BigDecimal scAek;       // 신청금액
    private String scUser;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate cyYmd;        // 청약일자
    private BigDecimal cyJusu;      // 청약수량
    private BigDecimal cyDanga;     // 청약단가
    private BigDecimal cyAek;       // 청약금액
    private BigDecimal cyJkm;       // 증거금
    private String cyUser;
    private String ipUser;

    public String getCyUser() {
        return cyUser != null ? cyUser : ipUser;
    }

    public void setCyUser(String cyUser) {
        this.cyUser = cyUser;
        if (this.ipUser == null) this.ipUser = cyUser;
    }

    public String getIpUser() {
        return ipUser != null ? ipUser : cyUser;
    }

    public void setIpUser(String ipUser) {
        this.ipUser = ipUser;
        if (this.cyUser == null) this.cyUser = ipUser;
    }

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate lockEnd;      // 매도제한일

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate nabibYmd;     // 납입일자
    private String cyType;
    private String bigo;

    private String jcJcJoin;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;
    private String balhCo;
    private String xxBalhCo;
    private String sjg1jcJgTrCoCd;
    private String jgTrCoNm;
    private String jmNm;
    private String cyGb;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate sjYmd;
    private String sjJmCd;
    private BigDecimal totGDanga;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate startYmd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate endYmd;
    private BigDecimal susuPer;
    private BigDecimal jkmPer;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate jcNabibYmd;
    private String jcBigo;
    private Integer pVisible;

    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
}
