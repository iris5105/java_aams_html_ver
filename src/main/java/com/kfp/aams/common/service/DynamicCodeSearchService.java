package com.kfp.aams.common.service;

import com.kfp.aams.common.dto.DynamicCodeSearchDto;
import com.kfp.aams.common.mapper.DynamicCodeSearchMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSetMetaData;
import java.util.*;

@Slf4j
@Service
@Transactional(readOnly = true)
public class DynamicCodeSearchService {

    private static final Logger sqlLog = LoggerFactory.getLogger("com.kfp.aams.sql");
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_MAGENTA = "\u001B[1;35m"; // Bold Magenta for Dynamic Code Search
    private static final String ANSI_RED = "\u001B[1;31m";

    private final DynamicCodeSearchMapper dynamicCodeSearchMapper;
    private final JdbcTemplate jdbcTemplate;

    // ConcurrentHashMap 기반 메타데이터 캐시 (30분 TTL)
    private final Map<String, CachedMaster> masterCache = new java.util.concurrent.ConcurrentHashMap<>();
    private static final long CACHE_TTL_MS = 30 * 60 * 1000L;

    private static class CachedMaster {
        final DynamicCodeSearchDto dto;
        final long timestamp;

        CachedMaster(DynamicCodeSearchDto dto) {
            this.dto = dto;
            this.timestamp = System.currentTimeMillis();
        }

        boolean isExpired() {
            return System.currentTimeMillis() - timestamp > CACHE_TTL_MS;
        }
    }

