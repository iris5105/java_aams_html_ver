package com.kfp.aams.domain.usportfoliomodel.dto;

import java.io.Serializable;

/**
 * d_ja032d4 (테이블 컬럼 및 데이터 값 인스펙터) DTO
 */
public class Ja032dColumnDataDto implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long columnId;
    private String columnName;
    private String comments;
    private String colVal;

    public Ja032dColumnDataDto() {
    }

    public Ja032dColumnDataDto(Long columnId, String columnName, String comments, String colVal) {
        this.columnId = columnId;
        this.columnName = columnName;
        this.comments = comments;
        this.colVal = colVal;
    }

    public Long getColumnId() {
        return columnId;
    }

    public void setColumnId(Long columnId) {
        this.columnId = columnId;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public String getColVal() {
        return colVal;
    }

    public void setColVal(String colVal) {
        this.colVal = colVal;
    }
}
