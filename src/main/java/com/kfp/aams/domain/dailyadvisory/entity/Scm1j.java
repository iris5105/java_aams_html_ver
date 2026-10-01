package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "SCM1J")
@IdClass(Scm1jId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Scm1j {

    @Id
    @Column(name = "CORP_GR", length = 10, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "JM_CD", length = 20, nullable = false)
    private String jmCd;

    @Id
    @Column(name = "BUY_DATE", length = 8, nullable = false)
    private String buyDate;

    @Column(name = "PG_CD", length = 20)
    private String pgCd;
}