    public DynamicCodeSearchService(DynamicCodeSearchMapper dynamicCodeSearchMapper, JdbcTemplate jdbcTemplate) {
        this.dynamicCodeSearchMapper = dynamicCodeSearchMapper;
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * 메타데이터 캐시 조회 (ConcurrentHashMap 기반, 없거나 만료 시 DB 조회 후 캐싱)
     */
    public DynamicCodeSearchDto getMasterMetadata(String columnNm, Integer columnSeq) {
        if (columnNm == null || columnNm.isBlank()) {
            return null;
        }
        int targetSeq = (columnSeq != null) ? columnSeq : 1;
        String cacheKey = columnNm.trim().toLowerCase() + "_" + targetSeq;

        CachedMaster cached = masterCache.get(cacheKey);
        if (cached != null && !cached.isExpired()) {
            return cached.dto;
        }

        DynamicCodeSearchDto fresh = dynamicCodeSearchMapper.selectCodeSearchMaster(columnNm, targetSeq);
        if (fresh != null) {
            masterCache.put(cacheKey, new CachedMaster(fresh));
        }
        return fresh;
    }

    /**
     * 메타데이터 캐시 수동 초기화
     */
    public void clearCache() {
        masterCache.clear();
        log.info("DynamicCodeSearch master cache cleared.");
    }

    /**
     * 코드검색 메타데이터 설정 조회 (타이틀, 헤더 컬럼 구조)
     */
    public Map<String, Object> getConfig(String columnNm, Integer columnSeq) {
        DynamicCodeSearchDto master = getMasterMetadata(columnNm, columnSeq);
        if (master == null) {
            log.warn("No code search metadata found for columnNm={}, seq={}", columnNm, columnSeq);
            return Collections.emptyMap();
        }
        return buildConfig(master);
    }

    /**
     * master DTO로부터 config 맵 파싱 및 생성
     */
    public Map<String, Object> buildConfig(DynamicCodeSearchDto master) {
        if (master == null) {
            return Collections.emptyMap();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("columnNm", master.getColumnNm());
        result.put("columnSeq", master.getColumnSeq());
        result.put("cmnt", master.getCmnt() != null ? master.getCmnt().trim() : "코드 선택");
        result.put("returnColumn", master.getReturnColumn());
        result.put("windowNm", master.getWindowNm());
        result.put("columnSize", master.getColumnSize());

        // 헤더 파싱 (구분자 '@')
        List<Map<String, String>> headerList = new ArrayList<>();
        if (master.getHeaderNm() != null && !master.getHeaderNm().isBlank()) {
            String[] tokens = master.getHeaderNm().split("@");
            for (int i = 0; i < tokens.length; i++) {
                String label = tokens[i].trim();
                // ^ (숨김/키) 또는 > (우측정렬) 접두사 정제
                while (label.startsWith("^") || label.startsWith(">")) {
                    label = label.substring(1).trim();
                }
                Map<String, String> col = new HashMap<>();
                col.put("index", String.valueOf(i));
                col.put("title", label);
                headerList.add(col);
            }
        }
        result.put("headers", headerList);

        return result;
    }

    /**
     * 모달 팝업 목록 조회 (CODE_SELECT 기반)
     */
    public List<Map<String, Object>> getCodeList(String columnNm, Integer columnSeq, String corpGr, String keyword) {
        return getCodeList(columnNm, columnSeq, corpGr, keyword, null);
    }

    /**
     * 모달 팝업 목록 조회 (CODE_SELECT 기반, addWhere 추가 조건 지원)
     */
    public List<Map<String, Object>> getCodeList(String columnNm, Integer columnSeq, String corpGr, String keyword, String addWhere) {
        DynamicCodeSearchDto master = getMasterMetadata(columnNm, columnSeq);
        return executeCodeList(master, columnNm, columnSeq, corpGr, keyword, addWhere);
    }

    /**
     * master DTO로부터 실제 데이터 쿼리(CODE_SELECT) 실행 및 매핑
     */
    public List<Map<String, Object>> executeCodeList(DynamicCodeSearchDto master, String columnNm, Integer columnSeq, String corpGr, String keyword, String addWhere) {
        if (master == null || master.getCodeSelect() == null) {
            return Collections.emptyList();
        }

        String sql = master.getCodeSelect();
        sql = sql.replace("':corp_gr'", "'" + (corpGr != null ? corpGr.trim() : "") + "'");
        sql = sql.replace(":corp_gr", "'" + (corpGr != null ? corpGr.trim() : "") + "'");
        sql = applyAddWhere(sql, addWhere);

        List<Map<String, Object>> rawList;
        long startTime = System.currentTimeMillis();
        try {
            rawList = jdbcTemplate.query(sql, (rs, rowNum) -> {
                ResultSetMetaData meta = rs.getMetaData();
                int colCount = meta.getColumnCount();
                Map<String, Object> map = new LinkedHashMap<>();
                for (int i = 1; i <= colCount; i++) {
                    String colName = meta.getColumnLabel(i).toLowerCase();
                    map.put(colName, rs.getObject(i));
                }
                return map;
            });
            long elapsedTime = System.currentTimeMillis() - startTime;

            StringBuilder sb = new StringBuilder();
            sb.append(ANSI_MAGENTA).append("---------------- [Dynamic Code Search SQL (dynamicsearch - CODE_SELECT) (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
            sb.append("Column    : ").append(columnNm).append(" (Seq: ").append(columnSeq).append(")\n");
            if (corpGr != null && !corpGr.isBlank()) {
                sb.append("CorpGr    : ").append(corpGr).append("\n");
            }
            if (keyword != null && !keyword.isBlank()) {
                sb.append("Keyword   : ").append(keyword).append("\n");
            }
            if (addWhere != null && !addWhere.isBlank()) {
                sb.append("AddWhere  : ").append(addWhere).append("\n");
            }
            sb.append(ANSI_MAGENTA).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET).append("\n");
            sb.append(formatSql(sql)).append("\n");
            sb.append("ResultRows: ").append(rawList != null ? rawList.size() : 0).append("\n");
            sb.append(ANSI_MAGENTA).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET);
            sqlLog.info(sb.toString());
        } catch (Exception e) {
            long elapsedTime = System.currentTimeMillis() - startTime;
            StringBuilder sb = new StringBuilder();
            sb.append(ANSI_RED).append("---------------- [Dynamic Code Search SQL FAILED (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
            sb.append("Column    : ").append(columnNm).append(" (Seq: ").append(columnSeq).append(")\n");
            sb.append("Error     : ").append(e.getClass().getSimpleName()).append(": ").append(e.getMessage()).append("\n");
            sb.append(ANSI_RED).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET).append("\n");
            sb.append(formatSql(sql)).append("\n");
            sb.append(ANSI_RED).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET);
            sqlLog.error(sb.toString(), e);
            return Collections.emptyList();
        }

        // 키워드 필터링 및 ROWNUM 번호 부여
        List<Map<String, Object>> filteredList = new ArrayList<>();
        int seqNo = 1;
        String kw = (keyword != null) ? keyword.trim().toLowerCase() : "";

        // w_srs_cd.srw: ue_setcodesearch rs_addrow = '%,전체,' 지원 (rcd seq 51)
        if ("rcd".equalsIgnoreCase(columnNm) && Integer.valueOf(51).equals(columnSeq)) {
            if (kw.isEmpty() || "%".contains(kw) || "전체".contains(kw)) {
                Map<String, Object> defaultAllRow = new LinkedHashMap<>();
                defaultAllRow.put("fseq", seqNo++);
                defaultAllRow.put("codeVal", "%");
                defaultAllRow.put("codeName", "전체");
                defaultAllRow.put("display", "(%) 전체");
                defaultAllRow.put("isin_cd", "%");
                defaultAllRow.put("blbg_tckr", "%");
                defaultAllRow.put("jm_nm", "전체");
                filteredList.add(defaultAllRow);
            }
        }

        for (Map<String, Object> row : rawList) {
            boolean match = true;
            if (!kw.isEmpty()) {
                match = false;
                for (Object val : row.values()) {
                    if (val != null && String.valueOf(val).toLowerCase().contains(kw)) {
                        match = true;
                        break;
                    }
                }
            }

            if (match) {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("fseq", seqNo++);
                item.putAll(row);

                // 첫 번째 컬럼을 code, 두 번째 컬럼을 codeName으로 기본 매핑
                List<String> keys = new ArrayList<>(row.keySet());
                if (!keys.isEmpty()) {
                    item.put("codeVal", String.valueOf(row.get(keys.get(0))));
                }
                if (keys.size() > 1) {
                    item.put("codeName", String.valueOf(row.get(keys.get(1))));
                }

                filteredList.add(item);
            }
        }

        return filteredList;
    }

