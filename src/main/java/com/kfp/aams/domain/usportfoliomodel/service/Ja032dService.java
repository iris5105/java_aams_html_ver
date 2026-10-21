package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dColumnDataDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dMasterDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032dStatusDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032dMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * W_JA032D (API 자료요청 현황) 서비스
 */
@Service
@Transactional(readOnly = true)
public class Ja032dService {

    private static final Logger log = LoggerFactory.getLogger(Ja032dService.class);

    private final Ja032dMapper ja032dMapper;
    private final JdbcTemplate jdbcTemplate;

    // 명시적 생성자 주입 (Zero-Lombok-ECJ-Conflict 원칙, 규정 01-4)
    public Ja032dService(Ja032dMapper ja032dMapper, JdbcTemplate jdbcTemplate) {
        this.ja032dMapper = ja032dMapper;
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * 1. API 요청 현황 마스터 목록 조회 (d_ja032d1)
     */
    public List<Ja032dMasterDto> getMasterList(String ymd) {
        if (ymd == null || ymd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032dMapper.selectMasterList(ymd.trim());
    }

    /**
     * 2. API 요청 상세 건별 목록 조회 (d_ja032d2)
     */
    public List<Ja032dDetailDto> getDetailList(String company, String url, String dt) {
        if (company == null || url == null || dt == null) {
            return Collections.emptyList();
        }
        return ja032dMapper.selectDetailList(company.trim(), url.trim(), dt.trim());
    }

    /**
     * 3. API 처리상태 요약 조회 (d_ja032d3)
     */
    public Ja032dStatusDto getStatus(String apiKey) {
        if (apiKey == null || apiKey.isBlank()) {
            return null;
        }
        return ja032dMapper.selectStatus(apiKey.trim());
    }

    /**
     * 4. 테이블 컬럼 메타정보 및 실제 데이터 값 조회 (d_ja032d4)
     */
    public Map<String, Object> getColumnDataList(String tableName, String apiKey, Integer pageIndex) {
        Map<String, Object> resultMap = new HashMap<>();
        if (tableName == null || tableName.isBlank() || apiKey == null || apiKey.isBlank()) {
            resultMap.put("curRow", 0);
            resultMap.put("allRow", 0);
            resultMap.put("list", Collections.emptyList());
            return resultMap;
        }

        String safeTableName = tableName.trim().toUpperCase();
        // SQL Injection 방어: 테이블명은 영문자, 숫자, 언더스코어만 허용
        if (!safeTableName.matches("^[A-Z0-9_]+$")) {
            log.warn("유효하지 않은 테이블명 요청 차단: {}", tableName);
            resultMap.put("curRow", 0);
            resultMap.put("allRow", 0);
            resultMap.put("list", Collections.emptyList());
            return resultMap;
        }

        // 1) 컬럼 메타정보 조회
        List<Ja032dColumnDataDto> columns = ja032dMapper.selectColumnsByTableName(safeTableName);
        if (columns == null || columns.isEmpty()) {
            resultMap.put("curRow", 0);
            resultMap.put("allRow", 0);
            resultMap.put("list", Collections.emptyList());
            return resultMap;
        }

        // 2) 실제 데이터 테이블 조회
        int targetIndex = (pageIndex != null && pageIndex > 0) ? pageIndex : 1;
        int totalRows = 0;
        Map<String, Object> rowData = null;

        try {
            String sql = "SELECT * FROM " + safeTableName + " WHERE API_KEY = ?";
            List<Map<String, Object>> dataRows = jdbcTemplate.queryForList(sql, apiKey.trim());
            totalRows = dataRows.size();

            if (totalRows > 0) {
                if (targetIndex > totalRows) targetIndex = totalRows;
                rowData = dataRows.get(targetIndex - 1);
            }
        } catch (Exception e) {
            log.warn("테이블 데이터 조회 실패 (테이블: {}, API_KEY: {}): {}", safeTableName, apiKey, e.getMessage());
        }

        // 3) 컬럼별 값 바인딩
        if (rowData != null) {
            // 대소문자 무관 탐색을 위해 맵 키를 대문자로 변환한 맵 구성
            Map<String, Object> upperMap = new HashMap<>();
            for (Map.Entry<String, Object> entry : rowData.entrySet()) {
                upperMap.put(entry.getKey().toUpperCase(), entry.getValue());
            }

            for (Ja032dColumnDataDto col : columns) {
                String colName = (col.getColumnName() != null) ? col.getColumnName().toUpperCase() : "";
                Object val = upperMap.get(colName);
                col.setColVal(val != null ? String.valueOf(val) : "");
            }
        }

        resultMap.put("curRow", totalRows > 0 ? targetIndex : 0);
        resultMap.put("allRow", totalRows);
        resultMap.put("list", columns);
        return resultMap;
    }

    /**
     * 5. SR_JA032D 프로시저 호출 (한투파생시가)
     */
    @Transactional
    public String executeSrJa032d(String corpGr, String ymd) {
        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr);
        params.put("ymd", ymd != null ? ymd.replace("-", "") : "");
        params.put("retMsg", "");

        ja032dMapper.callSrJa032d(params);
        return (String) params.get("retMsg");
    }

    /**
     * 6. API_KSE 프로시저 호출 (국내주식요청)
     */
    @Transactional
    public String executeApiKse(String corpGr, String ymd) {
        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr);
        params.put("ymd", ymd != null ? ymd.replace("-", "") : "");
        params.put("retMsg", "");

        ja032dMapper.callApiKse(params);
        return (String) params.get("retMsg");
    }

    /**
     * 7. API_13_02 프로시저 호출 (해외주식신규)
     */
    @Transactional
    public String executeApi1302(String corpGr) {
        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr);
        params.put("retMsg", "");

        ja032dMapper.callApi1302(params);
        return (String) params.get("retMsg");
    }

    /**
     * 8. API_17_16 프로시저 호출 (한투파생종가)
     */
    @Transactional
    public String executeApi1716(String corpGr, String ymd) {
        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr);
        params.put("ymd", ymd != null ? ymd.replace("-", "") : "");
        params.put("retMsg", "");

        ja032dMapper.callApi1716(params);
        return (String) params.get("retMsg");
    }

    /**
     * 9. NEW_13_02 프로시저 호출 (해외일괄재신청)
     */
    @Transactional
    public String executeNew1302(String corpGr, String ymd) {
        Map<String, Object> params = new HashMap<>();
        params.put("corpGr", corpGr);
        params.put("ymd", ymd != null ? ymd.replace("-", "") : "");
        params.put("retMsg", "");

        ja032dMapper.callNew1302(params);
        return (String) params.get("retMsg");
    }
}
