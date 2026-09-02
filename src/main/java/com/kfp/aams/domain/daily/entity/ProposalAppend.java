package com.kfp.aams.domain.daily.entity;

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
@Table(name = "PROPOSAL_APPEND")
@IdClass(ProposalAppendId.class)
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProposalAppend {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Id
    @Column(name = "P_YMD", nullable = false)
    private LocalDateTime pYmd;

    @Id
    @Column(name = "P_PROPOSER", length = 40, nullable = false)
    private String pProposer;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDateTime ymd;

    @Id
    @Column(name = "SB_NM", length = 40, nullable = false)
    private String sbNm;

    @Lob
    @Column(name = "APPENDING")
    private String appending;
}
