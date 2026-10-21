package com.kfp.aams.domain.usportfoliomodel.entity;

import jakarta.persistence.*;

/**
 * CRON 실행 상태/이력 엔티티 (CRON_STATUS 테이블)
 */
@Entity
@Table(name = "CRON_STATUS")
@IdClass(CronStatusId.class)
public class CronStatus {

    @Id
    @Column(name = "CRON_KEY", length = 64, nullable = false)
    private String cronKey;

    @Id
    @Column(name = "RUN_TIME", length = 30, nullable = false)
    private String runTime;

    @Column(name = "OUT_PARAM", length = 1024)
    private String outParam;

    @Column(name = "RUN_STATUS", length = 100)
    private String runStatus;

    public CronStatus() {
    }

    public CronStatus(String cronKey, String runTime, String outParam, String runStatus) {
        this.cronKey = cronKey;
        this.runTime = runTime;
        this.outParam = outParam;
        this.runStatus = runStatus;
    }

    public String getCronKey() {
        return cronKey;
    }

    public void setCronKey(String cronKey) {
        this.cronKey = cronKey;
    }

    public String getRunTime() {
        return runTime;
    }

    public void setRunTime(String runTime) {
        this.runTime = runTime;
    }

    public String getOutParam() {
        return outParam;
    }

    public void setOutParam(String outParam) {
        this.outParam = outParam;
    }

    public String getRunStatus() {
        return runStatus;
    }

    public void setRunStatus(String runStatus) {
        this.runStatus = runStatus;
    }
}
