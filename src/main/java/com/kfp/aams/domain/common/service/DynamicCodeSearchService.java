package com.kfp.aams.domain.common.service;

import com.kfp.aams.domain.common.dto.DynamicCodeSearchDto;
import com.kfp.aams.domain.common.mapper.DynamicCodeSearchMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSetMetaData;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DynamicCodeSearchService {

    private final DynamicCodeSearchMapper dynamicCodeSearchMapper;
    private final JdbcTemplate jdbcTemplate;

    /**
     * 코드검색 메타데이터 설정 조회 (타이틀, 헤더 컬럼 구조)
     */
    public Map<String, Object> getConfig(String columnNm, Integer columnSeq) {
        DynamicCodeSearchDto master = dynamicCodeSearchMapper.selectCodeSearchMaster(columnNm, columnSeq);
        if (master == null) {
            log.warn("No code search metadata found for columnNm={}, seq={}", columnNm, columnSeq);
            return Collections.emptyMap();
        }

        Map<String, Object> result = new HashMap<>();
        result.put("columnNm", master.getColumnNm());
        result.put("columnSeq", master.getColumnSeq());
        result.put("cmnt", master.getCmnt() != null ? master.getCmnt().trim() : "코드 선택");
        result.put("returnColumn", master.getReturnColumn());
        result.put("windowNm", master.getWindowNm());

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
        DynamicCodeSearchDto master = dynamicCodeSearchMapper.selectCodeSearchMaster(columnNm, columnSeq);
        if (master == null || master.getCodeSelect() == null) {
            return Collections.emptyList();
        }

        String sql = master.getCodeSelect();
        sql = sql.replace("':corp_gr'", "'" + (corpGr != null ? corpGr.trim() : "") + "'");
        sql = sql.replace(":corp_gr", "'" + (corpGr != null ? corpGr.trim() : "") + "'");

        log.debug("DynamicCodeSearch SQL for {} ({}): {}", columnNm, columnSeq, sql);

        List<Map<String, Object>> rawList;
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
        } catch (Exception e) {
            log.error("Failed to execute dynamic code search SQL: {}", sql, e);
            return Collections.emptyList();
        }

        // 키워드 필터링 및 ROWNUM 번호 부여
        List<Map<String, Object>> filteredList = new ArrayList<>();
        int seqNo = 1;
        String kw = (keyword != null) ? keyword.trim().toLowerCase() : "";

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
     * 단일 코드값 검증 및 명칭 조회 (EDIT_SELECT 기반 - ue_setcode)
     */
    public Map<String, Object> getCodeItem(String columnNm, Integer columnSeq, String corpGr, String code) {
        if (code == null || code.isBlank()) {
            return null;
        }

        DynamicCodeSearchDto master = dynamicCodeSearchMapper.selectCodeSearchMaster(columnNm, columnSeq);
        if (master == null || master.getEditSelect() == null) {
            return null;
        }

        String sql = master.getEditSelect();
        sql = sql.replace("':corp_gr'", "'" + (corpGr != null ? corpGr.trim() : "") + "'");
        sql = sql.replace(":corp_gr", "'" + (corpGr != null ? corpGr.trim() : "") + "'");
        sql = sql.replace("':arg_code'", "'" + code.trim() + "'");
        sql = sql.replace(":arg_code", "'" + code.trim() + "'");

        log.debug("DynamicCodeSearch EDIT_SELECT SQL: {}", sql);

        List<Map<String, Object>> list;
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
        } catch (Exception e) {
            log.error("Failed to execute EDIT_SELECT SQL: {}", sql, e);
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
}
