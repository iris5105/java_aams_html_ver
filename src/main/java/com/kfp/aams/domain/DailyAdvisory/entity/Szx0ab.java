package com.kfp.aams.domain.daily.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Table(name = "SZX0AB")
@IdClass(Szx0abId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Szx0ab {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDate ymd;

    @Column(name = "COMPANY_NAME", length = 120)
    private String companyName;

    @Column(name = "IDNO", length = 12)
    private String idno;

    @Column(name = "CONTRACT_YMD")
    private LocalDate contractYmd;

    @Column(name = "POST", length = 5)
    private String post;

    @Column(name = "JUSO", length = 250)
    private String juso;

    @Column(name = "CEO_NM", length = 120)
    private String ceoNm;

    @Column(name = "TEL_NO", length = 80)
    private String telNo;

    @Column(name = "FAX_NO", length = 80)
    private String faxNo;

    @Column(name = "E_MAIL", length = 120)
    private String email;
}
