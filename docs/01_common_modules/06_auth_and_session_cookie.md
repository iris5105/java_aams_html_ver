# AAMS 인증 토큰(JWT) 및 쿠키(Cookie) 가이드

AAMS 웹 시스템은 JWT(JSON Web Token) 및 HTTP 쿠키를 활용하여 무상태(Stateless) 인증 및 화면 설정 상태를 관리합니다.  
본 문서는 **액세스 토큰과 쿠키에 저장된 정보 명세**와 **백엔드(Spring Boot) 및 프론트엔드(JavaScript)에서 각 값을 불러오는 방법**을 설명합니다.

---

## 1. 액세스 토큰 (JWT `accessToken`) 저장 정보

`accessToken`은 **HttpOnly 쿠키** 및 브라우저 **`localStorage`**에 발급되는 서명된 JWT 토큰입니다.  
사용자 로그인 시 DB(`FW_USER_MST` + `SZX0AA`)에서 조회된 정보가 JWT Payload Claims로 포함됩니다.

### 토큰 내부 클레임 (Claims) 명세

| 클레임 키 (Claim Key) | 명칭 | 타입 | 설명 및 저장 값 예시 |
|---|---|---|---|
| `sub` | 사용자 ID | String | JWT 표준 주체 식별자 (예: `"admin"`, `"user01"`) |
| `userId` | 사용자 ID | String | `FW_USER_MST.USER_ID` 로그인 계정 / 사원번호 |
| `userNm` | 사용자 성명 | String | 사용자 이름 (예: `"홍길동"`) |
| `corpGr` | 회사그룹 코드 | String | 현재 작업/접속 중인 회사코드 (예: `"2402"`, `"2200"`) |
| `companyName` | 회사명 | String | 소속 회사 명칭 (예: `"OO자산운용"`) |
| `deptCd` | 부서 코드 | String | 소속 부서코드 (미지정 시 기본값 `"A420"`) |
| `deptNm` | 부서명 | String | 소속 부서 명칭 (예: `"운용팀"`, `"전산팀"`) |
| `inYmd` | 입사일자 | String | 입사일자 (`YYYYMMDD`) |
| `outYmd` | 퇴사일자 | String | 퇴사일자 (재직 중 기본값 `"99991231"`) |
| `adminYn` | 시스템 관리자 여부 | String | `"Y"` 또는 `"N"` (회사 전환 등 관리 기능 권한 제어) |
| `managerYn` | 책임자 / 매니저 여부 | String | `"Y"` 또는 `"N"` |
| `watchmanYn` | 감시 / 조회 권한 여부 | String | `"Y"` 또는 `"N"` |
| `bookmarkStart` | 북마크 시작 여부 | String | 시작화면 설정 플래그 |
| `lastConnect` | 최종 접속 일시 | String | `YYYY-MM-DD HH:mm:ss` |
| `encEMail` | 이메일 계정 | String | 등록된 이메일 주소 |
| `hyunYmd` | 회사 마스터 기준일자 | String | DB `SZX0AA.HYUN_YMD` 컬럼 원본값 |
| `customerGr` | 고객 그룹 코드 | String | 고객사/그룹 분류 코드 |
| `iat` | 토큰 발행 시각 | Long | UNIX 타임스탬프 (초) |
| `exp` | 토큰 만료 시각 | Long | 발행 시점으로부터 **1시간 (3,600초)** |

---

## 2. 브라우저 쿠키 (HTTP Cookies) 저장 정보

사용자 로그인 성공 시 백엔드(`AuthController`)와 프론트엔드(`w_login_aams.html`)에서 브라우저 쿠키(`document.cookie`)로 설정하는 항목 목록입니다.

