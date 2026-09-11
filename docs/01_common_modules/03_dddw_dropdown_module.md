# 03. 드롭다운 선택 모듈 (`f_dddwctl.js`, `DddwService`)

## 1. 개요 및 파워빌더 표준 규격 (규칙 7)

파워빌더 시스템에서는 `f_dddwctl` 함수를 통해 드롭다운 데이터윈도우(DDDW)를 화면 컨트롤에 바인딩하여 사용했습니다.
웹 전환 시스템에서는 [f_dddwctl.js](file:///d:/work/java_aams_html_ver/src/main/resources/static/js/f_dddwctl.js)와 백엔드 [DddwService.java](file:///d:/work/java_aams_html_ver/src/main/java/com/kfp/aams/domain/common/service/DddwService.java)를 통해 다음의 **AAMS 표준 드롭다운 UI 규격**을 만족하도록 구현되었습니다:

1. **드롭다운 펼침 목록은 무조건 2칸 분할 표출**:
   - 좌측: 코드 (고정폭, 예: `1110`)
   - 우측: 코드명 / 명칭 (가변폭, 예: `고위험고수익`)
2. **선택 시 표출 규격**:
   - 사용자가 항목을 선택했을 때 상단 닫힌 버튼(셀렉트 박스 표면)에는 **코드명(텍스트)만 표출**되어야 함.
3. **정렬 규격**:
   - 백엔드와 프론트엔드 모두에서 **앞의 코드 값을 기준으로 무조건 오름차순(ASC) 정렬**하여 반환 및 표출.

---

## 2. 모듈 아키텍처 및 동작 방식

```
[클라이언트 HTML <select>] 
       │
       ▼
f_dddwctl.get2ColItemFormatter(selectEl, options, config)
       │
       ├─► 1. 기존 <select>를 display: none으로 숨김 (값 보존)
       ├─► 2. 커스텀 .dddw-select-custom 컨테이너 생성
       ├─► 3. 상단 버튼(.dddw-select-btn): 선택된 코드명 표출
       └─► 4. 플로팅 드롭다운(.dddw-dropdown-menu):
              [헤더]: 코드 | 명칭
              [아이템 리스트]: <li><span class="code">코드</span><span class="name">코드명</span></li>
```

---

## 3. 백엔드 코드 정렬 보장 (`DddwService.java`)

모든 DDDW 조회 결과는 클라이언트에 반환되기 전 코드(`cd` / `code`) 기준으로 자동 정렬됩니다:

```java
// DddwService.java
public List<DddwDto> getDddwList(String dddwName, String corpGr) {
    List<DddwDto> list = dddwMapper.selectDddwList(dddwName, corpGr);
    if (list != null && !list.isEmpty()) {
        // 코드 오름차순 정렬
        list.sort(Comparator.comparing(
            item -> (item.getCd() != null ? item.getCd() : ""),
            Comparator.nullsFirst(String.CASE_INSENSITIVE_ORDER)
        ));
    }
    return list;
}
```

---

## 4. 프론트엔드 연동 표준 코드 예시

```javascript
function initDddw() {
    var dddwSelect = pane.querySelector('#filterDddw') || pane.querySelector('select[name="dddw"]');
    if (!dddwSelect) return;

    var options = [
        { code: "1110", name: "고위험고수익" },
        { code: "1120", name: "채권형" },
        { code: "1130", name: "혼합/기타" }
    ];

    // f_dddwctl 2칸 분할 컴포넌트 적용
    if (window.f_dddwctl && typeof window.f_dddwctl.get2ColItemFormatter === 'function') {
        window.f_dddwctl.get2ColItemFormatter(dddwSelect, options, {
            codeTitle: "코드",
            nameTitle: "자료구분",
            defaultVal: "1110",
            onSelect: function (code, name) {
                // 선택 시 자동 호출
                console.log("선택된 코드:", code, "코드명:", name);
                loadReport(); // 그리드 또는 리포트 재조회
            }
        });
    }
}
```

---

## 5. Tabulator 그리드 인라인 셀 에디터 연동

그리드 내부 셀에서 DDDW 드롭다운을 편집할 때는 `Tabulator` 컬럼 정의의 `editor` 및 `formatter`로 연동됩니다:
- `formatter`: 셀 데이터(`data.code`)에 해당하는 `name`을 찾아 화면에는 코드명만 표출.
- `editor`: 클릭 시 2칸 분할 드롭다운 플로팅 패널을 띄우고, 선택 시 셀 값을 코드로 저장.
