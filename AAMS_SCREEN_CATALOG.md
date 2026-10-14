# AAMS 전체 화면/프로그램 표준 카탈로그 (Screen Catalog Reference)

> 본 문서는 AAMS 시스템의 **대메뉴 > 소분류 > 화면번호, 화면이름, 화면 파일명** 전체 매핑 참조 명세서입니다.
> 향후 화면 개발 시 사용자가 **화면번호**(`00162`), **화면이름**(`USPM 운용지시 PUT배분작업`), 또는 **화면 파일명**(`w_ja032e_put`) 중 어떤 단서로 요청하더라도 본 카탈로그를 조회하여 파워빌더 소스 매핑 및 웹 생성 경로를 자동 식별합니다.

## 📌 화면 검색 및 자동 식별 규격

| 구분 | 설명 | 예시 |
| :--- | :--- | :--- |
| **화면번호 (PGM_NO)** | 5자리 고유 프로그램 번호 | `00155`, `00162`, `00307` |
| **화면 파일명 (PGM_ID)** | 파워빌더 윈도우 객체명 (.srw) | `W_JA032A`, `W_JA032E_PUT`, `W_JA010A` |
| **화면이름 (PGM_NM)** | 메뉴 마스터 공식 한글 화면명 | `USPM 종목 기준정보등록`, `USPM 운용지시 PUT배분작업` |
| **웹 도메인 (Domain)** | 백엔드 패키지 경로 (`com.kfp.aams.domain.{domain}`) | `usportfoliomodel`, `dailyadvisory`, `assetmanagement` 등 |
| **뷰 템플릿 (ViewHtml)** | 프론트엔드 Thymeleaf 파일 경로 | `templates/views/{domain}/{pgmId.lower()}.html` |

---

## 📋 1. 대메뉴 > 소분류 계층별 화면 목록 (총 253개 프로그램)

### 📁 사무관리 > US Portfolio Model > USPM (25개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00155` | **USPM 종목 기준정보등록** | `W_JA032A` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032a.html` | `pb_recource/JA032/w_ja032a.srw` |
| `00157` | **기준정보 종목 일별현황** | `W_JA032B_DD` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032b_dd.html` | `pb_recource/JA032/w_ja032b_dd.srw` |
| `00158` | **USPM 변동성 추이** | `W_JA032C` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032c.html` | `pb_recource/JA032/w_ja032c.srw` |
| `00159` | **환율등록** | `W_SYX1HY` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_syx1hy.html` | `pb_recource/JA999/w_syx1hy.srw` |
| `00160` | **API 자료요청 현황** | `W_JA032D` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032d.html` | `pb_recource/JA032/w_ja032d.srw` |
| `00162` | **USPM 운용지시 PUT배분작업** | `W_JA032E_PUT` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032e_put.html` | `pb_recource/JA032/w_ja032e_put.srw` |
| `00165` | **API PARAMETER 관리** | `W_API_PARAMS` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_api_params.html` | `pb_recource/JA999/w_api_params.srw` |
| `00169` | **CRON** | `W_CRON_Q` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_cron_q.html` | `pb_recource/JA999/w_cron_q.srw` |
| `00170` | **해외주식 매매(권리)등록** | `W_JA035B` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja035b.html` | `pb_recource/JA035/w_ja035b.srw` |
| `00171` | **해외 파생 PORT 매매관리** | `W_JA035B2` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja035b2.html` | `pb_recource/JA035/w_ja035b2.srw` |
| `00172` | **자산현황** | `W_JA032K` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032k.html` | `pb_recource/JA032/w_ja032k.srw` |
| `00174` | **원장생성** | `W_RUN` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_run.html` | `pb_recource/JA010/w_run.srw` |
| `00175` | **API_FOSTKCODE 조회** | `W_FOSTKCODE` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_fostkcode.html` | `pb_recource/JA999/w_fostkcode.srw` |
| `00176` | **외화증권 매매내역** | `W_JA036H` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja036h.html` | `pb_recource/JA036/w_ja036h.srw` |
| `00179` | **종목별 위험값** | `W_JA032M` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032m.html` | `pb_recource/JA032/w_ja032m.srw` |
| `00185` | **손익현황(원장)** | `W_JA050A` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja050a.html` | `pb_recource/JA050/w_ja050a.srw` |
| `00186` | **손익 상세현황(분개장)** | `W_JA050C` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja050c.html` | `pb_recource/JA050/w_ja050c.srw` |
| `00187` | **기준정보 펀드 일별현황** | `W_JA032B_FUND` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032b_fund.html` | `pb_recource/JA032/w_ja032b_fund.srw` |
| `00188` | **기준정보 옵션위험값 일별현황** | `W_JA032B_OPT` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032b_opt.html` | `pb_recource/JA032/w_ja032b_opt.srw` |
| `00189` | **파생 환매수 운용지시** | `W_JA032O` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032o.html` | `pb_recource/JA032/w_ja032o.srw` |
| `00190` | **포트별 옵션수익실현현황** | `W_JA032N` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032n.html` | `pb_recource/JA032/w_ja032n.srw` |
| `00191` | **관심종목 변동성 추이** | `W_JA032B_YA` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032b_ya.html` | `pb_recource/JA032/w_ja032b_ya.srw` |
| `00192` | **포트/종목별 종가대비 행사가격** | `W_JA033E` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja033e.html` | `pb_recource/JA033/w_ja033e.srw` |
| `00193` | **기준정보 옵션종목 일별현항** | `W_JA032P` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032p.html` | `pb_recource/JA032/w_ja032p.srw` |
| `00196` | **USPM 운용지시 CALL배분작업** | `W_JA032E_CALL` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032e_call.html` | `pb_recource/JA032/w_ja032e_call.srw` |

### 📁 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 (9개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00163` | **해외 주식종목정보** | `W_JA032F` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032f.html` | `pb_recource/JA032/w_ja032f.srw` |
| `00164` | **해외 파생종목정보** | `W_JA032G` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032g.html` | `pb_recource/JA032/w_ja032g.srw` |
| `00166` | **해외 업종/지수/환율(frgncode)** | `W_JA032H` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032h.html` | `pb_recource/JA032/w_ja032h.srw` |
| `00168` | **해외주식종가/업종지수 등록** | `W_JA032J` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032j.html` | `pb_recource/JA032/w_ja032j.srw` |
| `00177` | **해외파생 생성종목 현황** | `W_SRS_CD` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_srs_cd.html` | `pb_recource/JA999/w_srs_cd.srw` |
| `00182` | **KRX 주식 선물/옵션 종목** | `W_JA033A` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja033a.html` | `pb_recource/JA033/w_ja033a.srw` |
| `00183` | **KRX 지수 선물/옵션 종목** | `W_JA033B` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja033b.html` | `pb_recource/JA033/w_ja033b.srw` |
| `00184` | **KRX 통화 선물/옵션 종목** | `W_JA033C` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja033c.html` | `pb_recource/JA033/w_ja033c.srw` |
| `00195` | **KRX 주식종목정보** | `W_JA032F_KRX` | `usportfoliomodel` | `templates/views/usportfoliomodel/w_ja032f_krx.html` | `pb_recource/JA032/w_ja032f_krx.srw` |

### 📁 사무관리 > 공모청약(권리) > 공모청약(권리)관리 (19개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00065` | **채권 펀드/종목별 시가등록** | `W_JA020H` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020h.html` | `pb_recource/JA020/w_ja020h.srw` |
| `00066` | **현금 펀드/종목별 시가등록** | `W_JA020J` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020j.html` | `pb_recource/JA020/w_ja020j.srw` |
| `00068` | **수요예측 참여자료** | `W_JA020Q` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020q.html` | `pb_recource/JA020/w_ja020q.srw` |
| `00070` | **금투협보고자료** | `W_JA020M` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020m.html` | `pb_recource/JA020/w_ja020m.srw` |
| `00078` | **채권비율보고** | `W_JA020P` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020p.html` | `pb_recource/JA020/w_ja020p.srw` |
| `00079` | **유가증권 취득액 관리** | `W_JA020R` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020r.html` | `pb_recource/JA020/w_ja020r.srw` |
| `00305` | **유(무)상증자 공시등록** | `W_JA021F` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021f.html` | `pb_recource/JA021/w_ja021f.srw` |
| `00308` | **합병.분할.병합.감자.소각공시등록** | `W_JA021G` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021g.html` | `pb_recource/JA021/w_ja021g.srw` |
| `00342` | **권리 주식(대금) 수령 등록** | `W_JA020C` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020c.html` | `pb_recource/JA020/w_ja020c.srw` |
| `00343` | **합병.분할.병합.감자.소각 내역서** | `W_JA020G` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020g.html` | `pb_recource/JA020/w_ja020g.srw` |
| `00353` | **공모청약 종목 및 배정등록** | `W_JA020A` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020a.html` | `pb_recource/JA020/w_ja020a.srw` |
| `00398` | **배당 명세표 출력** | `W_JA021D` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021d.html` | `pb_recource/JA021/w_ja021d.srw` |
| `00432` | **(자문사별)예상배당 공시등록** | `W_JA021A` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021a.html` | `pb_recource/JA021/w_ja021a.srw` |
| `00434` | **상장공시.코드변경 등록** | `W_JA021H` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021h.html` | `pb_recource/JA021/w_ja021h.srw` |
| `00767` | **권리처리내역 조회** | `W_JA020E` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020e.html` | `pb_recource/JA020/w_ja020e.srw` |
| `00848` | **채권 특이채 권리행사 처리** | `W_JA021E` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021e.html` | `pb_recource/JA021/w_ja021e.srw` |
| `00909` | **중간배당 및 확정등록** | `W_JA021C` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021c.html` | `pb_recource/JA021/w_ja021c.srw` |
| `00941` | **발행기관별 보유현황(권리조회)** | `W_JA020F` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020f.html` | `pb_recource/JA020/w_ja020f.srw` |
| `01056` | **(자문사별)예상배당 확정등록** | `W_JA021B` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja021b.html` | `pb_recource/JA021/w_ja021b.srw` |

### 📁 사무관리 > 보고서 > 보고서 (4개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00088` | **운용역정보 및 규모** | `W_JA060D` | `reportmanagement` | `templates/views/reportmanagement/w_ja060d.html` | `pb_recource/JA060/w_ja060d.srw` |
| `00382` | **운용보고서 생성** | `W_JA060B` | `reportmanagement` | `templates/views/reportmanagement/w_ja060b.html` | `pb_recource/JA060/w_ja060b.srw` |
| `01007` | **분기 운용보고서** | `W_JA060C` | `reportmanagement` | `templates/views/reportmanagement/w_ja060c.html` | `pb_recource/JA060/w_ja060c.srw` |
| `01010` | **운용보고서 시장전망,계획 입력** | `W_JA060A` | `reportmanagement` | `templates/views/reportmanagement/w_ja060a.html` | `pb_recource/JA060/w_ja060a.srw` |

