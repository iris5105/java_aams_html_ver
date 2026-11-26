---
name: crud-generation
description: AAMS 표준 아키텍처(Controller, Service, JPA Entity/Repository 또는 MyBatis Mapper, Tabulator CUD 상태 관리)에 맞춰 CRUD 기능을 구현할 때 사용하는 기술 가이드
---

# CRUD 구현 스킬 (Spring Boot + JPA/MyBatis + Tabulator)

PowerBuilder 화면의 조회·입력·수정·삭제·저장 흐름을 AAMS 백엔드/프론트엔드 표준에 맞춰 구현하는 절차입니다.

---

## 1. 영속성 계층 선택 기준 (01-backend-standard.md)

| 작업 유형 | 선택 기술 | 핵심 규칙 |
| :--- | :--- | :--- |
| **단일 테이블 단순 조회 / CUD** | Spring Data JPA / `EntityManager` / QueryDSL | 기존 `@Entity`·`@Repository` 재사용(중복 생성 금지), 레거시 테이블명은 `@Table(name = "\"TABLE\"")` |
| **2개 이상 테이블 JOIN / 집계 / 오라클 함수 / SP** | MyBatis XML (`src/main/resources/mapper/`) | `resultType` + `map-underscore-to-camel-case=true` 기본 사용 |

---

## 2. 백엔드 CRUD 구현 패턴

1. **Controller (`@RestController` / `@Controller`)**
   - 뷰 반환: `GET /views/{domain}/{viewName}` -> `WorkDateService.getWorkDateOrDefault(corpGr)`로 `initialYmd`, `ymd` 주입 (임의 `LocalDate.now()` 및 `corpGr` fallback 금지)
   - 조회 API: `GET /api/{domain}/{screenId}/{resource}` -> `List<Dto>` 반환
   - 저장 API: `POST /api/{domain}/{screenId}/save` -> `@RequestBody List<Dto>` 수신 후 `Map<String, Object>` (`success`, `message`) 반환
2. **Service (`@Transactional`)**
   - 수신된 DTO 리스트를 `rowStatus` (`C`/`U`/`D`) 또는 `isNew`/`isUpdated`/`isDeleted` 플래그로 분기 처리
   - **등록(`C`)**: 엔티티 생성 후 `em.persist(entity)` 또는 `repository.save(entity)`
   - **수정(`U`)**: `em.find(Entity.class, id)`로 영속 엔티티 조회 후 해당 화면 필드만 setter로 변경하여 **Dirty Checking** 적용 (`em.merge()`로 타 화면 컬럼이 `null`로 덮어씌워지는 것 방지)
   - **삭제(`D`)**: `em.find(Entity.class, id)` 후 `em.remove(entity)`

---

## 3. 프론트엔드 Tabulator CUD 연동

1. **행 추가 (`pane.onInput`)**
   - `isNew: true`, `rowStatus: "C"` 기본값 세팅
   - Summary 행이 있는 그리드라면 `grid.addRow(newRow, true, summaryRow)`로 합계 행 직전에 삽입 후 `recalcSummaryRow()` 호출
2. **셀 수정 (`cellEdited`)**
   - 기존 행(`!d.isNew`) 수정 시 `d.isUpdated = true`, `d.rowStatus = "U"` 갱신
   - 필요 시 `recalcSummaryRow()` 호출
3. **행 삭제 (`pane.onDelete` 또는 서브 삭제 버튼)**
   - `isSummaryRow`인 행은 삭제 차단
   - 신규 행(`isNew: true`)은 그리드에서 즉시 `row.delete()`
   - 기존 행은 `isDeleted: true`, `rowStatus: "D"` 마킹 또는 삭제 대상 목록에 보관 후 저장 시 전송
4. **일괄 저장 (`pane.onSave`)**
   - `grid.getData()`에서 `isSummaryRow`를 제외한 뒤 `isNew || isUpdated || isDeleted` 행만 필터링해 `POST /api/{domain}/{screenId}/save` 호출
   - 저장 성공 시 `showToast(...)` 표출 및 마스터 재조회 (조회 전 `lastLoadedMasterKey = null` 초기화)

---

## 4. 검증 체크리스트

- `corpGr` 등 필수 파라미터에 임의 기본값 fallback이 없는가?
- 서버 API에 `@PreAuthorize` 또는 `CompanyGroupAuthorizationInterceptor` / `ProgramActionAuthorizationInterceptor` 인가 검증이 누락되지 않았는가?
- 타 화면과 공유하는 테이블 수정 시 다른 컬럼이 `null`로 초기화되지 않는가?