    /**
     * 모달 팝업 데이터 단일 조회 (config 메타데이터 + list 데이터 목록을 1번에 반환)
     */
    public Map<String, Object> getModalData(String columnNm, Integer columnSeq, String corpGr, String keyword, String addWhere) {
        DynamicCodeSearchDto master = getMasterMetadata(columnNm, columnSeq);
        Map<String, Object> config = buildConfig(master);
        List<Map<String, Object>> list = executeCodeList(master, columnNm, columnSeq, corpGr, keyword, addWhere);

        Map<String, Object> result = new HashMap<>();
        result.put("config", config);
        result.put("list", list);
        return result;
    }

    /**
     * 단일 코드값 검증 및 명칭 조회 (EDIT_SELECT 기반 - ue_setcode)
     */
    public Map<String, Object> getCodeItem(String columnNm, Integer columnSeq, String corpGr, String code) {
        return getCodeItem(columnNm, columnSeq, corpGr, code, null);
    }

    /**
     * 단일 코드값 검증 및 명칭 조회 (EDIT_SELECT 기반 - ue_setcode, addWhere 추가 조건 지원)
     */
    public Map<String, Object> getCodeItem(String columnNm, Integer columnSeq, String corpGr, String code, String addWhere) {
        if (code == null || code.isBlank()) {
            return null;
        }

        // '%' 전체 코드 지원 (w_srs_cd 등 rs_addrow)
        if ("%".equals(code.trim())) {
            Map<String, Object> allItem = new LinkedHashMap<>();
            allItem.put("code", "%");
            allItem.put("codename", "전체");
            allItem.put("codeName", "전체");
            allItem.put("name", "전체");
            allItem.put("display", "(%) 전체");
            return allItem;
        }

        DynamicCodeSearchDto master = getMasterMetadata(columnNm, columnSeq);
        if (master == null || master.getEditSelect() == null) {
            return null;
        }

        String sql = master.getEditSelect();
        sql = sql.replace("':corp_gr'", "'" + (corpGr != null ? corpGr.trim() : "") + "'");
        sql = sql.replace(":corp_gr", "'" + (corpGr != null ? corpGr.trim() : "") + "'");
        sql = sql.replace("':arg_code'", "'" + code.trim() + "'");
        sql = sql.replace(":arg_code", "'" + code.trim() + "'");
        sql = applyAddWhere(sql, addWhere);

        List<Map<String, Object>> list;
        long startTime = System.currentTimeMillis();
        try {
            list = jdbcTemplate.query(sql, (rs, rowNum) -> {
                ResultSetMetaData meta = rs.getMetaData();
                int colCount = meta.getColumnCount();
                Map<String, Object> map = new LinkedHashMap<>();
                for (int i = 1; i <= colCount; i++) {
                    map.put(meta.getColumnLabel(i).toLowerCase(), rs.getObject(i));
                }
                return map;
            });
            long elapsedTime = System.currentTimeMillis() - startTime;

            String codeName = "";
            if (!list.isEmpty()) {
                Map<String, Object> firstRow = list.get(0);
                List<String> keys = new ArrayList<>(firstRow.keySet());
                codeName = !keys.isEmpty() && firstRow.get(keys.get(0)) != null ? String.valueOf(firstRow.get(keys.get(0))) : "";
            }

            StringBuilder sb = new StringBuilder();
            sb.append(ANSI_MAGENTA).append("---------------- [Dynamic Code Search SQL (dynamicsearch - EDIT_SELECT) (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
            sb.append("Column    : ").append(columnNm).append(" (Seq: ").append(columnSeq).append(")\n");
            sb.append("Code      : ").append(code).append("\n");
            if (corpGr != null && !corpGr.isBlank()) {
                sb.append("CorpGr    : ").append(corpGr).append("\n");
            }
            if (addWhere != null && !addWhere.isBlank()) {
                sb.append("AddWhere  : ").append(addWhere).append("\n");
            }
            sb.append(ANSI_MAGENTA).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET).append("\n");
            sb.append(formatSql(sql)).append("\n");
            sb.append("FoundName : ").append(codeName.isEmpty() ? "(없음)" : codeName).append("\n");
            sb.append(ANSI_MAGENTA).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET);
            sqlLog.info(sb.toString());
        } catch (Exception e) {
            long elapsedTime = System.currentTimeMillis() - startTime;
            StringBuilder sb = new StringBuilder();
            sb.append(ANSI_RED).append("---------------- [Dynamic Code Search SQL FAILED (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
            sb.append("Column    : ").append(columnNm).append(" (Seq: ").append(columnSeq).append(")\n");
            sb.append("Code      : ").append(code).append("\n");
            sb.append("Error     : ").append(e.getClass().getSimpleName()).append(": ").append(e.getMessage()).append("\n");
            sb.append(ANSI_RED).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET).append("\n");
            sb.append(formatSql(sql)).append("\n");
            sb.append(ANSI_RED).append("-----------------------------------------------------------------------------------------------").append(ANSI_RESET);
            sqlLog.error(sb.toString(), e);
            return null;
        }

