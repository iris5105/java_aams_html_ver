package com.kfp.aams.domain.home.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProposalDto {
    private String corpGr;
    private LocalDateTime ymd;
    private String proposer;
    private String title;
    private String matter;
    private LocalDateTime contentYmd;
    private String content;
}