| 쿠키명 (Cookie Name) | HttpOnly | 유효 기간 (Max-Age) | 용도 및 저장 내용 |
|---|:---:|:---:|---|
| **`accessToken`** | **O** | 1시간 (3,600s) | • **API 요청 인가용 JWT 토큰**<br>• XSS 공격 방지를 위해 HttpOnly로 보호됨 |
| **`refreshToken`** | **O** | 7일 (604,800s) | • 토큰 갱신 및 자동 로그인 세션 유지용 리프레시 토큰 |
| **`userId`** | X | 30일 (2,592,000s) | • **로그인한 사용자의 계정 ID / 사원번호** (`FW_USER_MST.USER_ID`) |
| **`user_id`** | X | 30일 (2,592,000s) | • `userId`의 스네이크 케이스 호환 쿠키 |
| **`userNm`** | X | 30일 (2,592,000s) | • **로그인한 사용자의 성명** (URL 인코딩되어 저장) |
| **`userName`** | X | 30일 (2,592,000s) | • `userNm`의 카멜 케이스 호환 쿠키 |
| **`savedCorpGr`** | X | 30일 (2,592,000s) | • **현재 선택/작업 중인 회사그룹 코드** (예: `"2402"`)<br>• 화면 조회 및 RD 리포트 등의 기본 파라미터로 사용 |
| **`workDate`** | X | 30일 (2,592,000s) | • **비즈니스 규칙이 반영된 실제 화면 작업기준일자** (예: `"2026-09-14"`)<br>• 달력 초기값 및 일자 조회 조건의 기본값 |
| **`savedEmail`** | X | 30일 (2,592,000s) | • 로그인 화면의 아이디 기억하기(자동완성)용 값 |
| **`JSESSIONID`** | **O** | 브라우저 세션 | • 톰캣(Spring Boot) 내장 서블릿 세션 ID |

> 💡 **참고 (`hyunYmd` vs `workDate` 차이점)**:
> * **`hyunYmd`**: DB 회사 마스터 테이블(`SZX0AA.HYUN_YMD`)의 순수 현재일자 컬럼값입니다.
> * **`workDate`**: 파워빌더 레거시 명세에 따라 `corp_gr = '2402'`인 경우 전용일자(`NVL(junyong_ymd, hyun_ymd)`), 그 외는 `hyun_ymd`를 계산하여 산출된 **"실제 화면 작업기준일자"**입니다.

---

## 3. 백엔드 (Spring Boot)에서 값 불러오기

백엔드 컨트롤러 및 서비스에서는 요청 상황에 따라 아래의 3가지 방식으로 값을 조회합니다.

### 방법 1: `@AuthenticationPrincipal` 사용 (가장 권장)
Spring Security 필터에서 검증된 `accessToken`의 클레임 정보를 담고 있는 `UserPrincipal` 객체를 파라미터로 바로 주입받습니다.

```java
import com.kfp.aams.security.UserPrincipal;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleApiController {

    @GetMapping("/api/sample/user-info")
    public ResponseEntity<?> getUserInfo(@AuthenticationPrincipal UserPrincipal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // 주요 값 접근
        String userId   = principal.getUserId();      // 사용자 아이디
        String userNm   = principal.getUserNm();      // 사용자 성명
        String corpGr   = principal.getCorpGr();      // 현재 회사코드 (예: "2402")
        String deptCd   = principal.getDeptCd();      // 부서코드
        String deptNm   = principal.getDeptNm();      // 부서명
        String adminYn  = principal.getAdminYn();     // 관리자 여부 ("Y"/"N")
        String hyunYmd  = principal.getHyunYmd();     // 기준일자
        
        // 전체 UserDto 객체 접근
        UserDto userDto = principal.getUserDto();

        return ResponseEntity.ok(Map.of("userId", userId, "userNm", userNm, "corpGr", corpGr));
    }
}
```

### 방법 2: `@CookieValue` 어노테이션 사용 (특정 쿠키 직접 주입)
화면 뷰 컨트롤러(`@Controller`)나 특정 쿠키값만 간편하게 주입받아야 할 때 사용합니다.

```java
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

@Controller
public class SampleViewController {

    @GetMapping("/views/DailyAdvisory/sample")
    public String sampleView(
            @CookieValue(name = "userId", required = false) String userId,
            @CookieValue(name = "savedCorpGr", required = false) String corpGr,
            @CookieValue(name = "workDate", required = false) String workDate,
            Model model) {

        model.addAttribute("userId", userId);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);

        return "views/DailyAdvisory/sample";
    }
}
```

### 방법 3: `HttpServletRequest`를 통한 쿠키 순회
동적으로 여러 쿠키를 확인하거나 Fallback 처리가 필요할 때 사용합니다.

```java
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;

public String getCookieValue(HttpServletRequest request, String cookieName) {
    if (request.getCookies() != null) {
        for (Cookie c : request.getCookies()) {
            if (cookieName.equals(c.getName())) {
                return c.getValue();
            }
        }
    }
    return null;
}
```

---

## 4. 프론트엔드 (JavaScript)에서 값 불러오기

브라우저 환경에서는 쿠키의 종류(`HttpOnly` 여부) 및 저장 위치에 따라 아래와 같이 처리합니다.

### 방법 1: `document.cookie` 유틸 함수 사용 (일반 쿠키 조회)
`userId`, `savedCorpGr`, `workDate`, `userNm` 등 일반 쿠키는 자바스크립트로 직접 파싱하여 읽을 수 있습니다.

