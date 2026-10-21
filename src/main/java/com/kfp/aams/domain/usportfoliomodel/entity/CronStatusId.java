package com.kfp.aams.domain.usportfoliomodel.entity;

import java.io.Serializable;
import java.util.Objects;

/**
 * CRON_STATUS 테이블 복합 기본키
 */
public class CronStatusId implements Serializable {

    private String cronKey;
    private String runTime;

    public CronStatusId() {
    }

    public CronStatusId(String cronKey, String runTime) {
        this.cronKey = cronKey;
        this.runTime = runTime;
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CronStatusId that = (CronStatusId) o;
        return Objects.equals(cronKey, that.cronKey) &&
                Objects.equals(runTime, that.runTime);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cronKey, runTime);
    }
}