### 📁 사무관리 > 손익차등 > 손익차등 (13개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00031` | **집합투자증권 명세부 출력** | `W_UJNR200` | `differentialprofit` | `templates/views/differentialprofit/w_ujnr200.html` | `pb_recource/JA040/w_ujnr200.srw` |
| `00032` | **손익차등 종목별 상세현황** | `W_SKKU051` | `differentialprofit` | `templates/views/differentialprofit/w_skku051.html` | `pb_recource/JA040/w_skku051.srw` |
| `00042` | **펀드 기본정보 등록** | `W_SZZE170` | `differentialprofit` | `templates/views/differentialprofit/w_szze170.html` | `pb_recource/JA040/w_szze170.srw` |
| `00043` | **손익차등 우선배당율 관리** | `W_JA040A` | `differentialprofit` | `templates/views/differentialprofit/w_ja040a.html` | `pb_recource/JA040/w_ja040a.srw` |
| `00044` | **가격대장 출력** | `W_UZNR041` | `differentialprofit` | `templates/views/differentialprofit/w_uznr041.html` | `pb_recource/JA040/w_uznr041.srw` |
| `00045` | **손익차등 가격대장 출력** | `W_JA040D` | `differentialprofit` | `templates/views/differentialprofit/w_ja040d.html` | `pb_recource/JA040/w_ja040d.srw` |
| `00100` | **손익차등 수익배분 상세현항** | `W_SONIK_FLOW` | `differentialprofit` | `templates/views/differentialprofit/w_sonik_flow.html` | `pb_recource/JA040/w_sonik_flow.srw` |
| `01042` | **분개장 등록** | `W_SZZE370` | `differentialprofit` | `templates/views/differentialprofit/w_szze370.html` | `pb_recource/JA040/w_szze370.srw` |
| `01044` | **손익차등 분개장 출력** | `W_JA040C` | `differentialprofit` | `templates/views/differentialprofit/w_ja040c.html` | `pb_recource/JA040/w_ja040c.srw` |
| `01046` | **손익차등 일 예상손익 계산현황** | `W_SKKR056_MC` | `differentialprofit` | `templates/views/differentialprofit/w_skkr056_mc.html` | `pb_recource/JA040/w_skkr056_mc.srw` |
| `01049` | **분개장 출력** | `W_SKKR040` | `differentialprofit` | `templates/views/differentialprofit/w_skkr040.html` | `pb_recource/JA040/w_skkr040.srw` |
| `01050` | **손익차등 계산계정 점검** | `W_SKKR057` | `differentialprofit` | `templates/views/differentialprofit/w_skkr057.html` | `pb_recource/JA040/w_skkr057.srw` |
| `01051` | **손익차등 투자종목 관리** | `W_JA040B` | `differentialprofit` | `templates/views/differentialprofit/w_ja040b.html` | `pb_recource/JA040/w_ja040b.srw` |

### 📁 사무관리 > 시스템관리 > 일정 및 공지관리 (15개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00008` | **Dimension 관리** | `W_DIMENSION_MST` | `systemmanagement` | `templates/views/systemmanagement/w_dimension_mst.html` | `pb_recource/fcht4comm/w_dimension_mst.srw` |
| `00022` | **공지사항관리** | `FW_W_NOTICE_CONFIG` | `systemmanagement` | `templates/views/systemmanagement/fw_w_notice_config.html` | `pb_recource/fw_w_notice/fw_w_notice_config.srw` |
| `00023` | **전체공지등록** | `FW_W_NOTICE` | `systemmanagement` | `templates/views/systemmanagement/fw_w_notice.html` | `pb_recource/fw_w_notice/fw_w_notice.srw` |
| `00024` | **회사별공지등록** | `FW_W_NOTICE` | `systemmanagement` | `templates/views/systemmanagement/fw_w_notice.html` | `pb_recource/fw_w_notice/fw_w_notice.srw` |
| `00025` | **전체공지 확인내역** | `FW_W_NOTICE_CHECK` | `systemmanagement` | `templates/views/systemmanagement/fw_w_notice_check.html` | `pb_recource/fw_w_notice/fw_w_notice_check.srw` |
| `00026` | **회사별공지 확인내역** | `FW_W_NOTICE_CHECK` | `systemmanagement` | `templates/views/systemmanagement/fw_w_notice_check.html` | `pb_recource/fw_w_notice/fw_w_notice_check.srw` |
| `00027` | **달력관리** | `W_PLAN4CALENDAR` | `systemmanagement` | `templates/views/systemmanagement/w_plan4calendar.html` | `pb_recource/bzplan/w_plan4calendar.srw` |
| `00028` | **개인일정** | `W_PLANUSER` | `systemmanagement` | `templates/views/systemmanagement/w_planuser.html` | `pb_recource/bzplan/w_planuser.srw` |
| `00341` | **첨부파일관리** | `W_NOTICE_FILE` | `systemmanagement` | `templates/views/systemmanagement/w_notice_file.html` | `pb_recource/fw_w_notice/w_notice_file.srw` |
| `00840` | **디멘젼관리** | `FW_W_DIME1` | `systemmanagement` | `templates/views/systemmanagement/fw_w_dime1.html` | `pb_recource/DBA/fw_w_dime1.srw` |
| `00850` | **IT개선사항** | `FW_W_NOTICE` | `systemmanagement` | `templates/views/systemmanagement/fw_w_notice.html` | `pb_recource/fw_w_notice/fw_w_notice.srw` |
| `00851` | **IT개선사항 확인내역(현업)** | `FW_W_NOTICE_CHECK` | `systemmanagement` | `templates/views/systemmanagement/fw_w_notice_check.html` | `pb_recource/fw_w_notice/fw_w_notice_check.srw` |
| `00879` | **월별업무공지** | `W_MON2TASKLIIST` | `systemmanagement` | `templates/views/systemmanagement/w_mon2taskliist.html` | `pb_recource/bzplan/w_mon2taskliist.srw` |
| `00888` | **회사일정** | `W_PLAN4U` | `systemmanagement` | `templates/views/systemmanagement/w_plan4u.html` | `pb_recource/bzplan/w_plan4u.srw` |
| `00889` | **회사별 일정보기** | `W_MON2TASK` | `systemmanagement` | `templates/views/systemmanagement/w_mon2task.html` | `pb_recource/SYS/w_mon2task.srw` |

### 📁 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 (22개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00011` | **프로그램별 처리단계등록** | `W_JA990Z` | `codemanagement` | `templates/views/codemanagement/w_ja990z.html` | `pb_recource/JA990/w_ja990z.srw` |
| `00015` | **프로그램 기본정보** | `FW_W_PGM_MST` | `systemmanagement` | `templates/views/systemmanagement/fw_w_pgm_mst.html` | `pb_recource/fw_w_role/fw_w_pgm_mst.srw` |
| `00016` | **권한 멤버유형 등록** | `FW_W_ROLE_SETTING` | `systemmanagement` | `templates/views/systemmanagement/fw_w_role_setting.html` | `pb_recource/fw_w_role/fw_w_role_setting.srw` |
| `00017` | **권한별 멤버 및 프로그램 등록** | `FW_W_ROLE_ASSIGN` | `systemmanagement` | `templates/views/systemmanagement/fw_w_role_assign.html` | `pb_recource/fw_w_role/fw_w_role_assign.srw` |
| `00018` | **권한별 프로그램 버튼관리** | `FW_W_BTN_ASSIGN` | `systemmanagement` | `templates/views/systemmanagement/fw_w_btn_assign.html` | `pb_recource/fw_w_role/fw_w_btn_assign.srw` |
| `00019` | **프로그램별 버튼관리** | `FW_W_BTN_ROLE_ASSIGN` | `systemmanagement` | `templates/views/systemmanagement/fw_w_btn_role_assign.html` | `pb_recource/fw_w_role/fw_w_btn_role_assign.srw` |
| `00020` | **사용자별 프로그램별 권한조회** | `FW_W_ROLE_INFO_RET` | `systemmanagement` | `templates/views/systemmanagement/fw_w_role_info_ret.html` | `pb_recource/fw_w_role/fw_w_role_info_ret.srw` |
| `00021` | **프로그램사용자로그조회** | `FW_W_PGM_LOGS` | `systemmanagement` | `templates/views/systemmanagement/fw_w_pgm_logs.html` | `pb_recource/bzplan/fw_w_pgm_logs.srw` |
| `00029` | **소스버전관리(PBD)** | `W_PBDUPDATE` | `systemmanagement` | `templates/views/systemmanagement/w_pbdupdate.html` | `pb_recource/bzplan/w_pbdupdate.srw` |
| `00092` | **SZT0CK** | `W_SZT0CK` | `systemmanagement` | `templates/views/systemmanagement/w_szt0ck.html` | `pb_recource/JA999/w_szt0ck.srw` |
| `00093` | **원장생성 작업내역** | `W_JA999A` | `systemmanagement` | `templates/views/systemmanagement/w_ja999a.html` | `pb_recource/JA999/w_ja999a.srw` |
| `00094` | **프로그램 버젼관리** | `W_FW_VERSION_MANAGE` | `systemmanagement` | `templates/views/systemmanagement/w_fw_version_manage.html` | `pb_recource/SYS/w_fw_version_manage.srw` |
| `00095` | **시스템 이력관리** | `W_HISTORY` | `systemmanagement` | `templates/views/systemmanagement/w_history.html` | `pb_recource/DBA/w_history.srw` |
| `00096` | **시스템 이력관리 출력** | `W_HISTORY_PRT` | `systemmanagement` | `templates/views/systemmanagement/w_history_prt.html` | `pb_recource/DBA/w_history_prt.srw` |
| `00101` | **도움말 관리** | `W_WHLP00M_HELP_LIST` | `systemmanagement` | `templates/views/systemmanagement/w_whlp00m_help_list.html` | `pb_recource/SYS/w_whlp00m_help_list.srw` |
| `00107` | **시스템별 메뉴정렬** | `W_PGM_MST` | `systemmanagement` | `templates/views/systemmanagement/w_pgm_mst.html` | `pb_recource/SYS/w_pgm_mst.srw` |
| `00108` | **화면번호 등록** | `W_FW_OBJ_NO_ASSIGN` | `systemmanagement` | `templates/views/systemmanagement/w_fw_obj_no_assign.html` | `pb_recource/SYS/w_fw_obj_no_assign.srw` |
| `00302` | **로그검색(통합)** | `FW_W_LOG_VIEW1` | `systemmanagement` | `templates/views/systemmanagement/fw_w_log_view1.html` | `pb_recource/fw_w_role/fw_w_log_view1.srw` |
| `00501` | **테이블 LOG 조회** | `W_WLOG02T_LOG_LIST` | `systemmanagement` | `templates/views/systemmanagement/w_wlog02t_log_list.html` | `pb_recource/SYS/w_wlog02t_log_list.srw` |
| `00631` | **사용자 관리** | `W_FW_USER_MST` | `systemmanagement` | `templates/views/systemmanagement/w_fw_user_mst.html` | `pb_recource/SYS/w_fw_user_mst.srw` |
| `00820` | **LOG 테이블 관리** | `W_WLOG01M_LOG_TABLE` | `systemmanagement` | `templates/views/systemmanagement/w_wlog01m_log_table.html` | `pb_recource/SYS/w_wlog01m_log_table.srw` |
| `00965` | **등록 프로그램 현황** | `W_PGM_MST_ALL` | `systemmanagement` | `templates/views/systemmanagement/w_pgm_mst_all.html` | `pb_recource/SYS/w_pgm_mst_all.srw` |

