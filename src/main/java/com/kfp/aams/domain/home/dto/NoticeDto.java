package com.kfp.aams.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NoticeDto {
    private String sysId;
    private String boardNo;
    private Long docuNo;
    private String docuTitle;
    private Long treeLevel;
    private String startDtm;
    private String endDtm;
    private String membType;
    private String roleNo;
    private String holdYn;
    private String ontopYn;
    private String writerName;
    private String linkedPgmNo;
    private String readYn;
}
