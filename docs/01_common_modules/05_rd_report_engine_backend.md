# 05. Crownix RD 레포트 변환 엔진 (`RdReportService.java`)

## 1. 개요 및 설계 목적

[RdReportService.java](file:///d:/work/java_aams_html_ver/src/main/java/com/kfp/aams/domain/daily/service/RdReportService.java)는 AAMS 시스템에서 기존 파워빌더 OLE 기반의 Crownix Report(`.mrd`)를 **웹 브라우저 환경에서 플러그인 없이 무설치로 열람 및 다운로드할 수 있도록 지원하는 핵심 서버사이드 변환 엔진**입니다.

---

## 2. 핵심 아키텍처 및 특징

```
[클라이언트 브라우저 (iframe / 다운로드)]
               │
               ▼
[Controller: /preview or /export]
               │
               ▼
┌─────────────────────────────────────────────────────────────┐
│                      RdReportService                        │
│                                                             │
│  1. resolveCorpGr(): 파라미터 누락 시 쿠키에서 회사코드 자동 복원   │
│  2. getTemplatePath(): classpath:/rd/*.mrd 로컬 임시 캐싱    │
│  3. getRdClassLoader(): lib/*.jar 격리 URLClassLoader 로드    │
│  4. ServerSideRD 인스턴스 생성 & 라이선스 적용               │
│  5. FileOpen(mrdPath, param)                                │
│     -> param: /rzoom [120] /rmessageboxshow [0] /rv ...     │
│  6. 포맷 변환: SaveAsPdfFile / SaveAsXlsxFile / Word / Hwp   │
└─────────────────────────────────────────────────────────────┘
               │
               ▼
[바이너리 스트림 반환: inline (PDF) or attachment (Excel/Word/...)]
```

### 2.1 독립 URLClassLoader를 통한 JAR 격리 구동
- Crownix Report 엔진(`javard.jar`, `poi-*.jar`, `pdfbox-*.jar` 등 28개 라이브러리)은 Spring Boot 내장 의존성과 버전 충돌을 일으킬 수 있습니다.
- 이를 방지하기 위해 `getRdClassLoader()`에서 `URLClassLoader`를 별도로 생성하여 시스템 클래스로더와 완전히 격리된 환경에서 Crownix API를 리플렉션(Reflection)으로 구동합니다.

### 2.2 클래스패스 내장 MRD 파일 자동 추출 및 캐싱
- 서버 배포 시 외부 절대경로 의존성을 제거하기 위해 모든 `.mrd` 파일은 `src/main/resources/rd/`에 내장됩니다.
- 런타임 시 `getTemplatePath(mrdName)`가 클래스패스에서 읽어 임시 디렉터리(`java.io.tmpdir/aams_rd_templates/`)로 복사 후 경로를 제공하며 `ConcurrentHashMap`으로 캐싱하여 파일 I/O를 최소화합니다.

---

## 3. 회사코드(`corpGr`) 자동 해결 메커니즘 (`resolveCorpGr`)

개발지침 규칙 1(하드코딩 배제) 및 쿠키 기반 사용자 세션 규격에 따라, 호출 측에서 `corpGr` 파라미터를 넘기지 않더라도 요청 쿠키와 인증 컨텍스트에서 안전하게 자동 추출합니다:

```java
public String resolveCorpGr(String corpGr) {
    if (corpGr != null && !corpGr.isBlank()) {
        return corpGr.trim();
    }

    // 1. 현재 HTTP 요청의 쿠키에서 조회
    try {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs != null) {
            HttpServletRequest request = attrs.getRequest();
            if (request != null && request.getCookies() != null) {
                // savedCorpGr 쿠키 우선 조회
                for (Cookie c : request.getCookies()) {
                    if ("savedCorpGr".equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                        String val = URLDecoder.decode(c.getValue(), StandardCharsets.UTF_8).trim();
                        if (!val.isBlank()) return val;
                    }
                }
                // corpGr 쿠키 보조 조회
                for (Cookie c : request.getCookies()) {
                    if ("corpGr".equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                        String val = URLDecoder.decode(c.getValue(), StandardCharsets.UTF_8).trim();
                        if (!val.isBlank()) return val;
                    }
                }
            }
        }
    } catch (Exception e) {
        log.debug("쿠키에서 corpGr 추출 중 예외: {}", e.getMessage());
    }

    // 2. Spring SecurityContextHolder의 UserPrincipal에서 조회
    try {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UserPrincipal p) {
            if (p.getCorpGr() != null && !p.getCorpGr().isBlank()) {
                return p.getCorpGr().trim();
            }
        }
    } catch (Exception e) {
        log.debug("SecurityContext에서 corpGr 추출 중 예외: {}", e.getMessage());
    }

    return "";
}
```

---

## 4. 5대 표준 출력 포맷 및 변환 메서드 매핑

| 출력 포맷 | Content-Type | 확장자 | Crownix 내부 변환 메서드 |
|---|---|---|---|
| **PDF** (기본) | `application/pdf` | `.pdf` | `SaveAsPdfFile(outputPath)` |
| **Excel** | `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` | `.xlsx` | `SaveAsXlsxFile(outputPath)` |
| **Word** | `application/msword` | `.doc` | `SaveAsWordFile(outputPath)` |
| **PowerPoint** | `application/vnd.openxmlformats-officedocument.presentationml.presentation` | `.pptx` | `SaveAsPptxFile(outputPath)` |
| **한글(HWP)** | `application/x-hwp` | `.hwp` | `SaveAsHwpFile(outputPath)` |

---

## 5. 파라미터 조립 규격 (MRD 쿼리 연동)

Crownix Report의 SQL 쿼리는 전달된 `/rv` 파라미터 매핑을 참조합니다:
- **기본 옵션**: `/rzoom [120] /rmessageboxshow [0]` (기본 120% 확대, 알림창 숨김)
- **필수 매핑 파라미터**:
  - `corp_gr[...]` : 회사코드 (필수)
  - `ymd[...]` : 기준일자 (`yyyy.MM.dd` 형태)
  - `fund_cd[...]` : 펀드/계좌 코드
  - `series_gb[...]` 및 `gubun[...]` : 운용현황 구분값
