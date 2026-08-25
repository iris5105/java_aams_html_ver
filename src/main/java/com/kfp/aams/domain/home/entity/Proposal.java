package com.kfp.aams.domain.home.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Lob;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "PROPOSAL")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@IdClass(ProposalId.class)
public class Proposal {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDateTime ymd;

    @Id
    @Column(name = "PROPOSER", length = 40, nullable = false)
    private String proposer;

    @Column(name = "TITLE", length = 250)
    private String title;

    @Lob
    @Column(name = "MATTER")
    private String matter;

    @Column(name = "CONTENT_YMD")
    private LocalDateTime contentYmd;

    @Lob
    @Column(name = "CONTENT")
    private String content;

    @Column(name = "FEXP", length = 4)
    private String fexp;

    @Lob
    @Column(name = "DATA")
    private byte[] data;

    @Column(name = "ORG_FNAME", length = 400)
    private String orgFname;
}