### 📁 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 (8개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00098` | **외화 유동자산 종목등록** | `W_JA035A` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035a.html` | `pb_recource/JA035/w_ja035a.srw` |
| `00110` | **외화 주식배당관리** | `W_JA035D` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035d.html` | `pb_recource/JA035/w_ja035d.srw` |
| `00111` | **외화증권 권리관리** | `W_JA035E` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035e.html` | `pb_recource/JA035/w_ja035e.srw` |
| `00112` | **외화증권 코드변경** | `W_JA035F` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035f.html` | `pb_recource/JA035/w_ja035f.srw` |
| `00119` | **외화주식 권리주상장** | `W_JA035G` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035g.html` | `pb_recource/JA035/w_ja035g.srw` |
| `00140` | **해외(대출)채권 종목등록** | `W_JA036` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036.html` | `pb_recource/JA036/w_ja036.srw` |
| `00141` | **해외 파생/선물/옵션 종목등록** | `W_JA035` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035.html` | `pb_recource/JA035/w_ja035.srw` |
| `00148` | **해외 주식 종목등록** | `W_JA035R` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035r.html` | `pb_recource/JA035/w_ja035r.srw` |

### 📁 사무관리 > 외화자산운용 > 외화세금관리 (3개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00128` | **외화 납부세금 환급** | `W_JA036D` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036d.html` | `pb_recource/JA036/w_ja036d.srw` |
| `00129` | **기간별 외화 선납원천세 내역** | `W_JA036A` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036a.html` | `pb_recource/JA036/w_ja036a.srw` |
| `00139` | **외국납부세액 환급신청** | `W_JA036I` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036i.html` | `pb_recource/JA036/w_ja036i.srw` |

### 📁 사무관리 > 외화자산운용 > 외화자산운용 (24개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00104` | **외화증권 매매등록** | `W_JA035B` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035b.html` | `pb_recource/JA035/w_ja035b.srw` |
| `00105` | **외화 환전 및 현금거래 등록** | `W_JA035C` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035c.html` | `pb_recource/JA035/w_ja035c.srw` |
| `00120` | **외화 NOTE이자수령** | `W_JA035H` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035h.html` | `pb_recource/JA035/w_ja035h.srw` |
| `00121` | **수도결제 등록** | `W_JA035J` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035j.html` | `pb_recource/JA035/w_ja035j.srw` |
| `00122` | **외화수익증권 매매등록** | `W_JA035K` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035k.html` | `pb_recource/JA035/w_ja035k.srw` |
| `00123` | **외화채권 매매등록** | `W_JA035B1` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035b1.html` | `pb_recource/JA035/w_ja035b1.srw` |
| `00124` | **외화옵션 매매등록** | `W_JA035B2` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035b2.html` | `pb_recource/JA035/w_ja035b2.srw` |
| `00126` | **외화주식 배당금수령** | `W_JA036B` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036b.html` | `pb_recource/JA036/w_ja036b.srw` |
| `00127` | **유상청약납입** | `W_JA036C` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036c.html` | `pb_recource/JA036/w_ja036c.srw` |
| `00130` | **외화 비용거래 등록** | `W_JA035N` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035n.html` | `pb_recource/JA035/w_ja035n.srw` |
| `00131` | **외화 수익거래 등록** | `W_JA035M` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035m.html` | `pb_recource/JA035/w_ja035m.srw` |
| `00132` | **외화현금 유보 및 수령관리** | `W_JA035P` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035p.html` | `pb_recource/JA035/w_ja035p.srw` |
| `00133` | **외화재산 명세부** | `W_JA036E` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036e.html` | `pb_recource/JA036/w_ja036e.srw` |
| `00134` | **외화 자산조회** | `W_JA036F` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036f.html` | `pb_recource/JA036/w_ja036f.srw` |
| `00136` | **외화 채권/채무 현황** | `W_JA035Q` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035q.html` | `pb_recource/JA035/w_ja035q.srw` |
| `00137` | **외화자산 보유현황(종목/기간별)** | `W_JA036G` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036g.html` | `pb_recource/JA036/w_ja036g.srw` |
| `00138` | **외화증권 매매내역** | `W_JA036H` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036h.html` | `pb_recource/JA036/w_ja036h.srw` |
| `00143` | **해외 종가등록** | `W_JA036J` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036j.html` | `pb_recource/JA036/w_ja036j.srw` |
| `00144` | **해외주식 종가등록** | `W_JA036J1` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036j1.html` | `pb_recource/JA036/w_ja036j1.srw` |
| `00145` | **환율 UpLoad** | `W_JA036J2` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036j2.html` | `pb_recource/JA036/w_ja036j2.srw` |
| `00147` | **환율등록** | `W_SYX1HY` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_syx1hy.html` | `pb_recource/JA999/w_syx1hy.srw` |
| `00149` | **해외 체결(잔고) 엑셀자료 LOAD** | `W_JA036K` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja036k.html` | `pb_recource/JA036/w_ja036k.srw` |
| `00150` | **원장생성** | `W_RUN` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_run.html` | `pb_recource/JA010/w_run.srw` |
| `00181` | **해외선물 매매등록** | `W_JA035B3` | `foreignassetmanagement` | `templates/views/foreignassetmanagement/w_ja035b3.html` | `pb_recource/JA035/w_ja035b3.srw` |

### 📁 사무관리 > 원장조회 > 기준가 (13개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00033` | **분개장 등록** | `W_JA050B` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja050b.html` | `pb_recource/JA050/w_ja050b.srw` |
| `00035` | **분개장 출력** | `W_JA050C` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja050c.html` | `pb_recource/JA050/w_ja050c.srw` |
| `00051` | **신탁재산 명세부** | `W_JA015D` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja015d.html` | `pb_recource/JA015/w_ja015d.srw` |
| `00330` | **자산/계정별 자가진단양식 등록관리** | `W_JA050F` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja050f.html` | `pb_recource/JA050/w_ja050f.srw` |
| `00536` | **자가진단 & 결과조회** | `W_JA050` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja050.html` | `pb_recource/JA050/w_ja050.srw` |
| `00733` | **기준가 재계산내역 출력** | `W_JA050D` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja050d.html` | `pb_recource/JA050/w_ja050d.srw` |
| `00808` | **자료교환 FTP CONFIG 관리** | `W_JA051A` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja051a.html` | `pb_recource/JA051/w_ja051a.srw` |
| `00810` | **자료교환 메일 CONFIG 관리** | `W_JA051B` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja051b.html` | `pb_recource/JA051/w_ja051b.srw` |
| `00815` | **기준가명세표** | `W_JA050E` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja050e.html` | `pb_recource/JA050/w_ja050e.srw` |
| `00821` | **(핀케치) 교환용 자료 생성** | `W_JA051C` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja051c.html` | `pb_recource/JA051/w_ja051c.srw` |
| `00856` | **가격대장** | `W_JA050A` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja050a.html` | `pb_recource/JA050/w_ja050a.srw` |
| `00861` | **자료교환용 테이블 SELECT 문 관리** | `W_JA051D` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja051d.html` | `pb_recource/JA051/w_ja051d.srw` |
| `00862` | **자료교환용 테이블별 자료조회 및 생성** | `W_JA051E` | `ledgerinquiry` | `templates/views/ledgerinquiry/w_ja051e.html` | `pb_recource/JA051/w_ja051e.srw` |

