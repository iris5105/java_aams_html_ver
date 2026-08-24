package com.kfp.aams.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "PROPOSAL")
@Getter
@Setter
@NoArgsConstructor
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
}
