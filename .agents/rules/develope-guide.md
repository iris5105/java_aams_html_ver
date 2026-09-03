---
trigger: always_on
---

일반적인 화면 생성

1. corp_gr이나 다른 변수에 대해서 기본값을 주지않는다.
2. 하드코딩은 최대한 배제
3. srd 파일의 쿼리문을 사용할 때 해당 파일의 컬럼 데이터형을 DTO로 사용하고 쿼리문도 그대로 가져와서 변수 부분만 수정한다.
4. 단일 테이블에 대한 단순 조회는 qeuryDSL, 2개 이상의 테이블을 사용한다면 Mybatis형식으로 작성한다.
5. srd 파일에서 tab_order를 기반으로 table의 edit 설정을 설정한다.
6. srw에 f_dddwctl이 있는 항목이 있다면 srd파일의 해당 컬럼은 f_dddwctl.js에 올바른 parameter를 전달하여 해당 리스트를 보여주도록 하고, f_dddwctl로 넘어오는 드롭다운 리스트는 무조건 2칸(앞: 코드, 뒤: 코드명)으로 분할 구성하며, 화면(그리드 셀)에는 코드명이 나오게끔 처리한다.
7. Tabulator의 editable: false 반환 시 이벤트 전파 중단(stopPropagation)으로 행 선택이 누락되는 문제를 방지하기 위해, editable 콜백 내에서 직접 row.select() 및 상세 조회를 호출하고 컨테이너에 캡처링 리스너(addEventListener('click', ..., true))를 등록하여 행 선택 동작을 보장한다.
8. 화면 내에 [조회], [입력] 등의 액션 버튼을 중복 생성하지 않고, 상단 공통 툴바(fragments/tab_header :: toolbarButtons)를 사용하며 pane.onSearch, pane.onInput, pane.onSave, pane.onCorpGrChange 표준 계약 함수를 연결한다.
9. 마스터-디테일 구조에서 마스터 행 클릭 시 동일한 키값에 대해 불필요한 중복 API 호출(fetch)이 발생하지 않도록 마지막 조회 키 비교 가드를 둔다.
10. MDI 환경의 동적 탭 로딩 시 DOMContentLoaded와 document.readyState 중복 실행으로 인한 다중 초기화를 방지하기 위해 isInitialized 플래그를 사용하는 단일 진입점(startInit) 패턴을 적용한다.
11. 데이터의 수정 권한이 특정 사용자(의뢰자/작성자 등)에게만 부여되는 경우, 그리드 셀의 editable뿐만 아니라 상세 패널(textarea, input 등)에도 readOnly 및 배경색 잠금 처리를 동기화하여 양방향 보호를 적용한다.
12. 상단 필터바(fragments/filter/...) 사용 시 화면별로 라벨명을 변경해야 하는 경우, 프래그먼트 파라미터(예: `filter(label='LOAD기일')`, `filter(labelYmd='매매일자', labelDddw='거래구분')`), `th:with`, 또는 클라이언트 JS 함수(`setFilterLabel('filterYmd', 'LOAD기일')`)를 사용하여 동적으로 변경하도록 구성하며, 파라미터 미전달 시에는 표준 기본 라벨이 자동으로 표출되도록 한다.

예외상황

1. 그리드 테이블 관리 시 기존에 조회된 데이터는 수정을 막고 행 선택(Row Select 및 상세 조회)만 가능하게 하고, 신규로 추가된 행(isNew: true)에 대해서만 인라인 수정을 허용한다.