### 📁 사무관리 > 자문일일 > 일일작업 (32개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00010` | **회사 기본정보 관리** | `W_JA010A` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010a.html` | `pb_recource/JA010/w_ja010a.srw` |
| `00034` | **선물/옵션 종가등록** | `W_SJT1TG` | `dailyadvisory` | `templates/views/dailyadvisory/w_sjt1tg.html` | `pb_recource/JA999/w_sjt1tg.srw` |
| `00041` | **예수금잔액LOAD** | `W_JA010F` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010f.html` | `pb_recource/JA010/w_ja010f.srw` |
| `00052` | **입.출금등록** | `W_JA010D` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010d.html` | `pb_recource/JA010/w_ja010d.srw` |
| `00053` | **주식 신용/대출잔고 LOAD** | `W_JA010O` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010o.html` | `pb_recource/JA010/w_ja010o.srw` |
| `00057` | **주식체결LOAD(입고)** | `W_JA010E` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010e.html` | `pb_recource/JA010/w_ja010e.srw` |
| `00058` | **현금 매입(종목)등록** | `W_SHM0HJ` | `dailyadvisory` | `templates/views/dailyadvisory/w_shm0hj.html` | `pb_recource/JA999/w_shm0hj.srw` |
| `00059` | **채권 매입등록** | `W_JA030C` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja030c.html` | `pb_recource/JA030/w_ja030c.srw` |
| `00060` | **채권/현금 만기현황** | `W_JA010P1` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010p1.html` | `pb_recource/JA010/w_ja010p1.srw` |
| `00061` | **채권신용등급 관리** | `W_SCM1PG` | `dailyadvisory` | `templates/views/dailyadvisory/w_scm1pg.html` | `pb_recource/JA999/w_scm1pg.srw` |
| `00063` | **현금신용등급 관리** | `W_SHM1PG` | `dailyadvisory` | `templates/views/dailyadvisory/w_shm1pg.html` | `pb_recource/JA999/w_shm1pg.srw` |
| `00064` | **계좌 관리그룹 등록** | `W_SZX0SE` | `dailyadvisory` | `templates/views/dailyadvisory/w_szx0se.html` | `pb_recource/JA999/w_szx0se.srw` |
| `00069` | **일(종목)별 운용현황** | `W_JA020K` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020k.html` | `pb_recource/JA020/w_ja020k.srw` |
| `00071` | **국내 체결(잔고) 엑셀자료 LOAD** | `W_JA020N` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020n.html` | `pb_recource/JA020/w_ja020n.srw` |
| `00072` | **결산현황** | `W_JA010M3` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010m3.html` | `pb_recource/JA010/w_ja010m3.srw` |
| `00076` | **자산명세표** | `W_JA010H1` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010h1.html` | `pb_recource/JA010/w_ja010h1.srw` |
| `00080` | **계좌(종목)별 주간 운용현황** | `W_JA020K1` | `subscriptionrights` | `templates/views/subscriptionrights/w_ja020k1.html` | `pb_recource/JA020/w_ja020k1.srw` |
| `00102` | **주식종가등록** | `W_SJT0TG` | `dailyadvisory` | `templates/views/dailyadvisory/w_sjt0tg.html` | `pb_recource/JA999/w_sjt0tg.srw` |
| `00113` | **입력자료 대비 순자산점검** | `W_JA010G` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010g.html` | `pb_recource/JA010/w_ja010g.srw` |
| `00114` | **고객별 자산현황** | `W_JA010H` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010h.html` | `pb_recource/JA010/w_ja010h.srw` |
| `00125` | **원장생성** | `W_RUN` | `dailyadvisory` | `templates/views/dailyadvisory/w_run.html` | `pb_recource/JA010/w_run.srw` |
| `00173` | **주식 종가조회** | `W_JA991A` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja991a.html` | `pb_recource/JA991/w_ja991a.srw` |
| `00180` | **성과보수 상세내역** | `W_JA010Q` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010q.html` | `pb_recource/JA010/w_ja010q.srw` |
| `00286` | **공모청약 수요예측 참여표(회사)** | `W_JA010J` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010j.html` | `pb_recource/JA010/w_ja010j.srw` |
| `00287` | **주가지수 입력** | `W_JA010N` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010n.html` | `pb_recource/JA010/w_ja010n.srw` |
| `00295` | **시스템 수정 및 개발의뢰** | `W_PROPOSAL` | `dailyadvisory` | `templates/views/dailyadvisory/w_proposal.html` | `pb_recource/SYS/w_proposal.srw` |
| `00297` | **발행기관 관리** | `W_JA990C` | `codemanagement` | `templates/views/codemanagement/w_ja990c.html` | `pb_recource/JA990/w_ja990c.srw` |
| `00298` | **주식, 신주인수권 종목관리** | `W_JA990D` | `codemanagement` | `templates/views/codemanagement/w_ja990d.html` | `pb_recource/JA990/w_ja990d.srw` |
| `00307` | **계좌 계약정보 관리** | `W_JA010B` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010b.html` | `pb_recource/JA010/w_ja010b.srw` |
| `01030` | **공모청약 수요예측 참여표(계좌)** | `W_JA010K` | `dailyadvisory` | `templates/views/dailyadvisory/w_ja010k.html` | `pb_recource/JA010/w_ja010k.srw` |
| `01034` | **채권단가등록** | `W_SCM1SM` | `dailyadvisory` | `templates/views/dailyadvisory/w_scm1sm.html` | `pb_recource/JA999/w_scm1sm.srw` |
| `01055` | **펀드 기준가(시가액)등록** | `W_SJT0SC` | `dailyadvisory` | `templates/views/dailyadvisory/w_sjt0sc.html` | `pb_recource/JA999/w_sjt0sc.srw` |

### 📁 사무관리 > 자산운용 > 자산운용 (23개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00046` | **선물/옵션 거래등록** | `W_JA031A` | `assetmanagement` | `templates/views/assetmanagement/w_ja031a.html` | `pb_recource/JA031/w_ja031a.srw` |
| `00047` | **선물/옵션 최종결제 수수료 등록** | `W_JA031B` | `assetmanagement` | `templates/views/assetmanagement/w_ja031b.html` | `pb_recource/JA031/w_ja031b.srw` |
| `00049` | **현금 증거금 등록** | `W_JA031C` | `assetmanagement` | `templates/views/assetmanagement/w_ja031c.html` | `pb_recource/JA031/w_ja031c.srw` |
| `00050` | **증권사 예금이자율 등록** | `W_JA030M` | `assetmanagement` | `templates/views/assetmanagement/w_ja030m.html` | `pb_recource/JA030/w_ja030m.srw` |
| `00054` | **(타사)수익증권 매매내역 등록** | `W_JA031D` | `assetmanagement` | `templates/views/assetmanagement/w_ja031d.html` | `pb_recource/JA031/w_ja031d.srw` |
| `00056` | **(타사)수익증권 매매내역 출력** | `W_JA031E` | `assetmanagement` | `templates/views/assetmanagement/w_ja031e.html` | `pb_recource/JA031/w_ja031e.srw` |
| `00074` | **주식 계좌별 매매현황** | `W_JA030B1` | `assetmanagement` | `templates/views/assetmanagement/w_ja030b1.html` | `pb_recource/JA030/w_ja030b1.srw` |
| `00075` | **채권 매매현황** | `W_JA031F` | `assetmanagement` | `templates/views/assetmanagement/w_ja031f.html` | `pb_recource/JA031/w_ja031f.srw` |
| `00081` | **현금 매매현황** | `W_JA031G` | `assetmanagement` | `templates/views/assetmanagement/w_ja031g.html` | `pb_recource/JA031/w_ja031g.srw` |
| `00087` | **운용현황** | `W_JA031H` | `assetmanagement` | `templates/views/assetmanagement/w_ja031h.html` | `pb_recource/JA031/w_ja031h.srw` |
| `00089` | **금감원 보고자료(GA191)** | `W_JA031J` | `assetmanagement` | `templates/views/assetmanagement/w_ja031j.html` | `pb_recource/JA031/w_ja031j.srw` |
| `00090` | **고유자산운용현황** | `W_JA031H1` | `assetmanagement` | `templates/views/assetmanagement/w_ja031h1.html` | `pb_recource/JA031/w_ja031h1.srw` |
| `00118` | **기타비용 출금등록** | `W_JA031M` | `assetmanagement` | `templates/views/assetmanagement/w_ja031m.html` | `pb_recource/JA031/w_ja031m.srw` |
| `00142` | **현금 매입거래 등록** | `W_JA030F` | `assetmanagement` | `templates/views/assetmanagement/w_ja030f.html` | `pb_recource/JA030/w_ja030f.srw` |
| `00152` | **기타수입 입금등록** | `W_JA031K` | `assetmanagement` | `templates/views/assetmanagement/w_ja031k.html` | `pb_recource/JA031/w_ja031k.srw` |
| `00156` | **주식 신주인수권매매 등록** | `W_JA030A` | `assetmanagement` | `templates/views/assetmanagement/w_ja030a.html` | `pb_recource/JA030/w_ja030a.srw` |
| `00394` | **유동자산 보유현황** | `W_JA030J` | `assetmanagement` | `templates/views/assetmanagement/w_ja030j.html` | `pb_recource/JA030/w_ja030j.srw` |
| `00438` | **현금 매도거래 등록** | `W_JA030H` | `assetmanagement` | `templates/views/assetmanagement/w_ja030h.html` | `pb_recource/JA030/w_ja030h.srw` |
| `00459` | **채권 매도거래 등록** | `W_JA030D` | `assetmanagement` | `templates/views/assetmanagement/w_ja030d.html` | `pb_recource/JA030/w_ja030d.srw` |
| `00460` | **채권 매입거래 등록** | `W_JA030C` | `assetmanagement` | `templates/views/assetmanagement/w_ja030c.html` | `pb_recource/JA030/w_ja030c.srw` |
| `00481` | **채권 종목정보 및 보유현황 출력** | `W_JA030E` | `assetmanagement` | `templates/views/assetmanagement/w_ja030e.html` | `pb_recource/JA030/w_ja030e.srw` |
| `00853` | **채권/현금 원리금 상환내역** | `W_JA030K` | `assetmanagement` | `templates/views/assetmanagement/w_ja030k.html` | `pb_recource/JA030/w_ja030k.srw` |
| `01035` | **주식 매매일별 현황** | `W_JA030B` | `assetmanagement` | `templates/views/assetmanagement/w_ja030b.html` | `pb_recource/JA030/w_ja030b.srw` |

