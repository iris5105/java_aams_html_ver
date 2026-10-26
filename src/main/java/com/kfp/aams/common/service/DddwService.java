package com.kfp.aams.common.service;

import com.kfp.aams.common.dto.DddwDto;
import com.kfp.aams.common.dto.WdddwctlDto;
import com.kfp.aams.common.mapper.DddwMapper;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
public class DddwService {

    private static final Logger sqlLog = LoggerFactory.getLogger("com.kfp.aams.sql");
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_CYAN = "\u001B[1;36m"; // Bold Cyan for DDDW
    private static final String ANSI_RED = "\u001B[1;31m";

    private static class CachedDddwEntry {
        final List<DddwDto> list;
        final String sql;

        CachedDddwEntry(List<DddwDto> list, String sql) {
            this.list = list;
            this.sql = sql;
        }
    }

    private final DddwMapper dddwMapper;
    private final JdbcTemplate jdbcTemplate;
    private final java.util.Map<String, CachedDddwEntry> dddwCache = new java.util.concurrent.ConcurrentHashMap<>();

    public DddwService(DddwMapper dddwMapper, JdbcTemplate jdbcTemplate) {
        this.dddwMapper = dddwMapper;
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * DDDW 메모리 캐시 초기화
     */
    public void clearCache() {
        dddwCache.clear();
        log.info("DDDW cache cleared.");
    }

    /**
     * Build dynamic SQL from WDDDWCTL metadata and fetch DddwDto key-value list.
     * 1st column = code (코드값)
     * 2nd column = name (화면 표출명)
     * Automatically caches in session under "DDDW_" + dddwNm
     */
    public List<DddwDto> getDddwList(String dddwId, String addWhere, HttpSession session) {
        return getDddwList(dddwId, 1, null, addWhere, null, session);
    }

    public List<DddwDto> getDddwList(String dddwId, String addWhere, String addOrderBy, HttpSession session) {
        return getDddwList(dddwId, 1, null, addWhere, addOrderBy, session);
    }

    public List<DddwDto> getDddwList(String dddwId, Integer seq, String addWhere, String addOrderBy, HttpSession session) {
        return getDddwList(dddwId, seq, null, addWhere, addOrderBy, session);
    }

    /**
     * Build dynamic SQL from WDDDWCTL metadata using dddwId and seq.
     * Replaces :corp_gr placeholder with corpGr parameter if provided.
     */
    public List<DddwDto> getDddwList(String dddwId, Integer seq, String corpGr, String addWhere, String addOrderBy, HttpSession session) {
        if (dddwId == null || dddwId.isBlank()) {
            return List.of(new DddwDto("", "데이터없음", ""));
        }

        String targetDddwId = dddwId.trim().toUpperCase();
        Integer targetSeq = (seq != null) ? seq : 1;

        // If dddwId comes in combined form like 'CORP_GR_1', parse into dddwId='CORP_GR', seq=1
        if (targetDddwId.contains("_")) {
            int lastUnderscore = targetDddwId.lastIndexOf('_');
            String potentialSeq = targetDddwId.substring(lastUnderscore + 1);
            if (potentialSeq.matches("\\d+")) {
                targetDddwId = targetDddwId.substring(0, lastUnderscore);
                targetSeq = Integer.parseInt(potentialSeq);
            }
        }

        String cacheKey = targetDddwId + ":" + targetSeq + ":" + (corpGr != null ? corpGr.trim() : "") + ":" + (addWhere != null ? addWhere.trim() : "") + ":" + (addOrderBy != null ? addOrderBy.trim() : "");
        if (dddwCache.containsKey(cacheKey)) {
            CachedDddwEntry cachedEntry = dddwCache.get(cacheKey);
            String displaySql = (cachedEntry != null && cachedEntry.sql != null && !cachedEntry.sql.isBlank())
                    ? cachedEntry.sql
                    : "";

            // 캐시 엔트리에 SQL이 누락되어 있을 경우 메타데이터로부터 즉시 조합
            if (displaySql == null || displaySql.isBlank()) {
                try {
                    WdddwctlDto ctl = dddwMapper.selectWdddwctl(targetDddwId, targetSeq);
                    displaySql = buildDynamicSql(ctl, corpGr, addWhere, addOrderBy);
                } catch (Exception ignored) {}
            }

            StringBuilder sb = new StringBuilder();
            sb.append(ANSI_CYAN).append("---------------- [Dynamic DDDW Cache HIT (f_dddwctl)] ----------------").append(ANSI_RESET).append("\n");
            sb.append("DDDW ID   : ").append(targetDddwId).append(" (Seq: ").append(targetSeq).append(")\n");
            if (corpGr != null && !corpGr.isBlank()) {
                sb.append("CorpGr    : ").append(corpGr).append("\n");
            }
            if (addWhere != null && !addWhere.isBlank()) {
                sb.append("AddWhere  : ").append(addWhere).append("\n");
            }
            if (addOrderBy != null && !addOrderBy.isBlank()) {
                sb.append("OrderBy   : ").append(addOrderBy).append("\n");
            }
            sb.append(ANSI_CYAN).append("-----------------------------------------------------------------------").append(ANSI_RESET).append("\n");
            if (displaySql != null && !displaySql.isBlank()) {
                sb.append(formatSql(displaySql)).append("\n");
                sb.append(ANSI_CYAN).append("-----------------------------------------------------------------------").append(ANSI_RESET).append("\n");
            }
            sb.append("CachedRows: ").append(cachedEntry != null ? cachedEntry.list.size() : 0).append("\n");
            sb.append(ANSI_CYAN).append("-----------------------------------------------------------------------").append(ANSI_RESET);
            sqlLog.info(sb.toString());
            return cachedEntry != null ? cachedEntry.list : List.of();
        }

        List<DddwDto> dddwList = new ArrayList<>();
        String finalSql = "";
        try {
            WdddwctlDto ctl = dddwMapper.selectWdddwctl(targetDddwId, targetSeq);
            finalSql = buildDynamicSql(ctl, corpGr, addWhere, addOrderBy);

            if (finalSql != null && !finalSql.isBlank()) {
                long startTime = System.currentTimeMillis();
                try {
                    dddwList = jdbcTemplate.query(finalSql, (rs, rowNum) -> {
                        int colCount = rs.getMetaData().getColumnCount();
                        String codeVal = rs.getString(1);
                        String nameVal = (colCount >= 2) ? rs.getString(2) : codeVal;
                        String fkeyVal = (colCount >= 3) ? rs.getString(3) : "";
                        return DddwDto.builder()
                                .code(codeVal != null ? codeVal.trim() : "")
                                .name(nameVal != null ? nameVal.trim() : "")
                                .fkey(fkeyVal != null ? fkeyVal.trim() : "")
                                .build();
                    });
                    long elapsedTime = System.currentTimeMillis() - startTime;

                    StringBuilder sb = new StringBuilder();
                    sb.append(ANSI_CYAN).append("---------------- [Dynamic DDDW SQL (f_dddwctl) (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
                    sb.append("DDDW ID   : ").append(targetDddwId).append(" (Seq: ").append(targetSeq).append(")\n");
                    if (corpGr != null && !corpGr.isBlank()) {
                        sb.append("CorpGr    : ").append(corpGr).append("\n");
                    }
                    if (addWhere != null && !addWhere.isBlank()) {
                        sb.append("AddWhere  : ").append(addWhere).append("\n");
                    }
                    if (addOrderBy != null && !addOrderBy.isBlank()) {
                        sb.append("OrderBy   : ").append(addOrderBy).append("\n");
                    }
                    sb.append(ANSI_CYAN).append("-----------------------------------------------------------------------").append(ANSI_RESET).append("\n");
                    sb.append(formatSql(finalSql)).append("\n");
                    sb.append(ANSI_CYAN).append("-----------------------------------------------------------------------").append(ANSI_RESET).append("\n");
                    sb.append("ResultRows: ").append(dddwList != null ? dddwList.size() : 0).append("\n");
                    sb.append(ANSI_CYAN).append("-----------------------------------------------------------------------").append(ANSI_RESET);
                    sqlLog.info(sb.toString());
                } catch (Exception e) {
                    long elapsedTime = System.currentTimeMillis() - startTime;
                    StringBuilder sb = new StringBuilder();
                    sb.append(ANSI_RED).append("---------------- [Dynamic DDDW SQL FAILED (").append(elapsedTime).append(")ms] ----------------").append(ANSI_RESET).append("\n");
                    sb.append("DDDW ID   : ").append(targetDddwId).append(" (Seq: ").append(targetSeq).append(")\n");
                    sb.append("Error     : ").append(e.getClass().getSimpleName()).append(": ").append(e.getMessage()).append("\n");
                    sb.append(ANSI_RED).append("-----------------------------------------------------------------------").append(ANSI_RESET).append("\n");
                    sb.append(formatSql(finalSql)).append("\n");
                    sb.append(ANSI_RED).append("-----------------------------------------------------------------------").append(ANSI_RESET);
                    sqlLog.error(sb.toString(), e);
                    throw e;
                }

                // 항상 앞의 코드(code) 값을 기준으로 오름차순 정렬 (자연어/숫자 정렬)
                if (dddwList != null && dddwList.size() > 1) {
                    dddwList.sort((a, b) -> {
                        String c1 = a.getCode() != null ? a.getCode().trim() : "";
                        String c2 = b.getCode() != null ? b.getCode().trim() : "";
                        if ("%".equals(c1) || c1.isEmpty()) return -1;
                        if ("%".equals(c2) || c2.isEmpty()) return 1;
                        try {
                            long n1 = Long.parseLong(c1);
                            long n2 = Long.parseLong(c2);
                            return Long.compare(n1, n2);
                        } catch (NumberFormatException ignored) {
                            return c1.compareTo(c2);
                        }
                    });
                }
            } else {
                log.warn("WDDDWCTL metadata entry not found for [dddwId={}, seq={}]", targetDddwId, targetSeq);
            }
        } catch (Exception e) {
            log.error("Failed to execute dynamic DDDW query for [dddwId={}, seq={}] : {}", targetDddwId, targetSeq, e.getMessage(), e);
        }

        // Cache in ConcurrentHashMap only when real data is found (do not cache empty fallback)
        if (dddwList != null && !dddwList.isEmpty()) {
            dddwCache.put(cacheKey, new CachedDddwEntry(dddwList, finalSql));
        } else {
            dddwList = new ArrayList<>();
            dddwList.add(new DddwDto("", "데이터없음", ""));
        }

        return dddwList;
    }

    /**
     * WDDDWCTL 메타데이터 및 바인딩 조건을 기반으로 동적 SQL 생성
     */
    public String buildDynamicSql(WdddwctlDto ctl, String corpGr, String addWhere, String addOrderBy) {
        if (ctl == null || ctl.getSqlColumns() == null || ctl.getSqlTables() == null) {
            return null;
        }

        String sqlColumns = ctl.getSqlColumns().trim();
        String sqlTables = ctl.getSqlTables().trim();
        String sqlWhere = ctl.getSqlWhere() != null ? ctl.getSqlWhere().trim() : "";
        String sqlOrderBy = ctl.getSqlOrderBy() != null ? ctl.getSqlOrderBy().trim() : "";

        String extraWhere = addWhere != null ? addWhere.trim() : "";
        String extraOrderBy = addOrderBy != null ? addOrderBy.trim() : "";

        // Determine raw corpGr value (from corpGr parameter or extracted from extraWhere)
        String rawCorpGr = "";
        if (corpGr != null && !corpGr.isBlank()) {
            rawCorpGr = corpGr.trim().replaceAll("'", "");
        } else if (!extraWhere.isEmpty()) {
            java.util.regex.Matcher matcher = java.util.regex.Pattern.compile("corp_gr\\s*=\\s*'?([^'\\s]+)'?", java.util.regex.Pattern.CASE_INSENSITIVE).matcher(extraWhere);
            if (matcher.find()) {
                rawCorpGr = matcher.group(1).replaceAll("'", "");
            }
        }

        // Replace :corp_gr placeholder in WDDDWCTL sqlWhere if present without duplicating single quotes
        if (!rawCorpGr.isEmpty() && sqlWhere.toLowerCase().contains(":corp_gr")) {
            sqlWhere = sqlWhere.replaceAll("(?i)'+:corp_gr'+", "'" + rawCorpGr + "'");
            sqlWhere = sqlWhere.replaceAll("(?i):corp_gr", "'" + rawCorpGr + "'");

            if (extraWhere.toLowerCase().replaceAll("\\s+", "").contains("corp_gr='" + rawCorpGr.toLowerCase() + "'") ||
                extraWhere.toLowerCase().replaceAll("\\s+", "").contains("corp_gr=" + rawCorpGr.toLowerCase())) {
                extraWhere = "";
            }
        }

        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("SELECT ").append(sqlColumns).append(" FROM ").append(sqlTables);

        boolean hasSqlWhere = !sqlWhere.isEmpty();
        boolean hasAddWhere = !extraWhere.isEmpty();

        if (hasSqlWhere && hasAddWhere) {
            sqlBuilder.append(" WHERE ").append(sqlWhere).append(" AND ").append(extraWhere);
        } else if (hasSqlWhere) {
            sqlBuilder.append(" WHERE ").append(sqlWhere);
        } else if (hasAddWhere) {
            sqlBuilder.append(" WHERE ").append(extraWhere);
        }

        String finalOrderBy = !extraOrderBy.isEmpty() ? extraOrderBy : sqlOrderBy;
        if (!finalOrderBy.isEmpty()) {
            sqlBuilder.append(" ORDER BY ").append(finalOrderBy);
        } else {
            sqlBuilder.append(" ORDER BY 1 ASC");
        }

        return sqlBuilder.toString();
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