```javascript
// 1) 쿠키 조회 공통 헬퍼 함수
function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) {
        return decodeURIComponent(parts.pop().split(';').shift());
    }
    return null;
}

// 2) 실제 값 추출 예시
const userId   = getCookie('userId') || getCookie('user_id') || '';        // "admin"
const userNm   = getCookie('userNm') || getCookie('userName') || '';       // "홍길동"
const corpGr   = getCookie('savedCorpGr') || getCookie('corpGr') || '';    // "2402"
const workDate = getCookie('workDate') || getCookie('hyunYmd') || '';      // "2026-09-14"
```

### 방법 2: 정규표현식(RegExp) 인라인 추출 방식
기존 AAMS 프로젝트의 화면 템플릿([w_ja010h1.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/DailyAdvisory/w_ja010h1.html), [w_ja991a.html](file:///d:/work/java_aams_html_ver/src/main/resources/templates/views/DailyAdvisory/w_ja991a.html))에서 널리 사용하는 패턴입니다:

```javascript
// 회사코드 추출
const matchCorp = document.cookie.match(/(?:^|;\s*)savedCorpGr=([^;]*)/) || document.cookie.match(/(?:^|;\s*)corpGr=([^;]*)/);
const currentCorpGr = matchCorp ? decodeURIComponent(matchCorp[1]) : "";

// 작업기준일자 추출
const matchWork = document.cookie.match(/(?:^|;\s*)workDate=([^;]*)/) || document.cookie.match(/(?:^|;\s*)hyunYmd=([^;]*)/);
const currentWorkDate = matchWork ? decodeURIComponent(matchWork[1]) : "";

// 사용자 ID 추출
const matchUser = document.cookie.match(/(?:^|;\s*)userId=([^;]*)/) || document.cookie.match(/(?:^|;\s*)user_id=([^;]*)/);
const currentUserId = matchUser ? decodeURIComponent(matchUser[1]) : "";
```

### 방법 3: `localStorage`에서 불러오기
로그인 성공 시 `w_login_aams.html`에서 `localStorage`에도 주요 세션 정보를 동기화해두므로, 아래와 같이 직관적으로 읽을 수도 있습니다:

```javascript
const accessToken  = localStorage.getItem('accessToken');
const refreshToken = localStorage.getItem('refreshToken');
const userId       = localStorage.getItem('userId');
const userNm       = localStorage.getItem('userNm');
const corpGr       = localStorage.getItem('corpGr');
```

### 방법 4: `accessToken` / `refreshToken` (HttpOnly 쿠키) 동작 원리
* **보안 특성**: `accessToken`과 `refreshToken`은 XSS 스크립트 탈취를 방지하기 위해 **`HttpOnly`** 플래그가 설정되어 있습니다. 따라서 JavaScript `document.cookie`로는 읽을 수 없습니다.
* **API 호출 시 자동 전송**: 클라이언트에서 `fetch('/api/...')` 또는 AJAX 요청을 보낼 때 **브라우저가 자동으로 `Cookie: accessToken=...` 헤더를 백엔드로 전송**하므로, 프론트엔드에서 수동으로 Authorization 헤더를 조작할 필요가 없습니다.
* **토큰 잔여시간 확인**: 화면에서 토큰 만료 전 경고나 연장이 필요할 경우 백엔드 공통 API인 `GET /api/auth/token-status`를 호출하여 잔여 시간(`remainingSeconds`)을 확인합니다.

---

## 5. 세션 및 쿠키 생명주기 관리

* **토큰 연장 (`POST /api/auth/extend-token`)**:  
  상단 툴바 토큰 모달에서 비밀번호 검증 후 1시간 연장 시 `accessToken` 쿠키의 만료시간이 즉시 1시간 추가 갱신됩니다.
* **회사 전환 (`POST /api/auth/switch-company`)**:  
  관리자가 회사 드롭다운을 변경하면 새 회사가 반영된 `accessToken`, `savedCorpGr`, `workDate`, `userId` 쿠키가 서버에서 갱신 발급되며, 클라이언트의 `pane.onCorpGrChange(newCorpGr)`가 호출되어 열려 있는 모든 화면 데이터가 새 회사 기준으로 새로고침됩니다.
* **로그아웃 (`POST /api/auth/logout`)**:  
  `accessToken`, `refreshToken`, `workDate`, `userId`, `user_id` 쿠키의 `max-age`를 `0`으로 설정하여 브라우저에서 즉시 제거합니다.