### 📁 사무관리 > 코드관리 > 기본(종목)정보 (28개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00005` | **선물/옵션 종목등록** | `W_JA990K` | `codemanagement` | `templates/views/codemanagement/w_ja990k.html` | `pb_recource/JA990/w_ja990k.srw` |
| `00006` | **우측버튼 SQL 관리** | `W_WDCS01M_MANAGE` | `codemanagement` | `templates/views/codemanagement/w_wdcs01m_manage.html` | `pb_recource/SYS/w_wdcs01m_manage.srw` |
| `00012` | **DDDW SQL 관리** | `W_WDDDWCTL_MANAGE` | `codemanagement` | `templates/views/codemanagement/w_wdddwctl_manage.html` | `pb_recource/SYS/w_wdddwctl_manage.srw` |
| `00048` | **선물/옵션 수수료율 등록** | `W_JA990M` | `codemanagement` | `templates/views/codemanagement/w_ja990m.html` | `pb_recource/JA990/w_ja990m.srw` |
| `00073` | **상장(타사)집합투자증권 종목관리** | `W_SJM0SC` | `codemanagement` | `templates/views/codemanagement/w_sjm0sc.html` | `pb_recource/JA999/w_sjm0sc.srw` |
| `00082` | **에러메세지 관리** | `W_WMSG01M_MANAGE` | `codemanagement` | `templates/views/codemanagement/w_wmsg01m_manage.html` | `pb_recource/SYS/w_wmsg01m_manage.srw` |
| `00083` | **TABLE LAYOUT 관리** | `W_ADMIN_TABLE` | `codemanagement` | `templates/views/codemanagement/w_admin_table.html` | `pb_recource/DBA/w_admin_table.srw` |
| `00084` | **INDEX LAYOUT 관리** | `W_ADMIN_INDEX` | `codemanagement` | `templates/views/codemanagement/w_admin_index.html` | `pb_recource/DBA/w_admin_index.srw` |
| `00085` | **주간업무일지 관리** | `W_WEEKLY` | `codemanagement` | `templates/views/codemanagement/w_weekly.html` | `pb_recource/DBA/w_weekly.srw` |
| `00086` | **주간업무일지 출력** | `W_WEEKLY_REPORT` | `codemanagement` | `templates/views/codemanagement/w_weekly_report.html` | `pb_recource/DBA/w_weekly_report.srw` |
| `00099` | **메모관리** | `W_MEMO` | `codemanagement` | `templates/views/codemanagement/w_memo.html` | `pb_recource/SYS/w_memo.srw` |
| `00109` | **SQL문 실행** | `W_SQLRUN` | `codemanagement` | `templates/views/codemanagement/w_sqlrun.html` | `pb_recource/DBA/w_sqlrun.srw` |
| `00115` | **업무 메뉴얼** | `W_MANUAL` | `codemanagement` | `templates/views/codemanagement/w_manual.html` | `pb_recource/DBA/w_manual.srw` |
| `00135` | **국가코드 관리** | `W_SZX0WA` | `codemanagement` | `templates/views/codemanagement/w_szx0wa.html` | `pb_recource/JA999/w_szx0wa.srw` |
| `00146` | **해외보관처** | `W_SYX2MM` | `codemanagement` | `templates/views/codemanagement/w_syx2mm.html` | `pb_recource/JA999/w_syx2mm.srw` |
| `00161` | **API PARAMETER 관리** | `W_API_PARAMS` | `codemanagement` | `templates/views/codemanagement/w_api_params.html` | `pb_recource/JA999/w_api_params.srw` |
| `00167` | **년월관리** | `W_SZX0YM` | `codemanagement` | `templates/views/codemanagement/w_szx0ym.html` | `pb_recource/JA999/w_szx0ym.srw` |
| `00178` | **예탁원 코드관리** | `W_KSDCODE` | `codemanagement` | `templates/views/codemanagement/w_ksdcode.html` | `pb_recource/JA999/w_ksdcode.srw` |
| `00316` | **그룹(RD)/업종코드** | `W_JA990A` | `codemanagement` | `templates/views/codemanagement/w_ja990a.html` | `pb_recource/JA990/w_ja990a.srw` |
| `00317` | **거래(적요)코드관리(분개유형,단축식별자)** | `W_JA990F` | `codemanagement` | `templates/views/codemanagement/w_ja990f.html` | `pb_recource/JA990/w_ja990f.srw` |
| `00318` | **계정과목 및 보고서별 계정 등록** | `W_JA990E` | `codemanagement` | `templates/views/codemanagement/w_ja990e.html` | `pb_recource/JA990/w_ja990e.srw` |
| `00320` | **발행기관 기본정보 등록** | `W_JA990C` | `codemanagement` | `templates/views/codemanagement/w_ja990c.html` | `pb_recource/JA990/w_ja990c.srw` |
| `00323` | **채권 종목관리** | `W_JA990H` | `codemanagement` | `templates/views/codemanagement/w_ja990h.html` | `pb_recource/JA990/w_ja990h.srw` |
| `00325` | **프로그램별 거래코드 등록** | `W_JA990G` | `codemanagement` | `templates/views/codemanagement/w_ja990g.html` | `pb_recource/JA990/w_ja990g.srw` |
| `00331` | **업무시스템 공휴일 등록관리** | `W_JA990J` | `codemanagement` | `templates/views/codemanagement/w_ja990j.html` | `pb_recource/JA990/w_ja990j.srw` |
| `00393` | **유동자산 종목정보 관리** | `W_JA030G` | `codemanagement` | `templates/views/codemanagement/w_ja030g.html` | `pb_recource/JA030/w_ja030g.srw` |
| `00744` | **업무 메뉴얼 출력** | `W_MANUAL_REPORT` | `codemanagement` | `templates/views/codemanagement/w_manual_report.html` | `pb_recource/DBA/w_manual_report.srw` |
| `01019` | **매매처** | `W_JA990B` | `codemanagement` | `templates/views/codemanagement/w_ja990b.html` | `pb_recource/JA990/w_ja990b.srw` |

### 📁 사무관리 > 프레임관리 > Example (8개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00036` | **전체기능구현** | `W_EXAM4ALL1` | `framemanagement` | `templates/views/framemanagement/w_exam4all1.html` | `pb_recource/exam4trial/w_exam4all1.srw` |
| `00037` | **동적그룹구현예제** | `W_EXAM4GROUP1` | `framemanagement` | `templates/views/framemanagement/w_exam4group1.html` | `pb_recource/exam4func/w_exam4group1.srw` |
| `00038` | **동적필터구현예제** | `W_EXAM4FILTER1` | `framemanagement` | `templates/views/framemanagement/w_exam4filter1.html` | `pb_recource/exam4func/w_exam4filter1.srw` |
| `00039` | **HSPLIT구현예제** | `W_EXAM4HSPLIT1` | `framemanagement` | `templates/views/framemanagement/w_exam4hsplit1.html` | `pb_recource/exam4func/w_exam4hsplit1.srw` |
| `00040` | **OLE연결(네이버)** | `W_EXAM4OLE1` | `framemanagement` | `templates/views/framemanagement/w_exam4ole1.html` | `pb_recource/exam4func/w_exam4ole1.srw` |
| `00077` | **시스템 트리 실습1** | `W_ROLE_TREE_01` | `framemanagement` | `templates/views/framemanagement/w_role_tree_01.html` | `pb_recource/.../w_role_tree_01.srw` |
| `00106` | **달력기능예제** | `W_EXAM4CALENDAR1` | `framemanagement` | `templates/views/framemanagement/w_exam4calendar1.html` | `pb_recource/exam4func/w_exam4calendar1.srw` |
| `00777` | **MNP-w_dynamiccodesearch 테스트** | `W_DYNAMICCODESEARCH` | `codemanagement` | `templates/views/codemanagement/w_dynamiccodesearch.html` | `pb_recource/COMM/w_dynamiccodesearch.srw` |

### 📁 사무관리 > 프레임관리 > 다국어 (4개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00289` | **항목등록(테이블)** | `W_LANGCM_01` | `framemanagement` | `templates/views/framemanagement/w_langcm_01.html` | `pb_recource/bzlang4c/w_langcm_01.srw` |
| `00290` | **데이터등록(테이블)** | `W_LANGCM_02` | `framemanagement` | `templates/views/framemanagement/w_langcm_02.html` | `pb_recource/bzlang4c/w_langcm_02.srw` |
| `00292` | **데이터등록(메뉴)** | `W_LANGCVT_01` | `framemanagement` | `templates/views/framemanagement/w_langcvt_01.html` | `pb_recource/bzlang4c/w_langcvt_01.srw` |
| `00294` | **통합검색(데이터)** | `W_LANGCVT_02` | `framemanagement` | `templates/views/framemanagement/w_langcvt_02.html` | `pb_recource/bzlang4c/w_langcvt_02.srw` |

### 📁 사무관리 > 프레임관리 > 시스템설정 (3개)

