package com.kfp.aams.domain.dailyadvisory.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "SJX0JB_HISTORY")
@IdClass(Sjx0jbHistoryId.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Sjx0jbHistory {

    @Id
    @Column(name = "BALH_CO", length = 20, nullable = false)
    private String balhCo;

    @Id
    @Column(name = "YMD", nullable = false)
    private LocalDateTime ymd;

    @Id
    @Column(name = "CHG_COLUMN", length = 50, nullable = false)
    private String chgColumn;

    @Column(name = "BF_DATA", length = 200)
    private String bfData;

    @Column(name = "AF_DATA", length = 200)
    private String afData;

    @Column(name = "SKT0BU", length = 10)
    private String skt0bu;

    @Column(name = "UPD_USER", length = 50)
    private String updUser;
}
