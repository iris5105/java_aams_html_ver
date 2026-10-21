package com.kfp.aams.domain.usportfoliomodel.dto;

import java.math.BigDecimal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * KRX 통화/금리/상품 선물/옵션 종목 (W_JA033C, d_ja033c.srd) DTO
 */
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Ja033cDto {

    private String comType;         // 상품구분 (1: 금리, 2: 통화, 3: 상품)
    private String infoType;        // TYPE (1: 선물, 2: SP선물, 5: 콜옵션, 6: 풋옵션)
    private String shrnIscd;        // 단축코드
    private String stndIscd;        // 표준코드 (PK)
    private String korName;         // 한글명
    private String atmClsCode;      // ATM (1: ATM, 2: ITM, 3: OTM)
    private BigDecimal acpr;        // 행사가
    private String mmscClsCode;     // 월물구분 (0: 연결선물, 1: 최근월물 등)
    private String prodNo;          // 기초단축
    private String prodName;        // 기초자산명

    // 추가 표시용 명칭
    private String comTypeName;     // 상품구분 명칭
    private String infoTypeName;    // TYPE 명칭
    private String atmClsName;      // ATM 명칭
    private String mmscClsName;     // 월물구분 명칭

    // 상태 관리 필드 (규정 02-3)
    private Boolean isNew;
    private Boolean isUpdated;
    private Boolean isDeleted;
    private String rowStatus;       // C: 등록, U: 수정, D: 삭제
}
