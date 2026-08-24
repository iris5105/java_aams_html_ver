# home_chart.js (차트 제어 스크립트 모듈)

## 1. 개요 (Overview)
`home_chart.js`는 **AAMS 메인 홈 화면(`w_home5.html`)**의 **순자산 및 계좌현황 듀얼 축 차트(Dual-Axis Chart)** 초기화, 비동기 차트 데이터 API 연동, 그리고 관리자 차트 설정 모달과의 양방향 동기화를 전담하는 **클라이언트 스크립트 모듈**입니다.

- **파일 위치**: [`src/main/resources/static/js/home_chart.js`](file:///d:/work/java_full_auto_aams/src/main/resources/static/js/home_chart.js)
- **의존성 (Dependencies)**: Chart.js Library (`cdn.jsdelivr.net/npm/chart.js`)
- **연동 REST API**: `GET /api/home/chart-data`
- **연동 HTML 모달**: [`chart_modal.html`](file:///d:/work/java_full_auto_aams/docs/chart_modal.md)

---

## 2. 주요 함수 목록 및 역할

| 함수명 | 역할 및 설명 |
| :--- | :--- |
| `initDualChart()` | Canvas Canvas(`canvas#dualChart`)에 Chart.js 인스턴스를 2개의 Y축(Left Y1: 순자산, Right Y2: 계좌수) 구조로 생성/초기화 |
| `loadDualChart()` | REST API `/api/home/chart-data`를 호출하여 시계열 차트 데이터를 수신하고 차트를 업데이트 |
| `openChartConfigModal()` | 현재 차트 인스턴스의 설정값(유형, 색상, 점선/실선, 선두께, Y축 범위를 모달 폼에 바인딩하고 팝업을 표시 |
| `closeChartConfigModal()` | 차트 설정 모달 팝업 숨김 (`display: none`) |
| `applyChartConfig()` | 모달 폼에서 수정한 설정값을 읽어 차트 데이터셋 및 스케일 옵션에 적용 후 `update()` 재렌더링 |

---

## 3. 작동 원리 (Working Principle)

### (1) 듀얼 축 차트 생성 및 초기화 (`initDualChart`)
```js
dualChartInstance = new Chart(ctx, {
    type: 'bar',
    data: {
        datasets: [
            { label: '순자산(억)', type: 'line', yAxisID: 'y1', ... },
            { label: '계좌수', type: 'bar', yAxisID: 'y2', ... }
        ]
    },
    options: {
        scales: {
            y1: { type: 'linear', position: 'left', title: { text: '순자산(억)' } },
            y2: { type: 'linear', position: 'right', title: { text: '계좌수' } }
        }
    }
});
```
- 하나의 Canvas 영역 안에 Left Axis(`y1`)는 꺾은선(Line) 그래프로 순자산(억)을 표현하고, Right Axis(`y2`)는 막대(Bar) 그래프로 계좌수를 동시에 다중 축으로 시각화합니다.

### (2) 비동기 데이터 갱신 프로세스 (`loadDualChart`)
1. `/api/home/chart-data`로 `fetch` 요청 전송.
2. 데이터가 수신되면 `cv2Chtnm`(라벨), `cv2Chtvalue001`(순자산), `cv2Chtvalue002`(계좌수) 배열을 추출.
3. 데이터가 존재할 경우 `#dualChartNoData` 메시지 요소를 숨기고 `dualChartInstance.data` 배열을 업데이트 후 `dualChartInstance.update()`를 호출하여 애니메이션과 함께 차트를 갱신.
4. 데이터가 존재하지 않거나 에러 발생 시 `#dualChartNoData` 노데이터 안내 문구를 노출.

### (3) 모달과 차트 옵션의 실시간 반영 (`applyChartConfig`)
- 관리자가 모달 폼에서 지정한 값(`cfgDs0Type`, `cfgDs0Color`, `cfgDs0Dash`, `cfgDs0Width`, `cfgY1Min`, `cfgY1Max`, `cfgY2Min`, `cfgY2Max`)을 읽습니다.
- `dualChartInstance.options.scales.y1.min / max` 등을 유동적으로 추가/삭제함으로써 사용자 지정 범위 설정과 자동(Auto Scale) 모드를 간편하게 전환합니다.
