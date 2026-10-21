package com.kfp.aams.domain.usportfoliomodel.entity;

import jakarta.persistence.*;

/**
 * CRON 큐 관리 엔티티 (단일 테이블 CRON_Q)
 */
@Entity
@Table(name = "CRON_Q")
public class CronQ {

    @Id
    @Column(name = "CRON_KEY", length = 64, nullable = false)
    private String cronKey;

    @Column(name = "PROC_NAME", length = 100)
    private String procName;

    @Column(name = "PROC_COMMENTS", length = 200)
    private String procComments;

    @Column(name = "IN_PARAM", length = 512)
    private String inParam;

    @Column(name = "OUT_PARAM", length = 512)
    private String outParam;

    @Column(name = "RUN_TIME", length = 100)
    private String runTime;

    @Column(name = "RUN_STATUS", length = 100)
    private String runStatus;

    public CronQ() {
    }

    public CronQ(String cronKey, String procName, String procComments, String inParam, String outParam, String runTime, String runStatus) {
        this.cronKey = cronKey;
        this.procName = procName;
        this.procComments = procComments;
        this.inParam = inParam;
        this.outParam = outParam;
        this.runTime = runTime;
        this.runStatus = runStatus;
    }

    public String getCronKey() {
        return cronKey;
    }

    public void setCronKey(String cronKey) {
        this.cronKey = cronKey;
    }

    public String getProcName() {
        return procName;
    }

    public void setProcName(String procName) {
        this.procName = procName;
    }

    public String getProcComments() {
        return procComments;
    }

    public void setProcComments(String procComments) {
        this.procComments = procComments;
    }

    public String getInParam() {
        return inParam;
    }

    public void setInParam(String inParam) {
        this.inParam = inParam;
    }

    public String getOutParam() {
        return outParam;
    }

    public void setOutParam(String outParam) {
        this.outParam = outParam;
    }

    public String getRunTime() {
        return runTime;
    }

    public void setRunTime(String runTime) {
        this.runTime = runTime;
    }

    public String getRunStatus() {
        return runStatus;
    }

    public void setRunStatus(String runStatus) {
        this.runStatus = runStatus;
    }
}
