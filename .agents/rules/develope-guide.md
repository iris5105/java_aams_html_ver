---
trigger: always_on
---

일반적인 화면 생성

1. corp_gr이나 다른 변수에 대해서 기본값을 주지않는다.
2. 하드코딩은 최대한 배제
3. srd 파일의 쿼리문을 사용할 때 해당 파일의 컬럼 데이터형을 DTO로 사용하고 쿼리문도 그대로 가져와서 변수 부분만 수정한다.
4. 단일 테이블에 대한 단순 조회는 qeuryDSL, 2개 이상의 테이블을 사용한다면 Mybatis형식으로 작성한다.
5. srd 파일에서 tab_order를 기반으로 table의 edit 설정을 설정한다.
6. tabulator의 컬럼은 srd 파일의 각 컬럼의 text를 가져와서 순서대로 반영하다.
7. srw에 f_dddwctl이 있는 항목이 있다면 srd파일의 해당 컬럼은 f_dddwctl.js에 올바른 parameter를 전달하여 해당 리스트를 보여주도록 하고, f_dddwctl로 넘어오는 드롭다운 리스트는 무조건 2칸(앞: 코드, 뒤: 코드명)으로 분할 구성하며, 화면(그리드 셀)에는 코드명이 나오게끔 처리한다.
8. **테이블 행 선택(Row Select) 및 마스터-디테일 연동 표준 규격:**
   - Tabulator 그리드 생성 시 편집 가능 셀(input, list 드롭다운 등)의 이벤트 전파 중단(stopPropagation) 및 비편집 셀 클릭 시에도 안정적인 단일 행 선택과 연동을 보장하기 위해 `common.js`의 `setupTabulatorRowSelection(grid, syncDetailFunc)`을 연결한다.
   - 마스터-디테일 구조(또는 상세 패널/서브 그리드 연동 화면)에서는 다음의 **삼중 안전망(Triple Fallback)**을 표준 계약으로 일관되게 적용한다:
     ```javascript
     // 1) 전역 헬퍼 연결 (캡처링/버블링 단일 이벤트 바인딩)
     setupTabulatorRowSelection(gridMaster, function(row, data) {
         syncDetail(row, data);
     });
     // 2) rowClick 이벤트 안전망
     gridMaster.on("rowClick", function(e, row) {
         syncDetail(row, row ? row.getData() : null);
     });
     // 3) rowSelectionChanged 이벤트 안전망
     gridMaster.on("rowSelectionChanged", function(data, rows) {
         if (rows && rows.length > 0) {
             syncDetail(rows[0], rows[0].getData());
         }
     });
     ```
   - 상세 연동 함수(`syncDetail`)는 행의 데이터 객체(`masterRowData`)를 인자로 받아 `corpGr` 및 키값을 안전하게 추출하며, 동일한 키값에 대한 불필요한 중복 API 호출을 방지하는 가드(`lastLoadedMasterKey === currentKey`)를 반드시 둔다:
     ```javascript
     let lastLoadedMasterKey = null;
     function syncDetail(row, masterRowData) {
         if (!row) return;
         if (!row.isSelected || !row.isSelected()) {
             row.select();
         }
         var data = masterRowData || (row.getData ? row.getData() : null);
         if (!data) return;
         var currentKey = (data.corpGr || "") + "_" + (data.mainKey || "");
         if (lastLoadedMasterKey === currentKey) return;
         lastLoadedMasterKey = currentKey;
         // 하위 상세 그리드 조회 또는 패널 바인딩 호출
         loadDetailGrid(data);
     }
     ```
   - 인라인 편집 셀의 경우 컬럼 설정에 `cellClick: aamsCellEdit`를 지정하여 셀 편집 진입 전 선행 행 선택을 보장한다.
   - 데이터 조회 후(또는 초기 로드 시) 데이터가 존재할 경우 첫 번째 행을 자동 선택(`rows[0].select()`)하고 연계 상세 정보를 즉시 동기화 표출한다 (규칙 15 연계).
   - 단일 그리드 화면에서도 행 선택 시 활성화 표시를 위해 `setupTabulatorRowSelection(grid)`를 적용한다.
