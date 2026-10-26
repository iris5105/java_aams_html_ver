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
 * W_JA020A 탭1: 기본정보 DTO (d_ja020a_t1a, d_ja020a_t1b)
 */
@Getter
@Setter
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja020aT1Dto {

    private String corpGr; // 회사그룹
    private String ipUser; // 등록/수정자
    private String jcJoin; // 관리번호 (Key, join_seq)

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate ymd; // 등록일자

    private String cyGb; // 청약구분 (1: 공모, 2: 실권주)
    private String balhCo; // 발행기관코드
    private String jmNm; // 공모종목명
    private String xxBalhCo; // 공모종목명 (양방향 매핑)

    private String jgTrCoCd; // 대표주관사코드 (jg_tr_co_cd)
    private String trCoCd;   // 대표주관사코드 (호환성 별칭)
    private String jgTrCoNm; // 대표주관사명 (jg_tr_co_nm)
    private String xxTrCoCd; // 대표주관사명 (호환성 별칭)

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate startYmd; // 청약시작일

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate endYmd; // 청약종료일

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate sjYmd; // 상장일자

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate nabibYmd; // 납입일자

    private BigDecimal totBJusu; // 배정총주수
    private BigDecimal totGJusu; // 총공모주수
    private BigDecimal totGDanga; // 확정공모단가
    private BigDecimal totGAek; // 총공모금액

    private String cyJmCd; // 청약종목코드
    private String xxCyJmCd; // 청약종목명
    private String sjJmCd; // 상장예정종목코드
    private String xxSjJmCd; // 상장예정종목명

    private BigDecimal susuPer; // 수수료율
    private BigDecimal jkmPer; // 증거금율
    private BigDecimal competitionRate; // 경쟁률
    private String bigo; // 비고
    private String updUser; // 수정자

    private Integer pVisible; // 수정/삭제 가능 여부

    // CUD 상태 플래그
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;

    // 양방향 명칭 및 프로퍼티 호환성 지원 (Zero-Serialization-Loss)
    public String getUpdUser() {
        return updUser != null ? updUser : ipUser;
    }

    public void setUpdUser(String updUser) {
        this.updUser = updUser;
        if (this.ipUser == null) this.ipUser = updUser;
    }

    public String getIpUser() {
        return ipUser != null ? ipUser : updUser;
    }

    public void setIpUser(String ipUser) {
        this.ipUser = ipUser;
        if (this.updUser == null) this.updUser = ipUser;
    }

    public String getXxBalhCo() {
        return xxBalhCo != null ? xxBalhCo : jmNm;
    }

    public void setXxBalhCo(String xxBalhCo) {
        this.xxBalhCo = xxBalhCo;
        if (this.jmNm == null) this.jmNm = xxBalhCo;
    }

    public String getJmNm() {
        return jmNm != null ? jmNm : xxBalhCo;
    }

    public void setJmNm(String jmNm) {
        this.jmNm = jmNm;
        if (this.xxBalhCo == null) this.xxBalhCo = jmNm;
    }

    public String getJgTrCoCd() {
        return jgTrCoCd != null ? jgTrCoCd : trCoCd;
    }

    public void setJgTrCoCd(String jgTrCoCd) {
        this.jgTrCoCd = jgTrCoCd;
        if (this.trCoCd == null) this.trCoCd = jgTrCoCd;
    }

    public String getTrCoCd() {
        return trCoCd != null ? trCoCd : jgTrCoCd;
    }

    public void setTrCoCd(String trCoCd) {
        this.trCoCd = trCoCd;
        if (this.jgTrCoCd == null) this.jgTrCoCd = trCoCd;
    }

    public String getJgTrCoNm() {
        return jgTrCoNm != null ? jgTrCoNm : xxTrCoCd;
    }

    public void setJgTrCoNm(String jgTrCoNm) {
        this.jgTrCoNm = jgTrCoNm;
        if (this.xxTrCoCd == null) this.xxTrCoCd = jgTrCoNm;
    }

    public String getXxTrCoCd() {
        return xxTrCoCd != null ? xxTrCoCd : jgTrCoNm;
    }

    public void setXxTrCoCd(String xxTrCoCd) {
        this.xxTrCoCd = xxTrCoCd;
        if (this.jgTrCoNm == null) this.jgTrCoNm = xxTrCoCd;
    }
}
