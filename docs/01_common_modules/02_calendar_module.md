# 02. 달력 컴포넌트 모듈 (`aams_calendar.js`)

## 1. 모듈 개요 및 설계 사상

[aams_calendar.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/aams_calendar.js)는 외부 무거운 서드파티 라이브러리(jQuery UI, Flatpickr 등) 없이 **순수 바닐라 JavaScript(ES6+)로 제작된 경량 맞춤형 달력 컴포넌트**입니다.

### 핵심 특징
- **MDI 탭 격리 완벽 지원**: 다중 탭 환경에서 동일한 `id="filterYmd"`를 가진 input 엘리먼트들이 서로 충돌하지 않도록 현재 탭의 컨테이너(`options.pane`)를 기반으로 달력 팝업을 렌더링합니다.
- **파워빌더 이벤트 완벽 매핑**: 파워빌더의 `dw_c` 컨트롤 조건에 따라 Simple(단일일자), Range(기간선택), Highlight(영업일 하이라이트) 모드를 자동으로 분기합니다.
- **표준 이벤트 디스패치**: 날짜가 선택되면 해당 `<input>` 요소에 `input` 및 `change` 이벤트를 네이티브로 디스패치하여 연계 데이터 조회가 즉시 동작합니다.

---

## 2. 달력 3대 동작 모드 규격 (규칙 16 및 달력 가이드)

| 모드 | 파워빌더 판별 조건 | JS 초기화 함수 | 특징 |
|---|---|---|---|
| **단일 날짜 (Simple)** | 기본 단일 일자 (`ymd`) | `AamsCalendar.initSimple(inputId, options)` | 날짜 선택 즉시 팝업이 닫히며 `yyyy-MM-dd` 바인딩 |
| **기간 선택 (Range)** | `dw_c`에 `ftymd` (시작일~종료일) 존재 | `AamsCalendar.initRange(containerId, options)` | 시작일과 종료일 2개의 input 또는 구간 바인딩 지원 |
| **영업일 하이라이트 (Highlight)** | `dw_c.ue_getdate` 스크립트 존재 | `AamsCalendar.initHighlight(inputId, options)` | 공휴일 및 비영업일을 API로 조회하여 시각적으로 하이라이트 표시 |

---

## 3. 주요 API 인터페이스 및 사용법

### 3.1 `AamsCalendar.initSimple` (가장 널리 사용되는 기본형)
```javascript
AamsCalendar.initSimple('filterYmd', {
    pane: pane,                           // 현재 MDI 탭 패널 컨테이너 (필수 권장)
    initialYmd: initialYmd || '20260911', // 초기 표시 일자 (yyyyMMdd 또는 yyyy-MM-dd)
    onSelect: function(ymd, formattedYmd) {
        // ymd: '20260911', formattedYmd: '2026-09-11'
        console.log("선택된 일자:", formattedYmd);
        loadReport(); // 또는 그리드 재조회
    }
});
```

### 3.2 방어적 파라미터 정규화 로직 (유지보수 안전장치)
`aams_calendar.js`는 개발자가 inputId 자리에 직접 DOM Element 객체를 전달하거나, options 자리에 콜백 함수/문자열을 잘못 전달하더라도 런타임 오류 없이 자체 정규화합니다:
```javascript
// aams_calendar.js 내부 로직
if (typeof inputId === 'object' && inputId !== null && inputId.nodeType === 1) {
    targetInput = inputId;
    actualInputId = targetInput.id || 'cal_input_' + Math.random().toString(36).substring(2, 9);
}
```

---

## 4. 기준일자(작업일자) 자동 연동 아키텍처

### 4.1 백엔드 기준일자 조회 규칙
- 파워빌더 `wue_lastopen` 이벤트 명세 반영:
  - 회사그룹 `corp_gr == '2402'`이면 `SZX0AA.JUNYONG_YMD`(전용일자) 사용
  - 그 외의 회사는 `SZX0AA.HYUN_YMD`(현재 작업일자, `idt_workdate`) 사용
- 백엔드 공통 서비스 [WorkDateService.java](file:///d:/work/java_aams_html_ver/src/main/java/com/kfp/aams/domain/common/service/WorkDateService.java)에서 일괄 조회:
```java
public String getWorkDateOrDefault(String corpGr) {
    String workDate = workDateMapper.getWorkDateByCorpGr(corpGr);
    if (workDate != null && !workDate.isBlank()) {
        return workDate.trim();
    }
    return LocalDate.now().toString();
}
```

### 4.2 회사 전환(`pane.onCorpGrChange`) 시 달력 갱신 흐름
1. 상단 툴바에서 회사 선택 변경 (`corpGr` 변경)
2. `pane.onCorpGrChange(corpGr)` 트리거
3. 기준일자 조회 API (`GET /api/daily/.../workdate?corpGr=...`) 비동기 호출
4. 달력 `<input id="filterYmd">`의 value를 새 작업일자로 갱신하고 `change` 이벤트 디스패치
5. 리포트 또는 그리드 자동 재조회 수행
