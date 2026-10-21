package com.kfp.aams.domain.usportfoliomodel.dto;

import java.io.Serializable;

/**
 * d_ja032d3 (API 처리상태 요약) DTO
 */
public class Ja032dStatusDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private String apiKey;
    private String headers;
    private String createdAt;
    private String msgCd;
    private String msg1;
    private Long curRow;
    private Long allRow;

    public Ja032dStatusDto() {
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    public String getHeaders() {
        return headers;
    }

    public void setHeaders(String headers) {
        this.headers = headers;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getMsgCd() {
        return msgCd;
    }

    public void setMsgCd(String msgCd) {
        this.msgCd = msgCd;
    }

    public String getMsg1() {
        return msg1;
    }

    public void setMsg1(String msg1) {
        this.msg1 = msg1;
    }

    public Long getCurRow() {
        return curRow;
    }

    public void setCurRow(Long curRow) {
        this.curRow = curRow;
    }

    public Long getAllRow() {
        return allRow;
    }

    public void setAllRow(Long allRow) {
        this.allRow = allRow;
    }
}
