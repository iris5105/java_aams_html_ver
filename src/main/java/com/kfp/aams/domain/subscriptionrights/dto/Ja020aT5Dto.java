package com.kfp.aams.domain.subscriptionrights.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * W_JA020A 탭3: 수요예측참여총괄표 목록 DTO (d_ja020a_t5)
 */
@Getter
@Setter
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020aT5Dto {

    private String corpGr;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd;

    private String jcJoin;
    private String sjJmCd;
    private String jgTrCoCd;
    private String jmNm;
    private String xxJmCd;
    private String cyGb;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate scYmd;
    private BigDecimal scJusu;
    private BigDecimal scDanga;

    private BigDecimal cyJusu;
    private BigDecimal cyDanga;
    private String bigo;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate lockEnd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate cyBoyuYmd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate cyYmd;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate nabibYmd;

    public String getXxJmCd() {
        return xxJmCd != null ? xxJmCd : jmNm;
    }

    public void setXxJmCd(String xxJmCd) {
        this.xxJmCd = xxJmCd;
        if (this.jmNm == null) this.jmNm = xxJmCd;
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxJmCd;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxJmCd == null) this.xxJmCd = jmNm;
    }

    public LocalDate getCyBoyuYmd() {
        return cyBoyuYmd != null ? cyBoyuYmd : lockEnd;
    }

    public void setCyBoyuYmd(LocalDate cyBoyuYmd) {
        this.cyBoyuYmd = cyBoyuYmd;
        if (this.lockEnd == null) this.lockEnd = cyBoyuYmd;
    }

    public LocalDate getLockEnd() {
        return lockEnd != null ? lockEnd : cyBoyuYmd;
    }

    public void setLockEnd(LocalDate lockEnd) {
        this.lockEnd = lockEnd;
        if (this.cyBoyuYmd == null) this.cyBoyuYmd = lockEnd;
    }
}
