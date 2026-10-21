package com.kfp.aams.domain.usportfoliomodel.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * CRON 실행 상태 DTO (d_cron_status.srd 매핑)
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class CronStatusDto {

    private String cronKey;
    private String runTime;
    private String runStatus;
    private String outParam;

    public CronStatusDto() {
    }

    public CronStatusDto(String cronKey, String runTime, String runStatus, String outParam) {
        this.cronKey = cronKey;
        this.runTime = runTime;
        this.runStatus = runStatus;
        this.outParam = outParam;
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

    public String getRunStatus() {
        return runStatus;
    }

    public void setRunStatus(String runStatus) {
        this.runStatus = runStatus;
    }

    public String getOutParam() {
        return outParam;
    }

    public void setOutParam(String outParam) {
        this.outParam = outParam;
    }
}
