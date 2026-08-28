package com.kfp.aams.domain.common.service;

import com.kfp.aams.domain.common.dto.DddwDto;
import com.kfp.aams.domain.common.dto.WdddwctlDto;
import com.kfp.aams.domain.common.mapper.DddwMapper;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DddwService {

    private final DddwMapper dddwMapper;
    private final JdbcTemplate jdbcTemplate;

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

        List<DddwDto> dddwList = new ArrayList<>();
        try {
            WdddwctlDto ctl = dddwMapper.selectWdddwctl(targetDddwId, targetSeq);

            if (ctl != null && ctl.getSqlColumns() != null && ctl.getSqlTables() != null) {
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
                }

                String finalSql = sqlBuilder.toString();
                log.info("Executing Dynamic DDDW Query [dddwId={}, seq={}] -> {}", targetDddwId, targetSeq, finalSql);

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
            } else {
                log.warn("WDDDWCTL metadata entry not found for [dddwId={}, seq={}]", targetDddwId, targetSeq);
            }
        } catch (Exception e) {
            log.error("Failed to execute dynamic DDDW query for [dddwId={}, seq={}] : {}", targetDddwId, targetSeq, e.getMessage(), e);
        }

        // Fallback default value if dynamic DDDW query returns empty or fails
        if (dddwList.isEmpty()) {
            dddwList.add(new DddwDto("", "데이터없음", ""));
        }

        // Store in Session for view/page access
        if (session != null) {
            String cacheKey = targetDddwId + "_" + targetSeq;
            session.setAttribute("DDDW_" + cacheKey, dddwList);
            session.setAttribute("DDDW_" + targetDddwId, dddwList);
        }

        return dddwList;
    }
}
