package com.kfp.aams.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "SZX0AA")
@Getter
@Setter
@NoArgsConstructor
public class Szx0aa {

    @Id
    @Column(name = "CORP_GR", length = 8, nullable = false)
    private String corpGr;

    @Column(name = "COMPANY_NAME", length = 100)
    private String companyName;

    @Column(name = "HYUN_YMD", length = 8)
    private String hyunYmd;

    @Column(name = "GIJUNGA_YMD", length = 8)
    private String gijungaYmd;

    @Column(name = "JUNYONG_YMD", length = 8)
    private String junyongYmd;

    @Column(name = "IKYONG_YMD", length = 8)
    private String ikyongYmd;

    @Column(name = "THIKYONG_YMD", length = 8)
    private String thikyongYmd;

    @Column(name = "SYMD", length = 8)
    private String symd;

    @Column(name = "EYMD", length = 8)
    private String eymd;

    @Column(name = "DEPOSIT_DD")
    private Integer depositDd;

    @Column(name = "DEPOSIT_ACCOUNT", length = 50)
    private String depositAccount;

    @Column(name = "BIGO", length = 200)
    private String bigo;

    @Column(name = "CUSTOMER_GR", length = 8)
    private String customerGr;

    @Column(name = "EXPENSE_YN", length = 1)
    private String expenseYn;
}
