package com.kfp.aams.domain.subscriptionrights.entity;
import jakarta.persistence.*;
import lombok.Getter;
import java.math.BigDecimal;
@Entity @Table(name="SCM0CJ_KAP") @Getter
public class Scm0cjKap {
    @Id @Column(name="AS_CJ_CD") private String asCjCd;
    @Column(name="CHG_GA") private BigDecimal chgGa;
    @Column(name="CHG_JM_CD") private String chgJmCd;
    @Column(name="CHG_START_IL") private String chgStartIl;
}
