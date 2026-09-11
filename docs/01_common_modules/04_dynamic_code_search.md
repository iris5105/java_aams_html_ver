# 04. 다이나믹 코드 검색 모달 (`dynamic_code_search.js`)

## 1. 개요 및 파워빌더 표준 규격 (그리드 내부 구성 1, 2)

파워빌더 SRD 파일에서 `p_xx_(컬럼명)` 형식의 버튼 컨트롤이 존재하는 경우, 이는 해당 컬럼에 대한 **다이나믹 코드 검색(Dynamic Code Search)** 버튼을 의미합니다.

### AAMS 웹 표준 변환 규격
1. 해당 컬럼 뒤에 타이틀이 없는 빈칸 컬럼을 생성하고 돋보기 아이콘 버튼(`<i class="fa-solid fa-magnifying-glass"></i>`)을 배치합니다.
2. 돋보기 버튼 클릭 또는 셀 더블클릭 시 공통 다이나믹 코드 검색 모달을 표출합니다.
3. 모달에서 검색 및 항목 선택 시, 해당 행(Row)의 연관 컬럼(예: 종목코드, 종목명, 단가 등)에 값이 자동으로 반영됩니다.

---

## 2. 모듈 구조 및 작동 흐름

```
[Tabulator 그리드 돋보기 클릭]
           │
           ▼
dynamic_code_search.js :: openCodeSearchModal(options)
           │
           ├─► 1. 모달 팝업 표출 (#dynamicCodeSearchModal)
           ├─► 2. API 호출: GET /api/common/code-search?type={searchType}&keyword={kw}
           ├─► 3. 결과 리스트 바인딩 (Tabulator 모달 그리드)
           └─► 4. 행 더블클릭 또는 Enter 입력 시:
                  - onSelect 콜백 실행
                  - 호출 원본 그리드 행(Row)의 컬럼 일괄 update
                  - 모달 자동 닫힘
```

---

## 3. Tabulator 컬럼 정의 표준 예시

```javascript
// 종목코드 컬럼
{ title: "종목코드", field: "itemCd", width: 100, hozAlign: "center" },

// 다이나믹 검색 버튼 컬럼 (p_xx_item_cd 규격)
{
    title: "",
    field: "btnSearchItem",
    width: 38,
    hozAlign: "center",
    headerSort: false,
    formatter: function() {
        return '<button type="button" class="btn btn-xs btn-outline-secondary py-0 px-1"><i class="fa-solid fa-magnifying-glass"></i></button>';
    },
    cellClick: function(e, cell) {
        e.stopPropagation();
        var row = cell.getRow();
        var currentData = row.getData();

        if (window.DynamicCodeSearch) {
            window.DynamicCodeSearch.open({
                searchType: "ITEM", // 종목 검색
                initialKeyword: currentData.itemCd || "",
                corpGr: currentData.corpGr,
                onSelect: function(selectedItem) {
                    // 선택된 데이터를 현재 행에 반영
                    row.update({
                        itemCd: selectedItem.code,
                        itemNm: selectedItem.name,
                        marketGb: selectedItem.marketGb
                    });
                }
            });
        }
    }
},

// 종목명 컬럼
{ title: "종목명", field: "itemNm", width: 160, hozAlign: "left" }
```

---

## 4. 백엔드 컨트롤러 및 서비스 연동

- **컨트롤러**: `DynamicCodeSearchController.java` (`/api/common/code-search`)
- **지원 코드 유형**:
  - `FUND`: 펀드/계좌 코드 검색
  - `ITEM`: 주식/채권 등 종목 코드 검색
  - `TR`: 거래처/중개사 코드 검색
  - `USER`: 사용자/담당자 검색
- 검색 시 회사그룹(`corpGr`)을 필터링하여 데이터 권한을 보장합니다.
