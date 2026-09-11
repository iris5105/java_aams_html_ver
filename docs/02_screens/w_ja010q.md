# w_ja010q : 성과보수 상세내역 데이터 조회 및 리포트 연동 가이드

## 1. 화면 개요 및 파워빌더 대응 정보

- **프로그램 ID**: `W_JA010Q` (w_ja010q)
- **메뉴 경로**: 사무관리 > 자문일일 > 성과보수 상세내역
- **파워빌더 소스**: `pb_recource/JA010/w_ja010q.srw`
- **데이터윈도우 / 리포트**:
  - 마스터 그리드: `d_ja010q.srd` (성과보수 발생 펀드 목록)
  - 리포트 템플릿: `rd_ja010q.mrd`
- **화면 구조**: 좌측 펀드 목록 Tabulator 그리드 + 우측 성과보수 리포트 뷰어(`<iframe>`), 120% 줌 연동

---

## 2. 데이터 조회 및 렌더링 전체 시퀀스

```
[화면 진입 / 조회 버튼]
            │
            ▼ (1)
[w_ja010q.html :: loadFunds()]
  - API 호출: GET /api/daily/ja010q/funds?corpGr=...&ymd=...
            │
            ▼ (2)
[Ja010qController.java :: getFundList()]
  - Ja010qService.getFundList(corpGr, ymd)
  - Ja010qMapper.selectFundList(corpGr, ymd)
            │
            ▼ (3)
[그리드 데이터 바인딩 및 첫 번째 행 자동 선택]
  - rows[0].select() -> syncDetail(rows[0], data[0])
            │
            ▼ (4)
[w_ja010q.html :: syncDetail()]
  - rawPreviewUrl = "/api/daily/ja010q/preview?fundCd=...&ymd=...&haejiYmd=...&bfStart=...&af=..."
  - previewUrl = AamsReport.formatPreviewUrl(rawPreviewUrl) -> 120% 줌 부착
  - iframe.src = previewUrl
            │
            ▼ (5)
[Ja010qController.java :: previewReport()]
  - RdReportService.generateJa010qReport(corpGr, fundCd, fundNm, ymd, bf, af, "pdf")
  - PDF 바이너리 스트림 반환
```

---

## 3. 계층별 세부 코드 및 구성 분석

### 3.1 화면 및 클라이언트 스크립트 ([w_ja010q.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/daily/w_ja010q.html))

- **삼중 안전망 및 120% 줌 연동**:
  ```javascript
  setupTabulatorRowSelection(grid, function(row, data) {
      syncDetail(row, data);
  });
  grid.on("rowClick", function(e, row) {
      syncDetail(row, row ? row.getData() : null);
  });
  grid.on("rowSelectionChanged", function(data, rows) {
      if (rows && rows.length > 0) syncDetail(rows[0], rows[0].getData());
  });

  function syncDetail(row, data) {
      var previewUrl = "/api/daily/ja010q/preview?fundCd=" + encodeURIComponent(data.fundCd) +
          "&fundNm=" + encodeURIComponent(data.fundNm) +
          "&ymd=" + encodeURIComponent(ymd) +
          "&haejiYmd=" + encodeURIComponent(data.haejiYmd || "") +
          "&bfStart=" + encodeURIComponent(data.bfStart || "") +
          "&af=" + encodeURIComponent(data.af || "") +
          "&t=" + new Date().getTime();

      iframe.src = AamsReport.formatPreviewUrl(previewUrl);
  }
  ```

### 3.2 컨트롤러 계층 (`Ja010qController.java`)

```java
@GetMapping("/api/daily/ja010q/preview")
public ResponseEntity<byte[]> previewReport(
        @RequestParam(name = "corpGr", required = false) String corpGr,
        @RequestParam("fundCd") String fundCd,
        @RequestParam(name = "fundNm", required = false) String fundNm,
        @RequestParam("ymd") String ymd,
        @RequestParam(name = "bfStart", required = false) String bfStart,
        @RequestParam(name = "af", required = false) String af) {
    RdReportService.ExportResult exportResult = rdReportService.generateJa010qReport(
            corpGr, fundCd, fundNm, ymd, bfStart, af, "pdf");

    return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_PDF)
            .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja010q.pdf\"")
            .body(exportResult.getData());
}
```

---

## 4. 유지보수 체크포인트

1. **성과보수 발생 조건 파라미터**:
   - 해지일자(`haejiYmd`), 결산기준일자(`bfStart`), 적용비율(`af`) 파라미터가 누락 없이 MRD에 전달되는지 점검합니다.
2. **리포트 120% 줌 동작**:
   - iframe의 URL 끝부분에 `#toolbar=1&navpanes=0&zoom=120`이 정상 부착되는지 브라우저 개발자 도구(F12) Elements 탭에서 확인합니다.
