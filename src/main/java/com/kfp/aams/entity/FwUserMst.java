package com.kfp.aams.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "FW_USER_MST")
@Getter
@Setter
@NoArgsConstructor
public class FwUserMst {

    @Id
    @Column(name = "USER_ID", length = 30, nullable = false)
    private String userId;

    @Column(name = "USER_NM", length = 100)
    private String userNm;

    @Column(name = "OUT_YMD")
    private LocalDate outYmd;

    @Column(name = "DEPT_CD", length = 20)
    private String deptCd;

    @Column(name = "DEPT_NM", length = 100)
    private String deptNm;

    @Column(name = "IN_YMD")
    private LocalDate inYmd;

    @Column(name = "CORP_GR", length = 8)
    private String corpGr;

    @Column(name = "ADMIN_YN", length = 1)
    private String adminYn;

    @Column(name = "MANAGER_YN", length = 1)
    private String managerYn;

    @Column(name = "WATCHMAN_YN", length = 1)
    private String watchmanYn;

    @Column(name = "BOOKMARK_START", length = 50)
    private String bookmarkStart;

    @Column(name = "LAST_CONNECT")
    private String lastConnect;

    @Column(name = "ENC_E_MAIL", length = 256)
    private String encEMail;

    @Column(name = "ENC_PW", length = 256)
    private String encPw;
}
