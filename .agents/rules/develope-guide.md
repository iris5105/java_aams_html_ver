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
8. Tabulator의 editable: false 반환 시 이벤트 전파 중단(stopPropagation)으로 행 선택이 누락되는 문제를 방지하기 위해, editable 콜백 내에서 직접 row.select() 및 상세 조회를 호출하고 컨테이너에 캡처링 리스너(addEventListener('click', ..., true))를 등록하여 행 선택 동작을 보장한다.
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
