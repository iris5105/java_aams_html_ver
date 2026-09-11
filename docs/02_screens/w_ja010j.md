# w_ja010j : 공모청약 수요예측 참여표 데이터 조회 및 리포트 연동 가이드

## 1. 화면 개요 및 파워빌더 대응 정보

- **프로그램 ID**: `W_JA010J` (w_ja010j)
- **메뉴 경로**: 공모청약 > 공모청약관리 > 수요예측 참여표(회사)
- **파워빌더 소스**: `pb_recource/JA010/w_ja010j.srw`
- **데이터윈도우 / 리포트**:
  - 마스터 그리드: `d_ja010j.srd` (수요예측 종목/펀드 목록)
  - 리포트 템플릿:
    - `rd_ja010j_0.mrd` (`fund_cd == '0'`)
    - `rd_ja010j_1.mrd` / `rd_ja010j_2202.mrd` (`fund_cd == '1'`)
    - `rd_ja010j_2.mrd` (`fund_cd == '2'`)
    - `rd_ja010j_6.mrd` (그 외)
- **화면 구조**: 좌측 수요예측 목록 그리드 + 우측 리포트 뷰어(`<iframe>`), 구간 일자 필터

---

## 2. 데이터 조회 및 렌더링 전체 시퀀스

```
[화면 진입 / 구간일자 조회]
            │
            ▼ (1)
[w_ja010j.html :: loadList()]
  - API 호출: GET /api/daily/ja010j/list?corpGr=...&fymd=...&tymd=...
            │
            ▼ (2)
[Ja010jController.java :: getList()]
  - Ja010jService.getIpoDemandForecastList()
  - Ja010jMapper.selectDemandForecastList()
            │
            ▼ (3)
[Tabulator 그리드 바인딩 및 첫 번째 행 선택]
  - rows[0].select() -> syncDetail(rows[0], data[0])
            │
            ▼ (4)
[w_ja010j.html :: syncDetail()]
  - rawPreviewUrl = "/api/daily/ja010j/preview?corpGr=...&fundCd=...&companyName=...&fymd=...&tymd=..."
  - previewUrl = AamsReport.formatPreviewUrl(rawPreviewUrl) -> 120% 확대 적용
  - iframe.src = previewUrl
            │
            ▼ (5)
[Ja010jController.java :: previewReport()]
  - RdReportService.generateJa010jReport()
  - fund_cd 및 corp_gr에 따라 4대 MRD 템플릿 분기
  - PDF 바이너리 스트림 반환
```

---

## 3. 계층별 세부 코드 및 구성 분석

### 3.1 화면 및 클라이언트 스크립트 ([w_ja010j.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/daily/w_ja010j.html))

```javascript
function syncDetail(row, data) {
    var previewUrl = "/api/daily/ja010j/preview?corpGr=" + encodeURIComponent(corpGr) +
        "&fundCd=" + encodeURIComponent(data.fundCd) +
        "&companyName=" + encodeURIComponent(data.companyName || "") +
        "&fundNm=" + encodeURIComponent(data.fundNm || "") +
        "&fymd=" + encodeURIComponent(fymd) +
        "&tymd=" + encodeURIComponent(tymd) +
        "&t=" + new Date().getTime();

    // AamsReport 공통 유틸을 통한 120% 줌 일괄 적용
    iframe.src = (window.AamsReport && typeof window.AamsReport.formatPreviewUrl === 'function')
        ? window.AamsReport.formatPreviewUrl(previewUrl)
        : previewUrl + "#toolbar=1&navpanes=0&zoom=120";
}
```

### 3.2 리포트 분기 생성 로직 ([RdReportService.java](file:///d:/work/java_aams_html_ver/src/main/java/com/kfp/aams/domain/daily/service/RdReportService.java))

```java
public ExportResult generateJa010jReport(String corpGr, String fundCd, String title,
                                        String fymd, String tymd, String format) throws Exception {
    corpGr = resolveCorpGr(corpGr);
    String mrdName;
    if ("0".equals(fundCd)) {
        mrdName = "rd_ja010j_0.mrd";
    } else if ("1".equals(fundCd)) {
        mrdName = "2202".equals(corpGr) ? "rd_ja010j_2202.mrd" : "rd_ja010j_1.mrd";
    } else if ("2".equals(fundCd)) {
        mrdName = "rd_ja010j_2.mrd";
    } else {
        mrdName = "rd_ja010j_6.mrd";
    }

    Path mrdPath = getTemplatePath(mrdName);
    // ... 파라미터 조립 및 SaveAsPdfFile() 변환
}
```

---

## 4. 유지보수 체크포인트

1. **회사별 리포트 전환 규격 (`2202` 회사 분기)**:
   - 파워빌더 소스 명세에 따라 `fund_cd == '1'`인 경우 `corp_gr == '2202'`이면 `rd_ja010j_2202.mrd`, 그 외는 `rd_ja010j_1.mrd`를 호출합니다.
2. **구간 달력(Range) 연동**:
   - `fymd`와 `tymd`의 유효성을 검증하고, 시작일이 종료일보다 늦지 않도록 클라이언트 및 백엔드에서 방어합니다.