9. 화면 내에 [조회], [입력] 등의 액션 버튼을 중복 생성하지 않고, 상단 공통 툴바(fragments/tab_header :: toolbarButtons)를 사용하며 pane.onSearch, pane.onInput, pane.onSave, pane.onCorpGrChange 표준 계약 함수를 연결한다.
10. 마스터-디테일 구조에서 마스터 행 클릭 시 동일한 키값에 대해 불필요한 중복 API 호출(fetch)이 발생하지 않도록 마지막 조회 키 비교 가드를 둔다.
11. MDI 환경의 동적 탭 로딩 시 DOMContentLoaded와 document.readyState 중복 실행으로 인한 다중 초기화를 방지하기 위해 isInitialized 플래그를 사용하는 단일 진입점(startInit) 패턴을 적용한다.
12. 데이터의 수정 권한이 특정 사용자(의뢰자/작성자 등)에게만 부여되는 경우, 그리드 셀의 editable뿐만 아니라 상세 패널(textarea, input 등)에도 readOnly 및 배경색 잠금 처리를 동기화하여 양방향 보호를 적용한다.
13. 상단 필터바(fragments/filter/...) 사용 시 화면별로 라벨명을 변경해야 하는 경우, 프래그먼트 파라미터(예: `filter(label='LOAD기일')`, `filter(labelYmd='매매일자', labelDddw='거래구분')`), `th:with`, 또는 클라이언트 JS 함수(`setFilterLabel('filterYmd', 'LOAD기일')`)를 사용하여 동적으로 변경하도록 구성하며, 파라미터 미전달 시에는 표준 기본 라벨이 자동으로 표출되도록 한다.
14. 상단 필터 프래그먼트(fragments/filter/...) 사용 시, 필터 영역과 화면 전용 서브 버튼(예: 체결등록, NEW체결, 평잔재계산 등)이 공존할 때 배경색 단절이 발생하지 않도록 전체 영역을 `<div class="filter-bar">`로 감싸고 좌측 필터는 `<div class="filter-left">`, 우측 액션 버튼은 `<div class="filter-actions">`로 구조화하여 통일된 .filter-bar 배경색(#f1f5f9) 및 하단 테두리가 전폭(100%)에 걸쳐 매끄럽게 적용되도록 한다.
15. 데이터 조회(fetch) 후 또는 초기 데이터 바인딩 시 마스터 그리드(또는 단일 그리드)에 데이터가 존재할 경우 제일 첫 번째 행을 기본으로 선택(row.select())하여 상세 정보 및 연계 패널(디테일 그리드, 메모 등)이 자동으로 표출되도록 처리한다.
16. srw파일에서 dw_c.ue_getdate 이벤트가 존재한다면 하이라이트 모드로 넘겨주고 dw_c.getdate 이벤트가 없다면 순정상태의 달력으로 표시하게해줘
17. 상단 필터바(filter-bar) 구성 시, 필터 영역을 임의로 직접 작성하지 않고 항상 참조하는 srw 파일의 dw_c 컨트롤이 사용하는 데이터윈도우 객체(dataobject, 예: dc_ymd, dc_ymd_dddw, dc_xx_ymd 등)를 확인한 후, `templates/fragments/filter/` 디렉토리 내에서 동일한 파일명의 공통 프래그먼트(`th:replace="~{fragments/filter/{dataobject} :: filter(...)}"`)를 찾아 연동하여 공통 필터 컴포넌트를 일관되게 재사용한다.

예외상황

1. 그리드 테이블 관리 시 기존에 조회된 데이터는 수정을 막고 행 선택(Row Select 및 상세 조회)만 가능하게 하고, 신규로 추가된 행(isNew: true)에 대해서만 인라인 수정을 허용한다.

반응형 화면 규격 (브레이크포인트)

1. 태블릿-L (width <= 1415px): top_header의 대분류 메뉴가 사라지고 side_menu에 통합되어 트리 폴더 형식으로 보여진다.
2. 태블릿-S / 모바일 (width <= 876px): 해당 사이즈 이하부터 모바일 버전 형식으로 변경된다. (예: 마스터-상세/보고서 분할 화면의 경우 우측 상세 영역이 숨겨지고 마스터 그리드가 100% 전폭으로 표출되며, 행 선택 시 상세 내용이 팝업 모달로 표출된다. 또한 tab-content-container 내부의 액션 버튼들은 텍스트가 사라지고 아이콘만 표출되어 툴바 공간을 절약한다. 단, DDDW 드롭다운 선택 컴포넌트(`.dddw-select-btn`)의 경우 사용자가 선택한 명칭/텍스트와 화살표가 온전히 표출되어야 한다.)

그리드 내부 구성

1. SRD 파일에서 p_xx_(컬럼명) 가 있다면 이는 다이나믹 서치 버튼이다.
2. 해당 컬럼은 p_xx_(컬럼명)에서의 컬럼의 뒤에 타이틀이 없는 빈칸을 만들고 그곳에 돋보기 버튼을 눌러서 해당 컬럼에 대한 다이나믹서치(코드검색,모달)를 적용시켜준다.
3. SRD 파일에서 p_dd_(컬럼명) 가 있다면 이는 달력 팝업버튼이다.
4. p_dd_(컬럼명)의 컬럼의 뒤에 빈칸을 만들고 해당 칸의 달력을 눌렀을 때 날자선택 팝업이 뜬다.

그리드 컬럼 데이터 정렬 기준 (Tabulator hozAlign)
1. dto의 데이터의 형식 구분은 .srd 파일의 각 컬럼별 데이터 타입을 따른다.
2. 각 컬럼별 align과 format도 .srd 파일의 각 컬럼별 format을 따른다.

달력(calendar)
1. .srw 파일에서 dw_c에 ftymd(시작일~종료일)가 들어있다면 calendar는 Range 모드(`AamsCalendar.initRange`, `AamsCalendar.toggleRange`)로 한다.
2. .srw 파일에서 dw_c에 ue_getdate event에 스크립트가 작성되어 있다면 하이라이트 모드로 한다.
3. 그 외의 경우에는 일반 aams_calendar(단일 날짜)를 사용한다.
4. 달력 기본값(작업일자/기준일자) 설정:
   - 파워빌더 .srw 파일의 `wue_lastopen` 이벤트(또는 open 이벤트)에서 `dw_c.object.ymd[1]` 등에 설정되는 기준일자 로직을 확인하여 동일하게 적용한다.
   - 예: `corp_gr = '2402'`이면 `SZX0AA.JUNYONG_YMD`(전용일자), 그 외의 경우는 `SZX0AA.HYUN_YMD`(현재 작업일자, `idt_workdate`)를 기본값으로 사용한다.
   - 화면 진입 시 백엔드(Controller)에서 `corp_gr`에 해당하는 기준일자를 조회하여 모델(`ymd` 등)로 전달하고 초기 달력 input 및 `AamsCalendar`에 기본값으로 바인딩한다.
   - 회사그룹(`corpGr`)이 변경될 때(`pane.onCorpGrChange`)에도 해당 회사의 기준일자를 API로 조회하여 달력 input의 값을 자동으로 갱신하고, 새로고침(`pane.onRefresh`) 시에도 초기 기준일자로 복원되도록 한다.

자동 조회
1. 파워빌더의 .srw 파일에 `boolean eb_direct_retrieve = true` 구문이 존재한다면 해당 화면은 진입할 때 자동으로 조회를 실행(`pane.onSearch()`).
2. `boolean eb_direct_retrieve = true` 구문이 없다면(기본값 false 또는 구문 없음) 조회 버튼을 눌렀을 때만 조회되도록 한다.

공통버튼
1. 새로고침 버튼은 수정사항이나 조회한 내용을 초기화하여 화면에서 데이터를 조회하기 전인 초기화 상태로 되돌린다.

리포트 뷰어 (MRD VIEWER / u_rd)

1. 파워빌더 원본 분석 및 식별:
   - 파워빌더 `.srw` 파일에서 `u_rd ole_rd`(또는 `u_rd` 계열 OLE 커스텀 컨트롤)가 배치되어 있고, `ole_rd.uf_fileopen('rd_파일명.mrd', ...)`을 호출하여 리포트를 로드하는 화면은 HTML5 기반 MRD 리포트 뷰어 표준 규격(`RdReportService` + `<iframe>` 미리보기 및 파일 내보내기)으로 구현한다.
   - 파워빌더에서 `ole_rd.uf_fileopen`에 전달하는 파라미터(`corp_gr`, `ymd`, `fund_cd`, `work_gb` 등)와 대상 `.mrd` 파일명, 조건부 파일 전환 로직(`_2402.mrd` -> `_common.mrd` 등)을 정확히 분석하여 서비스에 반영한다.

2. 백엔드 서비스 및 API 컨트롤러 규격 (`RdReportService`):
   - `RdReportService`: Crownix Report 엔진(`lib/*.jar`)을 격리된 `URLClassLoader`로 구동하며, 클래스패스 내장 리소스(`classpath:/rd/*.mrd`)를 기반으로 PDF 스트림 생성 및 다양한 포맷 변환을 처리하는 공통 서비스.
   - **미리보기 API (`GET /api/.../preview`)**:
     - `RdReportService`를 통해 생성된 PDF 바이너리 데이터를 브라우저 인라인 스트림(`Content-Type: application/pdf`, `Content-Disposition: inline; filename="..."`)으로 반환하여 우측 패널의 `<iframe>`에 바인딩한다.
   - **내보내기 API (`GET /api/.../export`)**:
     - 5가지 표준 포맷(`pdf`, `excel`/`xlsx`, `word`/`doc`, `ppt`/`pptx`, `hwp`)에 대해 첨부 다운로드(`Content-Disposition: attachment; filename="..."`) 스트림으로 반환한다.
   - **원장생성 정합성 체크 API (선택)**:
     - 파워빌더 `ole_rd::ue_retrieve` 등에서 특정 회사(`corp_gr == '2402'`)에 대해 원장생성 여부를 사전 체크하는 로직이 있을 경우, 사전 검증 API(`/api/.../check-ledger`)를 호출하여 경고 메시지 토스트를 표출한다.

3. 화면 레이아웃 및 뷰어 UI 구성:
   - **마스터-리포트 분할 레이아웃 (`layout-split`)**:
     - 좌측: 마스터 그리드(펀드/계좌/그룹 목록 등, 예: `d_szm0ia.srd`, `d_ja010j1.srd`)
     - 우측: 리포트 미리보기 패널 (`.right-pane` 또는 `.report-card`)
     - 우측 상단 헤더: 리포트 타이틀, 조회 상태 라벨(`조회일자: yyyy-mm-dd` 등), 멀티 포맷 내보내기 버튼 그룹(PDF, Excel, Word, PPT, HWP) 및 새 창 열기 버튼(`btnOpenNewWindow`).
     - 우측 본문: 리포트 로딩 인디케이터/스피너 (`#preview-loading`, `#report-loading`) 및 `<iframe>` (`#report-frame`, `src="about:blank"`).
   - **단일 리포트 화면 (마스터 그리드가 없는 경우, 예: `w_ja020k`)**:
     - 상단 필터바 조건에 따라 리포트 패널이 화면 전체를 차지하며, 상단 툴바의 [조회] 또는 필터 변경 시 리포트를 직접 로드한다.
   - **반응형 모바일 규격 (width <= 876px)**:
     - 태블릿-S/모바일 사이즈에서는 우측 리포트 패널을 `display: none` 처리하고 좌측 마스터 그리드를 100% 전폭으로 표출한다.
     - 그리드 행 클릭 시 모바일 전용 전체화면 모달(`.ja010h1-modal-backdrop` 등)을 띄워 내부 모달 `<iframe>`을 통해 리포트를 표출한다.

4. 클라이언트 스크립트 연동 표준 규격:
   - **그리드 행 선택 연동 (규칙 8, 10, 15 연계)**:
     - 마스터 그리드에서 행 선택 시(`syncDetail`), 선택된 행의 데이터(`corpGr`, `ymd`, `fundCd` 등)를 기반으로 `currentKey`를 생성하고 중복 호출 방지 가드(`lastLoadedMasterKey === currentKey`)를 적용한다.
     - 데이터 조회 후 첫 번째 행 자동 선택(`rows[0].select()`)을 통해 초기 리포트 미리보기가 자동 표출되도록 한다 (규칙 15 연계).
     - 조회된 데이터가 없을 경우 `iframe.src = "about:blank"` 및 상태 라벨을 "조회 결과 없음"으로 초기화한다.
   - **미리보기 URL 생성 및 로딩 인디케이터 처리**:
     - 브라우저 캐싱으로 인한 화면 미갱신을 방지하기 위해 타임스탬프(`&t=" + new Date().getTime()`) 파라미터를 반드시 추가한다.
     - URL 바인딩 전 로딩 엘리먼트를 표출(`loadingEl.style.display = 'block'`)하고, `iframe.onload = function() { loadingEl.style.display = 'none'; }` 이벤트에서 로딩을 숨긴다.
   - **내보내기 버튼 이벤트 바인딩**:
     - 내보내기 클릭 시 현재 선택된 행 데이터(`currentSelectedRowData`)가 없는 경우 사용자 알림(alert/showToast) 후 중단한다.
     - `window.location.href = exportUrl`을 통해 브라우저 다운로드를 실행한다.
   - **새 창 열기 (`btnOpenNewWindow`)**:
     - `window.open(previewUrl, "_blank")`를 호출하여 리포트를 별도 탭/새 창에서 크게 볼 수 있도록 지원한다.
   - **상단 툴바 표준 계약 (규칙 9)**:
     - `pane.onSearch` / `pane.onRetrieve`: 마스터 그리드(또는 리포트) 재조회 호출.
     - `pane.onCorpGrChange`: 회사그룹 변경 시 관련 필터 및 리포트 상태 초기화 후 재조회.
     - `pane.onRefresh`: `iframe.src = "about:blank"`, 상태 텍스트 초기화 및 그리드 데이터 클리어로 화면 진입 초기 상태로 복원.




