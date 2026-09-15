package com.kfp.aams.domain.daily.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class ProposalAppendId implements Serializable {
    private String corpGr;
    private LocalDateTime pYmd;
    private String pProposer;
    private LocalDateTime ymd;
    private String sbNm;
}
