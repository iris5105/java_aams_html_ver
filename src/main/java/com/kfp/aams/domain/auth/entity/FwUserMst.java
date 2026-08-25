package com.kfp.aams.domain.auth.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "FW_USER_MST")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FwUserMst {

    @Column(name = "SYS_ID", length = 10, nullable = false)
    private String sysId;

    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "USER_ID", length = 10, nullable = false)
    private String userId;

    @Column(name = "USER_NM", length = 80)
    private String userNm;

    @Column(name = "ADMIN_YN", length = 1)
    private String adminYn;

    @Column(name = "MANAGER_YN", length = 1)
    private String managerYn;

    @Column(name = "WATCHMAN_YN", length = 1)
    private String watchmanYn;

    @Column(name = "ENC_E_MAIL", length = 90)
    private String encEMail;

    @Column(name = "IN_YMD")
    private LocalDate inYmd;

    @Column(name = "OUT_YMD")
    private LocalDate outYmd;

    @Column(name = "DEPT_CD", length = 4)
    private String deptCd;

    @Column(name = "DEPT_NM", length = 40)
    private String deptNm;

    @Column(name = "REG_NUM", length = 30)
    private String regNum;

    @Column(name = "UN_SYMD")
    private LocalDate unSymd;

    @Column(name = "ENC_TEL_NO", length = 30)
    private String encTelNo;

    @Column(name = "ENC_PW", length = 80)
    private String encPw;

    @Column(name = "PW_CNT")
    private Integer pwCnt;

    @Column(name = "PW_CHG")
    private LocalDate pwChg;

    @Column(name = "LAST_CONNECT")
    private LocalDateTime lastConnect;

    @Column(name = "BOOKMARK_START", length = 1)
    private String bookmarkStart;
}
