package com.kfp.aams.domain.home.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "SZX0AA")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Szx0aa {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Column(name = "COMPANY_NAME", length = 80)
    private String companyName;

    @Column(name = "HYUN_YMD")
    private String hyunYmd;

    @Column(name = "GIJUNGA_YMD")
    private String gijungaYmd;

    @Column(name = "JUNYONG_YMD")
    private String junyongYmd;

    @Column(name = "IKYONG_YMD")
    private String ikyongYmd;

    @Column(name = "THIKYONG_YMD")
    private String thikyongYmd;

    @Column(name = "LAST_YMD")
    private String lastYmd;

    @Column(name = "SYMD")
    private String symd;

    @Column(name = "EYMD")
    private String eymd;

    @Column(name = "CHECK_YMD")
    private String checkYmd;

    @Column(name = "H2O")
    private String h2o;

    @Column(name = "DEPOSIT_DD")
    private Integer depositDd;

    @Column(name = "DEPOSIT_ACCOUNT", length = 200)
    private String depositAccount;

    @Column(name = "BIGO", length = 200)
    private String bigo;

    @Column(name = "CUSTOMER_GR", length = 20)
    private String customerGr;

    @Column(name = "EXPENSE_YN", length = 1)
    private String expenseYn;
}
