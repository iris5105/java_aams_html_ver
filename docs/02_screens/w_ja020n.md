# w_ja020n : 기준일자 공통 쿼리(SZX0AA_YMD) 연동 가이드

## 1. 화면 개요 및 공통 쿼리 전환 배경

- **프로그램 ID**: `W_JA020N` (w_ja020n)
- **메뉴 경로**: 사무관리 > 자문일일 > 자문일일 관리 화면
- **파워빌더 소스**: `pb_recource/JA020/w_ja020n.srw`
- **핵심 아키텍처 특징**:
  - 기존 여러 화면(`w_ja020n`, `w_ja010g`, `w_ja010h` 등)에서 중복 선언되어 사용되던 **펀드 기준일자 추출 쿼리**를 공통 매퍼인 [CommonMapper.xml](file:///d:/work/java_aams_html_ver/src/main/resources/mapper/common/CommonMapper.xml)의 `<sql id="SZX0AA_YMD">`로 추출하여 전사적으로 재참조하는 표준 모델을 확립한 화면입니다.

---

## 2. 공통 쿼리 구조 (`CommonMapper.xml :: SZX0AA_YMD`)

### 2.1 공통 SQL 조각 정의
```xml
<!-- src/main/resources/mapper/common/CommonMapper.xml -->
<mapper namespace="com.kfp.aams.domain.common.mapper.CommonMapper">

    <!-- 전사 공통 펀드 기준일자 추출 서브쿼리 -->
    <sql id="SZX0AA_YMD">
        SELECT A.CORP_GR,
               A.FUND_CD,
               CASE WHEN A.CORP_GR = '2402' THEN NVL(A.JUNYONG_YMD, A.HYUN_YMD)
                    ELSE A.HYUN_YMD
               END AS WORK_YMD
          FROM SZX0AA A
         WHERE A.CORP_GR = #{corpGr}
    </sql>

</mapper>
```

### 2.2 `Ja020nMapper.xml`에서의 공통 쿼리 재참조 (`<include>`)
```xml
<!-- src/main/resources/mapper/daily/Ja020nMapper.xml -->
<select id="selectFundWorkDateList" resultType="com.kfp.aams.domain.daily.dto.Ja020nDto">
    SELECT M.CORP_GR  AS corpGr,
           M.FUND_CD  AS fundCd,
           M.WORK_YMD AS workYmd,
           F.FUND_NM  AS fundNm
      FROM (
          <include refid="com.kfp.aams.domain.common.mapper.CommonMapper.SZX0AA_YMD"/>
      ) M
      JOIN SZX0AA F ON M.CORP_GR = F.CORP_GR AND M.FUND_CD = F.FUND_CD
     ORDER BY M.FUND_CD ASC
</select>
```

---

## 3. 데이터 조회 전체 시퀀스

```
[화면 진입 / 조회 버튼]
          │
          ▼ (1)
[w_ja020n.html :: loadData()]
  - API 호출: GET /api/daily/ja020n/list?corpGr=...
          │
          ▼ (2)
[Ja020nController.java :: getList()]
          │
          ▼ (3)
[Ja020nService.java :: getList()]
          │
          ▼ (4)
[Ja020nMapper.java :: selectFundWorkDateList()]
          │
          ▼ (5)
[CommonMapper.xml :: SZX0AA_YMD 조인 실행]
          │
          ▼ (6)
[Tabulator 그리드 렌더링]
  - 펀드코드, 펀드명, 작업기준일자 표출
```

---

## 4. 유지보수 가이드 및 개발 규칙 준수

1. **동일 쿼리 신규 개발 금지**:
   - 펀드별 기준일자(`JUNYONG_YMD`/`HYUN_YMD`) 조건이 필요한 다른 신규 화면 개발 시 인라인 서브쿼리를 새로 작성하지 않고 반드시 `<include refid="com.kfp.aams.domain.common.mapper.CommonMapper.SZX0AA_YMD"/>`를 참조해야 합니다.
2. **기준일자 산출 로직 변경 시**:
   - `CommonMapper.xml`의 해당 `<sql>` 태그 한 곳만 수정하면 이를 참조하는 모든 화면(`w_ja020n`, `w_ja010g`, `w_ja010h` 등)에 안전하게 일괄 적용됩니다.
