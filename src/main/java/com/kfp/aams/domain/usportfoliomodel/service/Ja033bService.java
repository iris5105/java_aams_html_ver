package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja033bDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja033bMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * KRX 지수 선물/옵션 종목 서비스 (W_JA033B)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja033bService {

    private final Ja033bMapper ja033bMapper;

    /**
     * 지수 선물/옵션 종목 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja033bDto> getFoIdxCodeList(String infoType) {
        String cleanType = null;
        if (infoType != null && !infoType.isBlank() && !"%".equals(infoType.trim()) && !"ALL".equalsIgnoreCase(infoType.trim())) {
            cleanType = infoType.trim();
        }
        return ja033bMapper.selectFoIdxCodeList(cleanType);
    }

    /**
     * 지수 선물/옵션 종목 그리드 일괄 저장 (CUD)
     */
    @Transactional
    public void saveFoIdxCodeList(List<Ja033bDto> list) {
        if (list == null || list.isEmpty()) {
            return;
        }

        for (Ja033bDto dto : list) {
            if (dto.getInfoType() == null || dto.getInfoType().isBlank()
                    || dto.getStndIscd() == null || dto.getStndIscd().isBlank()) {
                continue;
            }

            dto.setInfoType(dto.getInfoType().trim());
            dto.setStndIscd(dto.getStndIscd().trim());
            if (dto.getShrnIscd() != null) dto.setShrnIscd(dto.getShrnIscd().trim());

            log.info("Processing FO_IDX_CODE item: infoType={}, stndIscd={}, status={}, isNew={}",
                    dto.getInfoType(), dto.getStndIscd(), dto.getRowStatus(), dto.getIsNew());

            // 1) 삭제 처리
            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                int cnt = ja033bMapper.deleteFoIdxCode(dto.getInfoType(), dto.getStndIscd());
                log.info("deleteFoIdxCode result: {}", cnt);
            }
            // 2) 신규 등록
            else if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                int cnt = ja033bMapper.mergeFoIdxCode(dto);
                log.info("mergeFoIdxCode result: {}", cnt);
            }
            // 3) 수정
            else if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                int cnt = ja033bMapper.updateFoIdxCode(dto);
                log.info("updateFoIdxCode result: {}", cnt);
            }
        }
    }

    /**
     * 파워빌더 w_ja033b.srw::cb_load 로직 100% 반영:
     * 마스터 파일(fo_idx*.mst) 파싱 후 FO_IDX_CODE 등록
     */
    @Transactional
    public Map<String, Object> loadMasterFile(MultipartFile file) throws Exception {
        Map<String, Object> result = new HashMap<>();
        if (file == null || file.isEmpty()) {
            result.put("success", false);
            result.put("message", "업로드할 파일이 비어 있습니다.");
            return result;
        }

        int totalCount = 0;
        int insertCount = 0;

        // 한글 인코딩 시도 (EUC-KR / MS949 우선)
        Charset charset = Charset.forName("EUC-KR");
        try (BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream(), charset))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                totalCount++;
                // 파워빌더 f_get_array(ls_rec, '|', la_data)
                String[] tokens = line.split("\\|", -1);
                if (tokens.length < 3) continue;

                String infoType = tokens[0].trim();
                String shrnIscd = (tokens.length > 1) ? tokens[1].trim() : "";
                String stndIscd = (tokens.length > 2) ? tokens[2].trim() : "";
                String korName = (tokens.length > 3) ? tokens[3].trim() : "";
                String atmClsCode = (tokens.length > 4) ? tokens[4].trim() : "";
                String acprStr = (tokens.length > 5) ? tokens[5].trim() : "";
                String mmscClsCode = (tokens.length > 6) ? tokens[6].trim() : "";
                String unasShrnIscd = (tokens.length > 7) ? tokens[7].trim() : "";
                String unasKorName = (tokens.length > 8) ? tokens[8].trim() : "";

                BigDecimal acpr = null;
                if (!acprStr.isEmpty()) {
                    try {
                        acpr = new BigDecimal(acprStr.replaceAll(",", ""));
                    } catch (Exception ignored) {
                    }
                }

                // 파워빌더 원본: IF SQLCA.sqlcode() <> 0 (미존재 시) INSERT
                if (ja033bMapper.existsFoIdxCode(infoType, stndIscd) == 0) {
                    Ja033bDto dto = Ja033bDto.builder()
                            .infoType(infoType)
                            .shrnIscd(shrnIscd)
                            .stndIscd(stndIscd)
                            .korName(korName)
                            .atmClsCode(atmClsCode)
                            .acpr(acpr)
                            .mmscClsCode(mmscClsCode)
                            .unasShrnIscd(unasShrnIscd)
                            .unasKorName(unasKorName)
                            .build();

                    ja033bMapper.insertFoIdxCode(dto);
                    insertCount++;
                }
            }
        }

        result.put("success", true);
        result.put("totalCount", totalCount);
        result.put("insertCount", insertCount);
        result.put("message", String.format("총 %d건 중 %d건의 지수 선물/옵션 종목이 신규 등록되었습니다.", totalCount, insertCount));
        return result;
    }
}