| 화면번호 | 화면이름 | 화면 파일명 (PGM_ID) | 웹 도메인 | 웹 뷰 경로 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00067` | **코드관리 (원본샘플)** | `W_BZCM00_01` | `framemanagement` | `templates/views/framemanagement/w_bzcm00_01.html` | `pb_recource/bzplan/w_bzcm00_01.srw` |
| `00103` | **코드관리 (윈4클래스적용)** | `W_GRPCODE_21` | `codemanagement` | `templates/views/codemanagement/w_grpcode_21.html` | `pb_recource/.../w_grpcode_21.srw` |
| `00117` | **컬러관리** | `W_BZCM00_02` | `framemanagement` | `templates/views/framemanagement/w_bzcm00_02.html` | `pb_recource/bzplan/w_bzcm00_02.srw` |

---

## 🔢 2. 화면번호 (PGM_NO) 순 전체 색인표

| 화면번호 | 화면 파일명 (PGM_ID) | 화면이름 | 메뉴 경로 (대메뉴 > 소분류) | 도메인 | 파워빌더 소스 (.srw) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `00005` | `W_JA990K` | **선물/옵션 종목등록** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990k.srw` |
| `00006` | `W_WDCS01M_MANAGE` | **우측버튼 SQL 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/SYS/w_wdcs01m_manage.srw` |
| `00008` | `W_DIMENSION_MST` | **Dimension 관리** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fcht4comm/w_dimension_mst.srw` |
| `00010` | `W_JA010A` | **회사 기본정보 관리** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010a.srw` |
| `00011` | `W_JA990Z` | **프로그램별 처리단계등록** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `codemanagement` | `pb_recource/JA990/w_ja990z.srw` |
| `00012` | `W_WDDDWCTL_MANAGE` | **DDDW SQL 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/SYS/w_wdddwctl_manage.srw` |
| `00015` | `FW_W_PGM_MST` | **프로그램 기본정보** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/fw_w_role/fw_w_pgm_mst.srw` |
| `00016` | `FW_W_ROLE_SETTING` | **권한 멤버유형 등록** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/fw_w_role/fw_w_role_setting.srw` |
| `00017` | `FW_W_ROLE_ASSIGN` | **권한별 멤버 및 프로그램 등록** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/fw_w_role/fw_w_role_assign.srw` |
| `00018` | `FW_W_BTN_ASSIGN` | **권한별 프로그램 버튼관리** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/fw_w_role/fw_w_btn_assign.srw` |
| `00019` | `FW_W_BTN_ROLE_ASSIGN` | **프로그램별 버튼관리** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/fw_w_role/fw_w_btn_role_assign.srw` |
| `00020` | `FW_W_ROLE_INFO_RET` | **사용자별 프로그램별 권한조회** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/fw_w_role/fw_w_role_info_ret.srw` |
| `00021` | `FW_W_PGM_LOGS` | **프로그램사용자로그조회** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/bzplan/fw_w_pgm_logs.srw` |
| `00022` | `FW_W_NOTICE_CONFIG` | **공지사항관리** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/fw_w_notice_config.srw` |
| `00023` | `FW_W_NOTICE` | **전체공지등록** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/fw_w_notice.srw` |
| `00024` | `FW_W_NOTICE` | **회사별공지등록** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/fw_w_notice.srw` |
| `00025` | `FW_W_NOTICE_CHECK` | **전체공지 확인내역** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/fw_w_notice_check.srw` |
| `00026` | `FW_W_NOTICE_CHECK` | **회사별공지 확인내역** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/fw_w_notice_check.srw` |
| `00027` | `W_PLAN4CALENDAR` | **달력관리** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/bzplan/w_plan4calendar.srw` |
| `00028` | `W_PLANUSER` | **개인일정** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/bzplan/w_planuser.srw` |
| `00029` | `W_PBDUPDATE` | **소스버전관리(PBD)** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/bzplan/w_pbdupdate.srw` |
| `00031` | `W_UJNR200` | **집합투자증권 명세부 출력** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_ujnr200.srw` |
| `00032` | `W_SKKU051` | **손익차등 종목별 상세현황** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_skku051.srw` |
| `00033` | `W_JA050B` | **분개장 등록** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA050/w_ja050b.srw` |
| `00034` | `W_SJT1TG` | **선물/옵션 종가등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_sjt1tg.srw` |
| `00035` | `W_JA050C` | **분개장 출력** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA050/w_ja050c.srw` |
| `00036` | `W_EXAM4ALL1` | **전체기능구현** | 사무관리 > 프레임관리 > Example | `framemanagement` | `pb_recource/exam4trial/w_exam4all1.srw` |
| `00037` | `W_EXAM4GROUP1` | **동적그룹구현예제** | 사무관리 > 프레임관리 > Example | `framemanagement` | `pb_recource/exam4func/w_exam4group1.srw` |
| `00038` | `W_EXAM4FILTER1` | **동적필터구현예제** | 사무관리 > 프레임관리 > Example | `framemanagement` | `pb_recource/exam4func/w_exam4filter1.srw` |
| `00039` | `W_EXAM4HSPLIT1` | **HSPLIT구현예제** | 사무관리 > 프레임관리 > Example | `framemanagement` | `pb_recource/exam4func/w_exam4hsplit1.srw` |
| `00040` | `W_EXAM4OLE1` | **OLE연결(네이버)** | 사무관리 > 프레임관리 > Example | `framemanagement` | `pb_recource/exam4func/w_exam4ole1.srw` |
| `00041` | `W_JA010F` | **예수금잔액LOAD** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010f.srw` |
| `00042` | `W_SZZE170` | **펀드 기본정보 등록** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_szze170.srw` |
| `00043` | `W_JA040A` | **손익차등 우선배당율 관리** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_ja040a.srw` |
| `00044` | `W_UZNR041` | **가격대장 출력** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_uznr041.srw` |
| `00045` | `W_JA040D` | **손익차등 가격대장 출력** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_ja040d.srw` |
| `00046` | `W_JA031A` | **선물/옵션 거래등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031a.srw` |
| `00047` | `W_JA031B` | **선물/옵션 최종결제 수수료 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031b.srw` |
| `00048` | `W_JA990M` | **선물/옵션 수수료율 등록** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990m.srw` |
| `00049` | `W_JA031C` | **현금 증거금 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031c.srw` |
| `00050` | `W_JA030M` | **증권사 예금이자율 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030m.srw` |
| `00051` | `W_JA015D` | **신탁재산 명세부** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA015/w_ja015d.srw` |
| `00052` | `W_JA010D` | **입.출금등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010d.srw` |
| `00053` | `W_JA010O` | **주식 신용/대출잔고 LOAD** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010o.srw` |
| `00054` | `W_JA031D` | **(타사)수익증권 매매내역 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031d.srw` |
| `00056` | `W_JA031E` | **(타사)수익증권 매매내역 출력** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031e.srw` |
| `00057` | `W_JA010E` | **주식체결LOAD(입고)** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010e.srw` |
| `00058` | `W_SHM0HJ` | **현금 매입(종목)등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_shm0hj.srw` |
| `00059` | `W_JA030C` | **채권 매입등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA030/w_ja030c.srw` |
| `00060` | `W_JA010P1` | **채권/현금 만기현황** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010p1.srw` |
| `00061` | `W_SCM1PG` | **채권신용등급 관리** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_scm1pg.srw` |
| `00063` | `W_SHM1PG` | **현금신용등급 관리** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_shm1pg.srw` |
| `00064` | `W_SZX0SE` | **계좌 관리그룹 등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_szx0se.srw` |
| `00065` | `W_JA020H` | **채권 펀드/종목별 시가등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020h.srw` |
| `00066` | `W_JA020J` | **현금 펀드/종목별 시가등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020j.srw` |
| `00067` | `W_BZCM00_01` | **코드관리 (원본샘플)** | 사무관리 > 프레임관리 > 시스템설정 | `framemanagement` | `pb_recource/bzplan/w_bzcm00_01.srw` |
| `00068` | `W_JA020Q` | **수요예측 참여자료** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020q.srw` |
| `00069` | `W_JA020K` | **일(종목)별 운용현황** | 사무관리 > 자문일일 > 일일작업 | `subscriptionrights` | `pb_recource/JA020/w_ja020k.srw` |
| `00070` | `W_JA020M` | **금투협보고자료** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020m.srw` |
| `00071` | `W_JA020N` | **국내 체결(잔고) 엑셀자료 LOAD** | 사무관리 > 자문일일 > 일일작업 | `subscriptionrights` | `pb_recource/JA020/w_ja020n.srw` |
| `00072` | `W_JA010M3` | **결산현황** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010m3.srw` |
| `00073` | `W_SJM0SC` | **상장(타사)집합투자증권 종목관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA999/w_sjm0sc.srw` |
| `00074` | `W_JA030B1` | **주식 계좌별 매매현황** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030b1.srw` |
| `00075` | `W_JA031F` | **채권 매매현황** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031f.srw` |
| `00076` | `W_JA010H1` | **자산명세표** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010h1.srw` |
| `00077` | `W_ROLE_TREE_01` | **시스템 트리 실습1** | 사무관리 > 프레임관리 > Example | `framemanagement` | `pb_recource/.../w_role_tree_01.srw` |
| `00078` | `W_JA020P` | **채권비율보고** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020p.srw` |
| `00079` | `W_JA020R` | **유가증권 취득액 관리** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020r.srw` |
| `00080` | `W_JA020K1` | **계좌(종목)별 주간 운용현황** | 사무관리 > 자문일일 > 일일작업 | `subscriptionrights` | `pb_recource/JA020/w_ja020k1.srw` |
| `00081` | `W_JA031G` | **현금 매매현황** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031g.srw` |
| `00082` | `W_WMSG01M_MANAGE` | **에러메세지 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/SYS/w_wmsg01m_manage.srw` |
| `00083` | `W_ADMIN_TABLE` | **TABLE LAYOUT 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/DBA/w_admin_table.srw` |
| `00084` | `W_ADMIN_INDEX` | **INDEX LAYOUT 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/DBA/w_admin_index.srw` |
| `00085` | `W_WEEKLY` | **주간업무일지 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/DBA/w_weekly.srw` |
| `00086` | `W_WEEKLY_REPORT` | **주간업무일지 출력** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/DBA/w_weekly_report.srw` |
| `00087` | `W_JA031H` | **운용현황** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031h.srw` |
| `00088` | `W_JA060D` | **운용역정보 및 규모** | 사무관리 > 보고서 > 보고서 | `reportmanagement` | `pb_recource/JA060/w_ja060d.srw` |
| `00089` | `W_JA031J` | **금감원 보고자료(GA191)** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031j.srw` |
| `00090` | `W_JA031H1` | **고유자산운용현황** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031h1.srw` |
| `00092` | `W_SZT0CK` | **SZT0CK** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/JA999/w_szt0ck.srw` |
| `00093` | `W_JA999A` | **원장생성 작업내역** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/JA999/w_ja999a.srw` |
| `00094` | `W_FW_VERSION_MANAGE` | **프로그램 버젼관리** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_fw_version_manage.srw` |
| `00095` | `W_HISTORY` | **시스템 이력관리** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/DBA/w_history.srw` |
| `00096` | `W_HISTORY_PRT` | **시스템 이력관리 출력** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/DBA/w_history_prt.srw` |
| `00098` | `W_JA035A` | **외화 유동자산 종목등록** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035a.srw` |
| `00099` | `W_MEMO` | **메모관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/SYS/w_memo.srw` |
| `00100` | `W_SONIK_FLOW` | **손익차등 수익배분 상세현항** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_sonik_flow.srw` |
| `00101` | `W_WHLP00M_HELP_LIST` | **도움말 관리** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_whlp00m_help_list.srw` |
| `00102` | `W_SJT0TG` | **주식종가등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_sjt0tg.srw` |
| `00103` | `W_GRPCODE_21` | **코드관리 (윈4클래스적용)** | 사무관리 > 프레임관리 > 시스템설정 | `codemanagement` | `pb_recource/.../w_grpcode_21.srw` |
| `00104` | `W_JA035B` | **외화증권 매매등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035b.srw` |
| `00105` | `W_JA035C` | **외화 환전 및 현금거래 등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035c.srw` |
| `00106` | `W_EXAM4CALENDAR1` | **달력기능예제** | 사무관리 > 프레임관리 > Example | `framemanagement` | `pb_recource/exam4func/w_exam4calendar1.srw` |
| `00107` | `W_PGM_MST` | **시스템별 메뉴정렬** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_pgm_mst.srw` |
| `00108` | `W_FW_OBJ_NO_ASSIGN` | **화면번호 등록** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_fw_obj_no_assign.srw` |
| `00109` | `W_SQLRUN` | **SQL문 실행** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/DBA/w_sqlrun.srw` |
| `00110` | `W_JA035D` | **외화 주식배당관리** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035d.srw` |
| `00111` | `W_JA035E` | **외화증권 권리관리** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035e.srw` |
| `00112` | `W_JA035F` | **외화증권 코드변경** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035f.srw` |
| `00113` | `W_JA010G` | **입력자료 대비 순자산점검** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010g.srw` |
| `00114` | `W_JA010H` | **고객별 자산현황** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010h.srw` |
| `00115` | `W_MANUAL` | **업무 메뉴얼** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/DBA/w_manual.srw` |
| `00117` | `W_BZCM00_02` | **컬러관리** | 사무관리 > 프레임관리 > 시스템설정 | `framemanagement` | `pb_recource/bzplan/w_bzcm00_02.srw` |
| `00118` | `W_JA031M` | **기타비용 출금등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031m.srw` |
| `00119` | `W_JA035G` | **외화주식 권리주상장** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035g.srw` |
| `00120` | `W_JA035H` | **외화 NOTE이자수령** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035h.srw` |
| `00121` | `W_JA035J` | **수도결제 등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035j.srw` |
| `00122` | `W_JA035K` | **외화수익증권 매매등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035k.srw` |
| `00123` | `W_JA035B1` | **외화채권 매매등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035b1.srw` |
| `00124` | `W_JA035B2` | **외화옵션 매매등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035b2.srw` |
| `00125` | `W_RUN` | **원장생성** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_run.srw` |
| `00126` | `W_JA036B` | **외화주식 배당금수령** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036b.srw` |
| `00127` | `W_JA036C` | **유상청약납입** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036c.srw` |
| `00128` | `W_JA036D` | **외화 납부세금 환급** | 사무관리 > 외화자산운용 > 외화세금관리 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036d.srw` |
| `00129` | `W_JA036A` | **기간별 외화 선납원천세 내역** | 사무관리 > 외화자산운용 > 외화세금관리 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036a.srw` |
| `00130` | `W_JA035N` | **외화 비용거래 등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035n.srw` |
| `00131` | `W_JA035M` | **외화 수익거래 등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035m.srw` |
| `00132` | `W_JA035P` | **외화현금 유보 및 수령관리** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035p.srw` |
| `00133` | `W_JA036E` | **외화재산 명세부** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036e.srw` |
| `00134` | `W_JA036F` | **외화 자산조회** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036f.srw` |
| `00135` | `W_SZX0WA` | **국가코드 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA999/w_szx0wa.srw` |
| `00136` | `W_JA035Q` | **외화 채권/채무 현황** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035q.srw` |
| `00137` | `W_JA036G` | **외화자산 보유현황(종목/기간별)** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036g.srw` |
| `00138` | `W_JA036H` | **외화증권 매매내역** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036h.srw` |
| `00139` | `W_JA036I` | **외국납부세액 환급신청** | 사무관리 > 외화자산운용 > 외화세금관리 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036i.srw` |
| `00140` | `W_JA036` | **해외(대출)채권 종목등록** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036.srw` |
| `00141` | `W_JA035` | **해외 파생/선물/옵션 종목등록** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035.srw` |
| `00142` | `W_JA030F` | **현금 매입거래 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030f.srw` |
| `00143` | `W_JA036J` | **해외 종가등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036j.srw` |
| `00144` | `W_JA036J1` | **해외주식 종가등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036j1.srw` |
| `00145` | `W_JA036J2` | **환율 UpLoad** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036j2.srw` |
| `00146` | `W_SYX2MM` | **해외보관처** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA999/w_syx2mm.srw` |
| `00147` | `W_SYX1HY` | **환율등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA999/w_syx1hy.srw` |
| `00148` | `W_JA035R` | **해외 주식 종목등록** | 사무관리 > 외화자산운용 > 외화 종목 및 권리관리 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035r.srw` |
| `00149` | `W_JA036K` | **해외 체결(잔고) 엑셀자료 LOAD** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA036/w_ja036k.srw` |
| `00150` | `W_RUN` | **원장생성** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA010/w_run.srw` |
| `00152` | `W_JA031K` | **기타수입 입금등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA031/w_ja031k.srw` |
| `00155` | `W_JA032A` | **USPM 종목 기준정보등록** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032a.srw` |
| `00156` | `W_JA030A` | **주식 신주인수권매매 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030a.srw` |
| `00157` | `W_JA032B_DD` | **기준정보 종목 일별현황** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032b_dd.srw` |
| `00158` | `W_JA032C` | **USPM 변동성 추이** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032c.srw` |
| `00159` | `W_SYX1HY` | **환율등록** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA999/w_syx1hy.srw` |
| `00160` | `W_JA032D` | **API 자료요청 현황** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032d.srw` |
| `00161` | `W_API_PARAMS` | **API PARAMETER 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA999/w_api_params.srw` |
| `00162` | `W_JA032E_PUT` | **USPM 운용지시 PUT배분작업** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032e_put.srw` |
| `00163` | `W_JA032F` | **해외 주식종목정보** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA032/w_ja032f.srw` |
| `00164` | `W_JA032G` | **해외 파생종목정보** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA032/w_ja032g.srw` |
| `00165` | `W_API_PARAMS` | **API PARAMETER 관리** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA999/w_api_params.srw` |
| `00166` | `W_JA032H` | **해외 업종/지수/환율(frgncode)** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA032/w_ja032h.srw` |
| `00167` | `W_SZX0YM` | **년월관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA999/w_szx0ym.srw` |
| `00168` | `W_JA032J` | **해외주식종가/업종지수 등록** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA032/w_ja032j.srw` |
| `00169` | `W_CRON_Q` | **CRON** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA999/w_cron_q.srw` |
| `00170` | `W_JA035B` | **해외주식 매매(권리)등록** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA035/w_ja035b.srw` |
| `00171` | `W_JA035B2` | **해외 파생 PORT 매매관리** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA035/w_ja035b2.srw` |
| `00172` | `W_JA032K` | **자산현황** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032k.srw` |
| `00173` | `W_JA991A` | **주식 종가조회** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA991/w_ja991a.srw` |
| `00174` | `W_RUN` | **원장생성** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA010/w_run.srw` |
| `00175` | `W_FOSTKCODE` | **API_FOSTKCODE 조회** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA999/w_fostkcode.srw` |
| `00176` | `W_JA036H` | **외화증권 매매내역** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA036/w_ja036h.srw` |
| `00177` | `W_SRS_CD` | **해외파생 생성종목 현황** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA999/w_srs_cd.srw` |
| `00178` | `W_KSDCODE` | **예탁원 코드관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA999/w_ksdcode.srw` |
| `00179` | `W_JA032M` | **종목별 위험값** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032m.srw` |
| `00180` | `W_JA010Q` | **성과보수 상세내역** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010q.srw` |
| `00181` | `W_JA035B3` | **해외선물 매매등록** | 사무관리 > 외화자산운용 > 외화자산운용 | `foreignassetmanagement` | `pb_recource/JA035/w_ja035b3.srw` |
| `00182` | `W_JA033A` | **KRX 주식 선물/옵션 종목** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA033/w_ja033a.srw` |
| `00183` | `W_JA033B` | **KRX 지수 선물/옵션 종목** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA033/w_ja033b.srw` |
| `00184` | `W_JA033C` | **KRX 통화 선물/옵션 종목** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA033/w_ja033c.srw` |
| `00185` | `W_JA050A` | **손익현황(원장)** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA050/w_ja050a.srw` |
| `00186` | `W_JA050C` | **손익 상세현황(분개장)** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA050/w_ja050c.srw` |
| `00187` | `W_JA032B_FUND` | **기준정보 펀드 일별현황** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032b_fund.srw` |
| `00188` | `W_JA032B_OPT` | **기준정보 옵션위험값 일별현황** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032b_opt.srw` |
| `00189` | `W_JA032O` | **파생 환매수 운용지시** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032o.srw` |
| `00190` | `W_JA032N` | **포트별 옵션수익실현현황** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032n.srw` |
| `00191` | `W_JA032B_YA` | **관심종목 변동성 추이** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032b_ya.srw` |
| `00192` | `W_JA033E` | **포트/종목별 종가대비 행사가격** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA033/w_ja033e.srw` |
| `00193` | `W_JA032P` | **기준정보 옵션종목 일별현항** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032p.srw` |
| `00195` | `W_JA032F_KRX` | **KRX 주식종목정보** | 사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 | `usportfoliomodel` | `pb_recource/JA032/w_ja032f_krx.srw` |
| `00196` | `W_JA032E_CALL` | **USPM 운용지시 CALL배분작업** | 사무관리 > US Portfolio Model > USPM | `usportfoliomodel` | `pb_recource/JA032/w_ja032e_call.srw` |
| `00286` | `W_JA010J` | **공모청약 수요예측 참여표(회사)** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010j.srw` |
| `00287` | `W_JA010N` | **주가지수 입력** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010n.srw` |
| `00289` | `W_LANGCM_01` | **항목등록(테이블)** | 사무관리 > 프레임관리 > 다국어 | `framemanagement` | `pb_recource/bzlang4c/w_langcm_01.srw` |
| `00290` | `W_LANGCM_02` | **데이터등록(테이블)** | 사무관리 > 프레임관리 > 다국어 | `framemanagement` | `pb_recource/bzlang4c/w_langcm_02.srw` |
| `00292` | `W_LANGCVT_01` | **데이터등록(메뉴)** | 사무관리 > 프레임관리 > 다국어 | `framemanagement` | `pb_recource/bzlang4c/w_langcvt_01.srw` |
| `00294` | `W_LANGCVT_02` | **통합검색(데이터)** | 사무관리 > 프레임관리 > 다국어 | `framemanagement` | `pb_recource/bzlang4c/w_langcvt_02.srw` |
| `00295` | `W_PROPOSAL` | **시스템 수정 및 개발의뢰** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/SYS/w_proposal.srw` |
| `00297` | `W_JA990C` | **발행기관 관리** | 사무관리 > 자문일일 > 일일작업 | `codemanagement` | `pb_recource/JA990/w_ja990c.srw` |
| `00298` | `W_JA990D` | **주식, 신주인수권 종목관리** | 사무관리 > 자문일일 > 일일작업 | `codemanagement` | `pb_recource/JA990/w_ja990d.srw` |
| `00302` | `FW_W_LOG_VIEW1` | **로그검색(통합)** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/fw_w_role/fw_w_log_view1.srw` |
| `00305` | `W_JA021F` | **유(무)상증자 공시등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021f.srw` |
| `00307` | `W_JA010B` | **계좌 계약정보 관리** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010b.srw` |
| `00308` | `W_JA021G` | **합병.분할.병합.감자.소각공시등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021g.srw` |
| `00316` | `W_JA990A` | **그룹(RD)/업종코드** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990a.srw` |
| `00317` | `W_JA990F` | **거래(적요)코드관리(분개유형,단축식별자)** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990f.srw` |
| `00318` | `W_JA990E` | **계정과목 및 보고서별 계정 등록** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990e.srw` |
| `00320` | `W_JA990C` | **발행기관 기본정보 등록** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990c.srw` |
| `00323` | `W_JA990H` | **채권 종목관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990h.srw` |
| `00325` | `W_JA990G` | **프로그램별 거래코드 등록** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990g.srw` |
| `00330` | `W_JA050F` | **자산/계정별 자가진단양식 등록관리** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA050/w_ja050f.srw` |
| `00331` | `W_JA990J` | **업무시스템 공휴일 등록관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990j.srw` |
| `00341` | `W_NOTICE_FILE` | **첨부파일관리** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/w_notice_file.srw` |
| `00342` | `W_JA020C` | **권리 주식(대금) 수령 등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020c.srw` |
| `00343` | `W_JA020G` | **합병.분할.병합.감자.소각 내역서** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020g.srw` |
| `00353` | `W_JA020A` | **공모청약 종목 및 배정등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020a.srw` |
| `00382` | `W_JA060B` | **운용보고서 생성** | 사무관리 > 보고서 > 보고서 | `reportmanagement` | `pb_recource/JA060/w_ja060b.srw` |
| `00393` | `W_JA030G` | **유동자산 종목정보 관리** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA030/w_ja030g.srw` |
| `00394` | `W_JA030J` | **유동자산 보유현황** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030j.srw` |
| `00398` | `W_JA021D` | **배당 명세표 출력** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021d.srw` |
| `00432` | `W_JA021A` | **(자문사별)예상배당 공시등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021a.srw` |
| `00434` | `W_JA021H` | **상장공시.코드변경 등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021h.srw` |
| `00438` | `W_JA030H` | **현금 매도거래 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030h.srw` |
| `00459` | `W_JA030D` | **채권 매도거래 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030d.srw` |
| `00460` | `W_JA030C` | **채권 매입거래 등록** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030c.srw` |
| `00481` | `W_JA030E` | **채권 종목정보 및 보유현황 출력** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030e.srw` |
| `00501` | `W_WLOG02T_LOG_LIST` | **테이블 LOG 조회** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_wlog02t_log_list.srw` |
| `00536` | `W_JA050` | **자가진단 & 결과조회** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA050/w_ja050.srw` |
| `00631` | `W_FW_USER_MST` | **사용자 관리** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_fw_user_mst.srw` |
| `00733` | `W_JA050D` | **기준가 재계산내역 출력** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA050/w_ja050d.srw` |
| `00744` | `W_MANUAL_REPORT` | **업무 메뉴얼 출력** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/DBA/w_manual_report.srw` |
| `00767` | `W_JA020E` | **권리처리내역 조회** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020e.srw` |
| `00777` | `W_DYNAMICCODESEARCH` | **MNP-w_dynamiccodesearch 테스트** | 사무관리 > 프레임관리 > Example | `codemanagement` | `pb_recource/COMM/w_dynamiccodesearch.srw` |
| `00808` | `W_JA051A` | **자료교환 FTP CONFIG 관리** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA051/w_ja051a.srw` |
| `00810` | `W_JA051B` | **자료교환 메일 CONFIG 관리** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA051/w_ja051b.srw` |
| `00815` | `W_JA050E` | **기준가명세표** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA050/w_ja050e.srw` |
| `00820` | `W_WLOG01M_LOG_TABLE` | **LOG 테이블 관리** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_wlog01m_log_table.srw` |
| `00821` | `W_JA051C` | **(핀케치) 교환용 자료 생성** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA051/w_ja051c.srw` |
| `00840` | `FW_W_DIME1` | **디멘젼관리** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/DBA/fw_w_dime1.srw` |
| `00848` | `W_JA021E` | **채권 특이채 권리행사 처리** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021e.srw` |
| `00850` | `FW_W_NOTICE` | **IT개선사항** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/fw_w_notice.srw` |
| `00851` | `FW_W_NOTICE_CHECK` | **IT개선사항 확인내역(현업)** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/fw_w_notice/fw_w_notice_check.srw` |
| `00853` | `W_JA030K` | **채권/현금 원리금 상환내역** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030k.srw` |
| `00856` | `W_JA050A` | **가격대장** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA050/w_ja050a.srw` |
| `00861` | `W_JA051D` | **자료교환용 테이블 SELECT 문 관리** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA051/w_ja051d.srw` |
| `00862` | `W_JA051E` | **자료교환용 테이블별 자료조회 및 생성** | 사무관리 > 원장조회 > 기준가 | `ledgerinquiry` | `pb_recource/JA051/w_ja051e.srw` |
| `00879` | `W_MON2TASKLIIST` | **월별업무공지** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/bzplan/w_mon2taskliist.srw` |
| `00888` | `W_PLAN4U` | **회사일정** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/bzplan/w_plan4u.srw` |
| `00889` | `W_MON2TASK` | **회사별 일정보기** | 사무관리 > 시스템관리 > 일정 및 공지관리 | `systemmanagement` | `pb_recource/SYS/w_mon2task.srw` |
| `00909` | `W_JA021C` | **중간배당 및 확정등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021c.srw` |
| `00941` | `W_JA020F` | **발행기관별 보유현황(권리조회)** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA020/w_ja020f.srw` |
| `00965` | `W_PGM_MST_ALL` | **등록 프로그램 현황** | 사무관리 > 시스템관리 > 프로그램(권한) 관리 및 시스템정보 | `systemmanagement` | `pb_recource/SYS/w_pgm_mst_all.srw` |
| `01007` | `W_JA060C` | **분기 운용보고서** | 사무관리 > 보고서 > 보고서 | `reportmanagement` | `pb_recource/JA060/w_ja060c.srw` |
| `01010` | `W_JA060A` | **운용보고서 시장전망,계획 입력** | 사무관리 > 보고서 > 보고서 | `reportmanagement` | `pb_recource/JA060/w_ja060a.srw` |
| `01019` | `W_JA990B` | **매매처** | 사무관리 > 코드관리 > 기본(종목)정보 | `codemanagement` | `pb_recource/JA990/w_ja990b.srw` |
| `01030` | `W_JA010K` | **공모청약 수요예측 참여표(계좌)** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA010/w_ja010k.srw` |
| `01034` | `W_SCM1SM` | **채권단가등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_scm1sm.srw` |
| `01035` | `W_JA030B` | **주식 매매일별 현황** | 사무관리 > 자산운용 > 자산운용 | `assetmanagement` | `pb_recource/JA030/w_ja030b.srw` |
| `01042` | `W_SZZE370` | **분개장 등록** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_szze370.srw` |
| `01044` | `W_JA040C` | **손익차등 분개장 출력** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_ja040c.srw` |
| `01046` | `W_SKKR056_MC` | **손익차등 일 예상손익 계산현황** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_skkr056_mc.srw` |
| `01049` | `W_SKKR040` | **분개장 출력** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_skkr040.srw` |
| `01050` | `W_SKKR057` | **손익차등 계산계정 점검** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_skkr057.srw` |
| `01051` | `W_JA040B` | **손익차등 투자종목 관리** | 사무관리 > 손익차등 > 손익차등 | `differentialprofit` | `pb_recource/JA040/w_ja040b.srw` |
| `01055` | `W_SJT0SC` | **펀드 기준가(시가액)등록** | 사무관리 > 자문일일 > 일일작업 | `dailyadvisory` | `pb_recource/JA999/w_sjt0sc.srw` |
| `01056` | `W_JA021B` | **(자문사별)예상배당 확정등록** | 사무관리 > 공모청약(권리) > 공모청약(권리)관리 | `subscriptionrights` | `pb_recource/JA021/w_ja021b.srw` |
