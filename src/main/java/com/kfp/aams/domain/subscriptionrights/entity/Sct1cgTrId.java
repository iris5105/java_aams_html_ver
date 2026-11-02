package com.kfp.aams.domain.subscriptionrights.entity;
import lombok.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.math.BigDecimal;
@Data @NoArgsConstructor @AllArgsConstructor
public class Sct1cgTrId implements Serializable {
    private String corpGr;
    private LocalDate trYmd;
    private String trCd;
    private String fundCd;
    private String jmCd;
    private String buyDate;
    private String aekGb;
    private BigDecimal seqNo;
}
