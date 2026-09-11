# w_ja020k : 일(종목)별 운용현황 데이터 조회 및 리포트 연동 가이드

## 1. 화면 개요 및 파워빌더 대응 정보

- **프로그램 ID**: `W_JA020K` (w_ja020k)
- **메뉴 경로**: 사무관리 > 자문일일 > 일(종목)별 운용현황
- **파워빌더 소스**: `pb_recource/JA020/w_ja020k.srw`
- **리포트 템플릿**:
  - `rd_ja020k1.mrd` (고위험고수익, `series_gb == '1110'`)
  - `rd_ja020k2.mrd` (채권형, `series_gb == '1120'`)
  - `rd_ja020k3.mrd` (혼합/기타, 그 외)
- **화면 구조**: 상단 조건 필터바(기준일자 달력, 자료구분 DDDW) + 중앙 전폭 MRD 리포트 뷰어(`<iframe>`)

---

## 2. 데이터 조회 및 렌더링 전체 시퀀스

```
[사용자 화면 진입 / 조회 클릭]
            │
            ▼ (1)
[w_ja020k.html / 클라이언트 JS]
  - getFilterYmd(): 기준일자 추출 (yyyyMMdd)
  - getFilterSeriesGb(): 자료구분 추출 (1110 / 1120 / ...)
  - getFilterCorpGr(): 회사코드 쿠키 추출
  - getPreviewUrl(): AamsReport.formatPreviewUrl() 호출 -> #toolbar=1&navpanes=0&zoom=120 부착
            │
            ▼ (2) HTTP GET /api/daily/ja020k/preview?seriesGb=1110&ymd=20240613&corpGr=2402
[Ja020kController.java]
  - previewReport(corpGr, seriesGb, ymd)
            │
            ▼ (3)
[RdReportService.java]
  - generateJa020kReport(corpGr, seriesGb, ymd, "pdf")
  - resolveCorpGr(corpGr): 누락 시 Request 쿠키(savedCorpGr) 자동 추출
  - MRD 선택: seriesGb에 따라 rd_ja020k1.mrd 등 분기
  - 파라미터 조립: /rzoom [120] /rmessageboxshow [0] /rv corp_gr[...] series_gb[...] gubun[...] ymd[...]
  - Crownix Report 엔진 구동 -> SaveAsPdfFile() 호출
            │
            ▼ (4) 바이너리 반환
[클라이언트 iframe]
  - Content-Type: application/pdf 인라인 렌더링
  - 브라우저 내장 뷰어가 120% 확대로 즉시 표출
```

---

## 3. 계층별 세부 코드 및 구성 분석

### 3.1 화면 및 클라이언트 스크립트 ([w_ja020k.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/daily/w_ja020k.html))

- **필터바 구성**:
  - `filterYmd`: `AamsCalendar.initSimple` 바인딩, 작업일자 자동 주입
  - `filterDddw`: `f_dddwctl.get2ColItemFormatter` 2칸 분할 드롭다운 (1110: 고위험고수익 등)
- **리포트 로드 함수 (`loadReport`)**:
  ```javascript
  function getPreviewUrl() {
      var ymd = getFilterYmd();
      var seriesGb = getFilterSeriesGb();
      var corpGr = getFilterCorpGr();
      var baseUrl = "/api/daily/ja020k/preview?seriesGb=" + encodeURIComponent(seriesGb) +
          "&ymd=" + encodeURIComponent(ymd) +
          (corpGr ? "&corpGr=" + encodeURIComponent(corpGr) : "") +
          "&t=" + new Date().getTime();
      return AamsReport.formatPreviewUrl(baseUrl);
  }

  function loadReport() {
      var url = getPreviewUrl();
      iframe.src = url;
  }
  ```

### 3.2 컨트롤러 계층 ([Ja020kController.java](file:///d:/work/java_aams_html_ver/src/main/java/com/kfp/aams/domain/daily/controller/Ja020kController.java))

```java
@GetMapping("/api/daily/ja020k/preview")
public ResponseEntity<byte[]> previewReport(
        @RequestParam(value = "corpGr", required = false) String corpGr,
        @RequestParam(value = "seriesGb", defaultValue = "1110") String seriesGb,
        @RequestParam("ymd") String ymd) {
    try {
        RdReportService.ExportResult exportResult = rdReportService.generateJa020kReport(
                corpGr, seriesGb, ymd, "pdf");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ja020k_report.pdf\"")
                .body(exportResult.getData());
    } catch (Exception e) {
        log.error("일(종목)별 운용현황 리포트 미리보기 오류: ", e);
        return ResponseEntity.internalServerError().build();
    }
}
```

### 3.3 비즈니스 및 엔진 계층 ([RdReportService.java](file:///d:/work/java_aams_html_ver/src/main/java/com/kfp/aams/domain/daily/service/RdReportService.java))

- `corpGr` 파라미터가 비어있는 경우 `resolveCorpGr(corpGr)`를 통해 쿠키에서 추출.
- MRD 파라미터 조립:
  ```java
  StringBuilder param = new StringBuilder();
  param.append("/rv ");
  if (corpGr != null && !corpGr.isBlank()) param.append("corp_gr[").append(corpGr).append("] ");
  if (seriesGb != null && !seriesGb.isBlank()) {
      param.append("series_gb[").append(seriesGb).append("] ");
      if ("1110".equals(seriesGb)) param.append("gubun[2] ");
      else if ("1120".equals(seriesGb)) param.append("gubun[1] ");
  }
  if (!ymdDot.isBlank()) param.append("ymd[").append(ymdDot).append("] ");
  param.append("/rzoom [120] /rmessageboxshow [0]");
  ```

---

## 4. 유지보수 및 트러블슈팅 체크포인트

1. **리포트가 빈 화면으로 나오거나 데이터가 0건일 때**:
   - `corp_gr` 파라미터가 MRD에 전달되었는지 확인합니다 (누락 시 쿼리 조건 불일치로 0건 반환).
   - 브라우저 쿠키에 `savedCorpGr`이 정상 설정되어 있는지 확인합니다.
2. **날짜 변경 시 조회가 동작하지 않을 때**:
   - `aams_calendar.js`의 `onSelect` 콜백에서 `loadReport()`가 정상 호출되는지 확인합니다.
3. **파일 내보내기(Excel/Word) 파일명이 깨질 때**:
   - `Ja020kController`의 `URLEncoder.encode(..., StandardCharsets.UTF_8).replaceAll("\\+", "%20")` 헤더 처리를 점검합니다.
