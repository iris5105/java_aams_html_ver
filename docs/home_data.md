# home_data.js (홈 패널 데이터 페칭 & 탭 스크립트 모듈)

## 1. 개요 (Overview)
`home_data.js`는 **AAMS 메인 홈 화면(`w_home5.html`)**의 6개 메인 패널 카드 데이터(공모기본정보, 수요예측참여내역, 시스템 개발 및 수정의뢰 현황, 당일거래현황, 당월결산계좌LIST/당월이자)를 비동기 REST API로 조회하여 테이블 DOM에 바인딩하고 서브 탭을 제어하는 **데이터 핸들링 모듈**입니다.

- **파일 위치**: [`src/main/resources/static/js/home_data.js`](file:///d:/work/java_full_auto_aams/src/main/resources/static/js/home_data.js)
- **의존성 (Dependencies)**: [`common.js`](file:///d:/work/java_full_auto_aams/src/main/resources/static/js/common.js) (`safeFetchJson`, `formatDate`)

---

## 2. 주요 패널별 함수 및 REST API 매핑

| Card 패널명 | 담당 함수명 | REST API 엔드포인트 | 대상 테이블 타겟 ID |
| :--- | :--- | :--- | :--- |
| **Card 1: 공모기본정보** | `loadPublicStocks()` | `GET /api/home/public-stocks` | `#tbody-public-stocks` |
| **Card 2: 수요예측참여내역** | `loadSubscriptions()` | `GET /api/home/subscriptions` | `#tbody-subscriptions` |
| **Card 3: 시스템 개발/수정의뢰** | `loadProposals()` | `GET /api/home/proposals` | `#tbody-proposals` |
| **Card 4: 당일거래현황** | `loadDayTr()` | `GET /api/home/day-tr` | `#tbody-daytr` |
| **Card 5-1: 당월결산계좌LIST** | `loadGyulAccounts()` | `GET /api/home/gyul-accounts` | `#tbody-gyul` |
| **Card 5-2: 당월이자(만기)** | `loadRateChanges()` | `GET /api/home/rate-changes` | `#tbody-rate` |
| **Card 5 탭 전환** | `switchSubTab(tabId, el)` | - | `#gyulTab` / `#rateTab` |

---

## 3. 작동 원리 (Working Principle)

### (1) 데이터 비동기 조회 및 안전한 예외 처리 (`safeFetchJson`)
```javascript
function loadPublicStocks() {
    safeFetchJson('/api/home/public-stocks')
        .then(data => {
            if (!data) return;
            const tbody = document.getElementById('tbody-public-stocks');
            if (!tbody) return;
            if (Array.isArray(data) && data.length > 0) {
                tbody.innerHTML = data.map(item => `
                    <tr>
                        <td class="text-center">${item.balhCo || '-'}</td>
                        <td>${item.jmNm || '-'}</td>
                        <td class="text-center date-col">${formatDate(item.ymd)}</td>
                        ...
                    </tr>
                `).join('');
            } else {
                tbody.innerHTML = `<tr><td colspan="11" class="text-center" style="color: #94a3b8; padding: 12px;">데이터 없음</td></tr>`;
            }
        });
}
```
1. `common.js`의 `safeFetchJson()` 공통 유틸리티를 호출하여 비동기 HTTP GET 요청을 보냅니다.
2. 만약 로그인 세션 만료(401 Unauthorized 또는 EXPIRED 상태) 시 자동으로 `/login?expired=true`로 리다이렉트 처리됩니다.
3. 응답받은 JSON 데이터 배열을 검증(Null/Empty 체크)하여 데이터가 존재하는 경우 템플릿 리터럴로 `<tr>` 행을 포맷팅하여 `innerHTML`에 대입하고, 데이터가 없을 경우 깔끔한 노데이터 테이블 행을 출력합니다.

### (2) 숫자 및 날짜 포맷팅
- **날짜 포맷터 (`formatDate`)**: `YYYYMMDD` 8자리 숫자를 `YYYY-MM-DD` 형태 또는 ISO 일시 규격으로 동적 변환합니다.
- **천 단위 콤마 (`toLocaleString`)**: 수량 및 금액 수치 데이터에 천 단위 콤마를 자동으로 부여하여 가독성을 높입니다.

### (3) 서브 탭 전환 제어 (`switchSubTab`)
- Card 5 패널 상단의 '당월결산계좌LIST'와 '당월이자(만기)' 탭 클릭 시 `switchSubTab('gyulTab', this)` 또는 `switchSubTab('rateTab', this)`가 실행됩니다.
- 클릭된 탭 탭 버튼에 `.active` 클래스를 주고, 해당 탭 영역만 `display: block`으로 보이고 나머지는 `display: none` 처리한 후 필요에 따라 `loadRateChanges()` / `loadGyulAccounts()` 데이터를 지연 호출(Lazy Load)합니다.
