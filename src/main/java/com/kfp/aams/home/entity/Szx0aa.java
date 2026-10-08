package com.kfp.aams.home.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
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

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "HYUN_YMD")
    private String hyunYmd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "GIJUNGA_YMD")
    private String gijungaYmd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "JUNYONG_YMD")
    private String junyongYmd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "IKYONG_YMD")
    private String ikyongYmd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "THIKYONG_YMD")
    private String thikyongYmd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "LAST_YMD")
    private String lastYmd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "SYMD")
    private String symd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "EYMD")
    private String eymd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
    @Column(name = "CHECK_YMD")
    private String checkYmd;

    @Convert(converter = com.kfp.aams.common.converter.StringToDateConverter.class)
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
