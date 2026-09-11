# w_ja010h : 자산명세표 데이터 조회 및 반응형 모바일 모달 가이드

## 1. 화면 개요 및 파워빌더 대응 정보

- **프로그램 ID**: `W_JA010H` (w_ja010h)
- **메뉴 경로**: 사무관리 > 자문일일 > 자산명세표
- **파워빌더 소스**: `pb_recource/JA010/w_ja010h.srw`
- **데이터윈도우 / 리포트**:
  - 마스터 목록: `d_szm0ia.srd` (펀드 목록)
  - 리포트 템플릿: `rd_ja010h.mrd`, `rd_ja010h_coll.mrd` (합산 펀드)
  - 종합 엑셀: `rd_ja010h_00.mrd`, `rd_ja010h_00_2402.mrd`
- **화면 구조**:
  - 데스크톱 (> 876px): 좌측 펀드 그리드 + 우측 리포트 뷰어 분할 레이아웃
  - 태블릿-S/모바일 (<= 876px): 우측 패널 숨김(`display:none`), 펀드 클릭 시 전체화면 모달 팝업으로 리포트 표출 (반응형 규격 2)

---

## 2. 데이터 조회 및 렌더링 전체 시퀀스

```
[화면 진입 / 조회 버튼] 
           │
           ▼ (1)
[w_ja010h.html :: loadFundList()]
  - API 호출: GET /api/daily/ja010h/funds?corpGr=...&ymd=...
           │
           ▼ (2)
[Ja010hController.java :: getFundList()]
  - Ja010hService.getFundList(corpGr, ymd)
  - Ja010hMapper.selectFundList(corpGr, ymd)
  - Ja010hMapper.xml (SZX0AA, SZX0BB 등 조인 조회)
           │
           ▼ (3)
[Tabulator 그리드 렌더링 및 행 선택]
  - rows[0].select() -> onFundSelect(row, data)
           │
           ├─► 데스크톱: 우측 #ja010hReportFrame 에 로드
           └─► 모바일: #ja010hMobileModal 팝업 후 #ja010hMobileReportFrame 에 로드
           │
           ▼ (4)
[AamsReport.formatPreviewUrl(previewUrl)] -> 120% 확대 적용
           │
           ▼ (5)
[Ja010hController.java :: previewReport()]
  - RdReportService.generateJa010hReport(...) -> PDF 바이너리 스트리밍
```

---

## 3. 계층별 세부 코드 및 구성 분석

### 3.1 화면 및 반응형 스크립트 ([w_ja010h.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/daily/w_ja010h.html))

- **데스크톱 / 모바일 반응형 분기**:
  ```javascript
  function onFundSelect(row, data) {
      const isMobile = window.innerWidth <= 876;
      const ymd = getFilterYmd();

      if (isMobile) {
          // 모바일: 팝업 모달 표출
          openMobileReportModal(data, ymd);
      } else {
          // 데스크톱: 우측 패널 표출
          loadDesktopReport(data, ymd);
      }
  }

  function loadDesktopReport(data, ymd) {
      const rawUrl = `/api/daily/ja010h/preview?corpGr=${encodeURIComponent(currentCorpGr)}&ymd=${encodeURIComponent(ymd)}&fundCd=${encodeURIComponent(data.fundCd)}`;
      // AamsReport 공통 유틸을 통한 120% 줌 부착
      frame.src = AamsReport.formatPreviewUrl(rawUrl);
  }
  ```

### 3.2 컨트롤러 계층 (`Ja010hController.java`)

```java
@GetMapping("/api/daily/ja010h/funds")
public ResponseEntity<List<Ja010hFundDto>> getFundList(
        @RequestParam(name = "corpGr", required = false) String corpGr,
        @RequestParam(name = "ymd") String ymd) {
    return ResponseEntity.ok(ja010hService.getFundList(corpGr, ymd));
}

@GetMapping("/api/daily/ja010h/preview")
public ResponseEntity<byte[]> previewReport(
        @RequestParam(name = "corpGr", required = false) String corpGr,
        @RequestParam("ymd") String ymd,
        @RequestParam("fundCd") String fundCd) {
    RdReportService.ExportResult res = ja010hService.generateReport(corpGr, ymd, fundCd, "pdf");
    return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_PDF)
            .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja010h.pdf\"")
            .body(res.getData());
}
```

### 3.3 매퍼 SQL 계층 (`Ja010hMapper.xml`)

```xml
<select id="selectFundList" resultType="com.kfp.aams.domain.daily.dto.Ja010hFundDto">
    SELECT A.CORP_GR     AS corpGr,
           A.FUND_CD     AS fundCd,
           A.FUND_NM     AS fundNm,
           A.START_YMD   AS startYmd,
           A.END_YMD     AS endYmd,
           NVL(A.COLL_GB, '0') AS collGb
      FROM SZX0AA A
     WHERE A.CORP_GR = #{corpGr}
       AND #{ymd} BETWEEN A.START_YMD AND NVL(A.END_YMD, '99991231')
     ORDER BY A.FUND_CD ASC
</select>
```

---

## 4. 유지보수 체크포인트

1. **모바일 해상도(width <= 876px) 테스트**:
   - 모바일 크기에서 펀드 클릭 시 우측 영역 대신 모달 다이얼로그가 화면 중앙에 풀스크린으로 뜨고 닫기(X) 버튼이 작동하는지 확인합니다.
2. **합산 펀드(`collGb == '1'`) 분기**:
   - 합산 펀드인 경우 `rd_ja010h_coll.mrd`로 분기 호출되는지 점검합니다.
