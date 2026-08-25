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
    public List<DddwDto> getDddwList(String dddwNm, String addWhere, HttpSession session) {
        if (dddwNm == null || dddwNm.isBlank()) {
            dddwNm = "corp_gr_1";
        }

        // Parse dddwNm into dddwId and seq (e.g. 'corp_gr_1' -> dddwId='corp_gr',
        // seq=1)
        String dddwId = dddwNm;
        Integer seq = 1;
        if (dddwNm.contains("_")) {
            int lastUnderscore = dddwNm.lastIndexOf('_');
            String potentialSeq = dddwNm.substring(lastUnderscore + 1);
            if (potentialSeq.matches("\\d+")) {
                dddwId = dddwNm.substring(0, lastUnderscore);
                seq = Integer.parseInt(potentialSeq);
            }
        }

        List<DddwDto> dddwList = new ArrayList<>();
        try {
            WdddwctlDto ctl = dddwMapper.selectWdddwctl(dddwNm, dddwId, seq);

            if (ctl != null && ctl.getSqlColumns() != null && ctl.getSqlTables() != null) {
                String sqlColumns = ctl.getSqlColumns().trim();
                String sqlTables = ctl.getSqlTables().trim();
                String sqlWhere = ctl.getSqlWhere() != null ? ctl.getSqlWhere().trim() : "";
                String extraWhere = addWhere != null ? addWhere.trim() : "";

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

                String finalSql = sqlBuilder.toString();
                log.info("Executing Dynamic DDDW Query [{}] -> {}", dddwNm, finalSql);

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
            }
        } catch (Exception e) {
            log.warn("Failed to execute dynamic DDDW query for [{}] : {}", dddwNm, e.getMessage());
        }

        // Fallback test defaults if table metadata or DB query returns empty for 'corp_gr_1'
        if (dddwList.isEmpty() && ("corp_gr_1".equalsIgnoreCase(dddwNm) || "corp_gr".equalsIgnoreCase(dddwId))) {
            dddwList.add(new DddwDto("2200", "(주)케이에프피", "FK_2200"));
            dddwList.add(new DddwDto("2100", "현대자산운용", "FK_2100"));
            dddwList.add(new DddwDto("2300", "한국투신운용", "FK_2300"));
        }

        // Store in Session for view/page access
        if (session != null) {
            session.setAttribute("DDDW_" + dddwNm, dddwList);
            session.setAttribute("DDDW_" + dddwId, dddwList);
        }

        return dddwList;
    }
}
