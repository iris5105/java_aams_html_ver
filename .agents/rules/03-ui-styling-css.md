---
trigger: always_on
---

# AAMS UI 스타일링 및 CSS 표준 규격 (Zero-Inline-Style 원칙)

본 문서는 AAMS 웹 프론트엔드 스타일링, Tabulator 그리드 색상 시스템, 상태 배지 적용 시 반드시 준수해야 하는 공통 CSS 표준 규격입니다.

---

## 1. 전역 스타일링 대원칙

1. **그리드 인라인 스타일 작성 절대 금지 (Zero-Inline-Style)**:
   - Tabulator 그리드의 컬럼 헤더(`title`)나 셀 포매터(`formatter`) 내부에 `style="color:..."` 등의 인라인 HTML 스타일을 직접 작성하지 않는다.
   - 모든 색상, 배지, 정렬, 강조 표시는 [tabulator-custom.css](file:///d:/work/java_aams_html_ver/src/main/resources/static/css/tabulator-custom.css)의 **AAMS Tabulator Grid Standard Color System** 클래스를 사용한다.
2. **개별 화면 내 중복 `<style>` 블록 작성 금지**:
   - 행 선택 하이라이트(`.tabulator-selected`), 인라인 편집 셀 테두리(`.cell-editable-blue`), MRD 리포트 내보내기 버튼(`.btn-export-format`), 분할 스플리터 레이아웃 등은 이미 공통 CSS에 완전 구현되어 있으므로 각 화면 템플릿에 로컬 `<style>` 블록을 중복 작성하지 않는다.

---

## 2. 컬럼 헤더 타이틀 색상 클래스 (`headerCssClass`)

Tabulator 컬럼 정의 시 `title: "<span style='color:...'>..."`와 같이 인라인 HTML 태그를 넣지 않고, `headerCssClass` 속성을 부여한다:

```javascript
// 올바른 예:
{ title: "종목명", field: "itemNm", headerCssClass: "col-hdr-blue", ... }
{ title: "상환일", field: "payYmd", headerCssClass: "col-hdr-red", ... }
{ title: "펀드코드", field: "fundCd", headerCssClass: "col-hdr-green", ... }
{ title: "발행정보", field: "balhInfo", headerCssClass: "col-hdr-balh", ... }
```

### 파워빌더 DataWindow(.srd) 색상 매핑 표

| 파워빌더 color 값 | 의미 및 용도 | AAMS 공통 headerCssClass |
|---|---|---|
| **PB `16711680` (파랑)** | 주요 식별 컬럼: 종목명, 매입일, 종목코드, KSD종목 등 | `col-hdr-blue` |
| **PB `128` / `255` (빨강)** | 만기/종료일: 상환일, 계약해지일, 계약종료일, 펀드위험값 등 | `col-hdr-red` |
| **PB `32768` (초록)** | 고유 식별자/전략: 펀드코드, 관리번호, 전략베타 등 | `col-hdr-green` |
| **PB 주황색** | 발행정보: 발행기관, 발행일 등 | `col-hdr-balh` |

---

## 3. 데이터 셀 텍스트 색상 클래스 (`formatter` 반환 span)

데이터 셀 포매터에서 특정 텍스트를 강조할 때는 인라인 스타일 대신 공통 클래스를 부여한 `<span>` 태그를 반환한다:

- **파란색 텍스트**: `<span class="cell-text-blue">`
- **빨간색 텍스트**: `<span class="cell-text-red">`
- **초록색 텍스트**: `<span class="cell-text-green">`
- **회색 비활성 텍스트**: `<span class="cell-text-muted">`

```javascript
formatter: function (cell) {
    var val = cell.getValue();
    if (val == null || val === '') return '';
    var str = window.formatNumber ? window.formatNumber(val, 0) : Number(val).toLocaleString();
    return '<span class="cell-text-blue">' + str + '</span>';
}
```

---

## 4. 가격 및 등락률 표준 클래스 (`formatter`)

주가, 등락률, 수익률 변동 시 다음과 같이 표준 클래스를 부여한다:

- **상승 / 플러스 변동 (빨간색, `▲`)**: `<span class="cell-price-up">`
- **하락 / 마이너스 변동 (파란색, `▼`)**: `<span class="cell-price-down">`
- **보합 (회색, `-`)**: `<span class="cell-text-muted">`

---

## 5. 거래구분 및 상태 / 파일 배지 클래스

1. **거래구분 배지**:
   - 매수: `.cell-tr-buy`
   - 매도: `.cell-tr-sell`
   - 입고: `.cell-tr-in`
   - 출고: `.cell-tr-out`
   - 인수: `.cell-tr-acquire`
2. **상태 알약 배지**:
   - 정상 / 성공: `.badge-status-success` (초록 배경)
   - 오류 / 실패: `.badge-status-error` (빨강 배경)
3. **첨부파일 배지**:
   - 첨부파일 클립: `.file-badge`
4. **완료/해지 행 시각적 잠금**:
   - 완료 또는 해지된 행: `row.getElement().classList.add('row-completed');`
5. **파워빌더 DataWindow Summary 합계 행 표준**:
   - 합계 행: `row.getElement().classList.add('aams-summary-row');` (파워빌더 표준 연노랑 배경 `#fbf2c4`, 테두리, `font-weight: 600`, 행 선택 및 텍스트 선택 방지 `pointer-events: none`, `user-select: none` 적용)

---

## 6. 그리드 셀 하이라이트 및 행 아웃라인 배제 (Zero-Row-Outline)

1. **공통 CSS 배경색으로만 선택 표현**:
   - 그리드 행 선택 하이라이트는 `.tabulator-selected .tabulator-cell`의 배경색(`#bae6fd`) 및 셀 경계선(`border-bottom: 1px solid #7dd3fc`, `border-right: 1px solid #cbd5e1`)으로만 구성된다.
2. **커스텀 outline 금지**:
   - `layout: "fitDataFill"` 모드에서 컨테이너 우측 여백이나 마지막 셀 우측에 돌출선이 생기지 않도록 행이나 셀에 임의의 `outline`을 주지 않는다.
