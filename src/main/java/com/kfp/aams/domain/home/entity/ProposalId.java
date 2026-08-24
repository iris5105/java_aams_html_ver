package com.kfp.aams.entity;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import java.io.Serializable;
import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class ProposalId implements Serializable {
    private String corpGr;
    private LocalDateTime ymd;
    private String proposer;
}
