---
trigger: always_on
---

# 02. DTO 및 데이터 모델링 개발 표준 가이드

본 문서는 파워빌더 DataWindow(.srd) 메타데이터를 기반으로 웹 DTO(Data Transfer Object) 및 데이터 모델을 구성할 때 반드시 준수해야 하는 표준 규격입니다.

---

## 1. srd 파일 기반 1:1 DTO 생성 원칙

1. **srd 메타데이터 반영**:
   - 파워빌더 `.srd` 파일의 DataWindow SQL 쿼리문 및 컬럼 정의(`table(column=...)`)를 기준으로 DTO를 구성한다.
   - 컬럼 데이터형 매핑:
     - `char(N)`, `varchar(N)` -> `String`
     - `number`, `decimal` -> `BigDecimal` (정수형이 명확한 경우 `Long` 또는 `Integer`)
     - `datetime`, `date` -> `String` (`YYYY-MM-DD` 문자열) 또는 `LocalDate`

---

## 2. 명칭 컬럼(`xx_`) 명명 규칙 및 양방향 프로퍼티 표준

1. **컬럼명 매핑 규칙**:
   - `.srd`의 `xx_fund_cd` -> DTO 필드명 `xxFundCd`
   - `.srd`의 `xx_yj_cd` -> DTO 필드명 `xxYjCd`
   - `.srd`의 `xx_koscom_cd` -> DTO 필드명 `xxKoscomCd`
2. **양방향 프로퍼티 필수 구성 (Zero-Serialization-Loss)**:
   - 레거시 명칭 프로퍼티(`fundNm`, `jmNm` 등)와의 호환성이 필요한 경우 양방향 getter/setter를 구성하여 직렬화/역직렬화 누락을 원천 방지한다:
     ```java
     private String xxFundCd;
     private String fundNm;

     public String getXxFundCd() {
         return xxFundCd != null ? xxFundCd : fundNm;
     }
     public void setXxFundCd(String xxFundCd) {
         this.xxFundCd = xxFundCd;
         if (this.fundNm == null) this.fundNm = xxFundCd;
     }
     public String getFundNm() {
         return fundNm != null ? fundNm : xxFundCd;
     }
     public void setFundNm(String fundNm) {
         this.fundNm = fundNm;
         if (this.xxFundCd == null) this.xxFundCd = fundNm;
     }
     ```

---

## 3. CUD 상태 관리 필드 표준

그리드 일괄 저장(저장 버튼 클릭 시 CUD 행 추출)을 위해 DTO에 반드시 상태 관리 필드를 포함한다:

```java
private Boolean isNew;
private Boolean isUpdated;
private Boolean isDeleted;
private String rowStatus; // C: 등록, U: 수정, D: 삭제
```

---

## 4. 화면별 DTO 분리 원칙 (Screen-Scoped DTOs)

1. **독립 DTO 구성**:
   - 동일한 DB 테이블을 참조하더라도 화면별로 다루는 컬럼 집합이 다를 경우, 화면별 전용 DTO(`AScreenDto`, `CScreenDto` 또는 `.srd` 1:1 매핑 DTO)로 철저히 분리한다.
2. **상호 의존성 차단**:
   - 각 화면은 자신이 필요로 하는 데이터만 DTO로 입출력하여 다른 화면의 변경 사항이나 불필요한 필드 의존성으로부터 독립성을 보장한다.
