# 06. 인증 및 세션/쿠키 아키텍처 (`AuthController`, `JwtProvider`)

## 1. 개요

AAMS 웹 시스템은 무상태(Stateless) JWT 기반 인증 아키텍처를 채택하고 있으며, 브라우저 환경에서의 보안성과 편의성을 위해 **쿠키(Cookie) 기반의 인증 및 환경 설정 관리**를 수행합니다.

---

## 2. 주요 쿠키 명세 및 역할

| 쿠키명 (Cookie Name) | 수명 (Max-Age) | HttpOnly | 목적 및 사용처 |
|---|---|---|---|
| `accessToken` | 1시간 (3,600s) | **True** | API 인가용 JWT 토큰 (사용자 ID, 회사코드, 관리자 여부 등 포함) |
| `refreshToken` | 7일 (604,800s) | **True** | Access Token 만료 시 자동 재발급을 위한 토큰 |
| `savedCorpGr` | 30일 | False | 현재 활성화된 회사코드 (로그인 로고 및 각 화면 자동 조회 기준) |
| `workDate` | 30일 | False | 현재 회사의 기준 작업일자 (`SZX0AA.JUNYONG_YMD` / `HYUN_YMD`) |
| `userNm` / `userName` | 30일 | False | 로그인 사용자 성명 (클라이언트 상단 헤더 표출용) |
| `savedEmail` | 30일 | False | 로그인 화면 아이디 기억용 |

---

## 3. 로그인 인증 시퀀스 (`/api/auth/login`)

```
[사용자 ID / PW 입력] 
         │
         ▼
AuthController.login()
         │
         ├─► 1. FW_USER_MST 테이블 사용자 조회 (UserQueryDslRepository)
         ├─► 2. 회사코드(corpGr) 확정
         │      - 관리자(adminYn == 'Y'): 기존 savedCorpGr 쿠키가 있으면 유지
         │      - 일반사용자: DB에 등록된 corpGr 강제 지정
         ├─► 3. JWT Access Token / Refresh Token 생성 (JwtProvider)
         ├─► 4. WorkDateService.getWorkDateOrDefault(corpGr) 호출하여 작업일자 조회
         ├─► 5. 쿠키 발급:
         │      - accessToken, refreshToken (HttpOnly)
         │      - savedCorpGr, workDate, userNm (Client 접근 가능)
         └─► 6. 응답 DTO 반환 후 메인 화면(/)으로 리다이렉트
```

---

## 4. 회사 전환 아키텍처 (`/api/auth/switch-company`)

시스템 관리자 권한(`adminYn == 'Y'`)을 가진 사용자는 로그아웃 없이 상단 헤더의 드롭다운을 통해 즉시 소속 회사를 변경할 수 있습니다:

1. **클라이언트 요청**: `POST /api/auth/switch-company` (`{"corpGr": "2402"}`)
2. **권한 검증**: `UserPrincipal.getAdminYn() == 'Y'` 검증
3. **토큰 및 세션 재생성**:
   - 새 `corpGr`이 반영된 신규 `accessToken` 및 `refreshToken` 재발행
   - Spring Security 컨텍스트(`SecurityContextHolder`) 갱신
4. **쿠키 즉시 동기화**:
   - `savedCorpGr` 쿠키를 새 회사코드로 갱신
   - 새 회사의 작업일자를 조회하여 `workDate` 쿠키 갱신
5. **클라이언트 동작**:
   - `pane.onCorpGrChange(newCorpGr)` 호출을 통해 열려 있는 모든 MDI 탭의 기준일자와 데이터가 새 회사를 기준으로 자동 새로고침됩니다.
