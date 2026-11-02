package com.kfp.aams.domain.subscriptionrights.entity;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;
import java.math.BigDecimal;
@Entity @Table(name="SCT1CG") @IdClass(Sct1cgId.class) @Getter @Setter
public class Sct1cg {
    @Id @Column(name="CORP_GR")
    private String corpGr;
    @Id @Column(name="TR_YMD")
    private LocalDate trYmd;
    @Id @Column(name="TR_CD")
    private String trCd;
    @Id @Column(name="FUND_CD")
    private String fundCd;
    @Id @Column(name="JM_CD")
    private String jmCd;
    @Id @Column(name="BUY_DATE")
    private String buyDate;
    @Id @Column(name="AEK_GB")
    private String aekGb;
    @Id @Column(name="SEQ_NO")
    private BigDecimal seqNo;
    @Column(name="GWAMOK")
    private String gwamok;
    @Column(name="AEK")
    private BigDecimal aek;
    @Column(name="JAN_AEK")
    private BigDecimal janAek;
    @Column(name="SANGHW_YMD")
    private LocalDate sanghwYmd;
}