        if (list.isEmpty()) {
            return null;
        }

        Map<String, Object> firstRow = list.get(0);
        List<String> keys = new ArrayList<>(firstRow.keySet());
        String codeName = !keys.isEmpty() && firstRow.get(keys.get(0)) != null ? String.valueOf(firstRow.get(keys.get(0))) : "";

        Map<String, Object> result = new LinkedHashMap<>(firstRow);
        result.put("code", code.trim());
        result.put("codeName", codeName);
        result.put("display", "(" + code.trim() + ") " + codeName);

        return result;
    }

    /**
     * 파워빌더 ue_setcodesearch rs_Where 절을 동적 SQL에 병합
     */
    private String applyAddWhere(String sql, String addWhere) {
        if (addWhere == null || addWhere.trim().isEmpty()) {
            return sql;
        }
        String trimmedWhere = addWhere.trim();
        if (trimmedWhere.endsWith(";")) {
            trimmedWhere = trimmedWhere.substring(0, trimmedWhere.length() - 1).trim();
        }

        int orderByIdx = sql.toUpperCase().lastIndexOf("ORDER BY");
        if (orderByIdx > 0) {
            String mainSql = sql.substring(0, orderByIdx);
            String orderSql = sql.substring(orderByIdx);
            if (mainSql.toUpperCase().contains("WHERE")) {
                return mainSql + " AND (" + trimmedWhere + ") " + orderSql;
            } else {
                return mainSql + " WHERE (" + trimmedWhere + ") " + orderSql;
            }
        } else {
            if (sql.toUpperCase().contains("WHERE")) {
                return sql + " AND (" + trimmedWhere + ")";
            } else {
                return sql + " WHERE (" + trimmedWhere + ")";
            }
        }
    }

    /**
     * 한 줄로 작성된 동적 SQL을 가독성 있게 들여쓰기/줄바꿈 포맷팅
     */
    private static String formatSql(String sql) {
        if (sql == null || sql.isBlank()) return "";
        return sql.trim()
                .replaceAll("(?i)\\s+SELECT\\s+", "\nSELECT ")
                .replaceAll("(?i)\\s+FROM\\s+", "\n  FROM ")
                .replaceAll("(?i)\\s+JOIN\\s+", "\n  JOIN ")
                .replaceAll("(?i)\\s+LEFT OUTER JOIN\\s+", "\n  LEFT OUTER JOIN ")
                .replaceAll("(?i)\\s+LEFT JOIN\\s+", "\n  LEFT JOIN ")
                .replaceAll("(?i)\\s+RIGHT JOIN\\s+", "\n  RIGHT JOIN ")
                .replaceAll("(?i)\\s+INNER JOIN\\s+", "\n  INNER JOIN ")
                .replaceAll("(?i)\\s+WHERE\\s+", "\n WHERE ")
                .replaceAll("(?i)\\s+AND\\s+", "\n   AND ")
                .replaceAll("(?i)\\s+OR\\s+", "\n    OR ")
                .replaceAll("(?i)\\s+GROUP BY\\s+", "\n GROUP BY ")
                .replaceAll("(?i)\\s+ORDER BY\\s+", "\n ORDER BY ");
    }
}
