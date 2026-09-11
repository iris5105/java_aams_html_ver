# w_ja010g : 매매내역 데이터 조회 가이드

## 1. 화면 개요 및 파워빌더 대응 정보

- **프로그램 ID**: `W_JA010G` (w_ja010g)
- **메뉴 경로**: 사무관리 > 자문일일 > 매매내역
- **파워빌더 소스**: `pb_recource/JA010/w_ja010g.srw`
- **데이터윈도우**: `d_ja010g.srd` (매매내역 목록)
- **화면 구조**: 상단 조건 필터바(매매일자, 회사코드) + 메인 Tabulator 데이터 그리드

---

## 2. 데이터 조회 전체 시퀀스

```
[화면 진입 / 조회 버튼]
          │
          ▼ (1)
[w_ja010g.html :: loadData()]
  - API 호출: GET /api/daily/ja010g/list?corpGr=...&ymd=...
          │
          ▼ (2)
[Ja010gController.java :: getList()]
          │
          ▼ (3)
[Ja010gService.java :: getTradeList()]
          │
          ▼ (4)
[Ja010gMapper.java :: selectTradeList()]
          │
          ▼ (5)
[Ja010gMapper.xml (FW_DAY_TR 테이블 및 기준일자 조인)]
          │
          ▼ (6)
[Tabulator 그리드 바인딩]
  - 매매구분, 종목코드, 종목명, 수량, 단가, 약정금액 등 표출
```

---

## 3. 계층별 세부 코드 및 구성 분석

### 3.1 화면 및 클라이언트 스크립트 ([w_ja010g.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/daily/w_ja010g.html))

- **필터바 및 달력 연동**:
  ```javascript
  AamsCalendar.initSimple('filterYmd', {
      pane: pane,
      initialYmd: initialYmd,
      onSelect: function(ymd) {
          loadData();
      }
  });
  ```
- **Tabulator 컬럼 포맷터**:
  - 수량, 단가, 금액 컬럼: `formatter: "money"`, `hozAlign: "right"`
  - 매매구분(`trGb`): `1`(매수), `2`(매도) 라벨 포맷터 적용

### 3.2 매퍼 SQL 계층 (`Ja010gMapper.xml`)

```xml
<select id="selectTradeList" resultType="com.kfp.aams.domain.daily.dto.Ja010gDto">
    SELECT T.CORP_GR    AS corpGr,
           T.TR_YMD     AS trYmd,
           T.FUND_CD    AS fundCd,
           F.FUND_NM    AS fundNm,
           T.ITEM_CD    AS itemCd,
           I.ITEM_NM    AS itemNm,
           T.TR_GB      AS trGb,
           T.QTY        AS qty,
           T.PRICE      AS price,
           T.AMT        AS amt
      FROM FW_DAY_TR T
      LEFT JOIN SZX0AA F ON T.CORP_GR = F.CORP_GR AND T.FUND_CD = F.FUND_CD
      LEFT JOIN SZX0GA I ON T.ITEM_CD = I.ITEM_CD
     WHERE T.CORP_GR = #{corpGr}
       AND T.TR_YMD = #{ymd}
     ORDER BY T.TR_YMD DESC, T.FUND_CD ASC
</select>
```

---

## 4. 유지보수 체크포인트

1. **상단 툴바 계약 함수 바인딩**:
   - `pane.onSearch`, `pane.onRefresh`, `pane.onCorpGrChange`가 올바르게 연결되어 브라우저 리사이즈 및 회사 변경 시 데이터가 갱신되는지 확인합니다.
2. **숫자 데이터 정렬 및 천단위 콤마**:
   - Tabulator hozAlign 규칙에 따라 숫자 컬럼은 오른쪽 정렬(`hozAlign: "right"`), 문자 컬럼은 가운데/왼쪽 정렬을 준수합니다.
