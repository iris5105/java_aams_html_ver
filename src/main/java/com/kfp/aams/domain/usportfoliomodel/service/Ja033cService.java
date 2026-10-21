package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja033cDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja033cMapper;
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
 * KRX 통화/금리/상품 선물/옵션 종목 서비스 (W_JA033C)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja033cService {

    private final Ja033cMapper ja033cMapper;

    /**
     * 통화/금리/상품 선물/옵션 종목 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja033cDto> getFoComCodeList(String comType, String infoType) {
        String cleanComType = null;
        if (comType != null && !comType.isBlank() && !"%".equals(comType.trim()) && !"ALL".equalsIgnoreCase(comType.trim())) {
            cleanComType = comType.trim();
        }

        String cleanInfoType = null;
        if (infoType != null && !infoType.isBlank() && !"%".equals(infoType.trim()) && !"ALL".equalsIgnoreCase(infoType.trim())) {
            cleanInfoType = infoType.trim();
        }

        return ja033cMapper.selectFoComCodeList(cleanComType, cleanInfoType);
    }

    /**
     * 통화/금리/상품 선물/옵션 종목 그리드 일괄 저장 (CUD)
     */
    @Transactional
    public void saveFoComCodeList(List<Ja033cDto> list) {
        if (list == null || list.isEmpty()) {
            return;
        }

        for (Ja033cDto dto : list) {
            if (dto.getComType() == null || dto.getComType().isBlank()
                    || dto.getInfoType() == null || dto.getInfoType().isBlank()
                    || dto.getStndIscd() == null || dto.getStndIscd().isBlank()) {
                continue;
            }

            dto.setComType(dto.getComType().trim());
            dto.setInfoType(dto.getInfoType().trim());
            dto.setStndIscd(dto.getStndIscd().trim());
            if (dto.getShrnIscd() != null) dto.setShrnIscd(dto.getShrnIscd().trim());

            log.info("Processing FO_COM_CODE item: comType={}, infoType={}, stndIscd={}, status={}, isNew={}",
                    dto.getComType(), dto.getInfoType(), dto.getStndIscd(), dto.getRowStatus(), dto.getIsNew());

            // 1) 삭제 처리
            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                int cnt = ja033cMapper.deleteFoComCode(dto.getComType(), dto.getInfoType(), dto.getStndIscd());
                log.info("deleteFoComCode result: {}", cnt);
            }
            // 2) 신규 등록
            else if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                int cnt = ja033cMapper.mergeFoComCode(dto);
                log.info("mergeFoComCode result: {}", cnt);
            }
            // 3) 수정
            else if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                int cnt = ja033cMapper.updateFoComCode(dto);
                log.info("updateFoComCode result: {}", cnt);
            }
        }
    }

    /**
     * 파워빌더 w_ja033c.srw::cb_load 로직 100% 반영:
     * 마스터 파일(fo_com*.mst) 파싱 후 FO_COM_CODE 등록
     * (고정 자릿수 MidA 및 구분자(|) 파싱 지원)
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

        Charset charset = Charset.forName("EUC-KR");
        try (BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream(), charset))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                totalCount++;

                String comType = "";
                String infoType = "";
                String shrnIscd = "";
                String stndIscd = "";
                String korName = "";
                String atmClsCode = "";
                String acprStr = "";
                String mmscClsCode = "";
                String prodNo = "";
                String prodName = "";

                // 1) 구분자 '|' 포함 시
                if (line.contains("|")) {
                    String[] tokens = line.split("\\|", -1);
                    if (tokens.length >= 4) {
                        comType = tokens[0].trim();
                        infoType = (tokens.length > 1) ? tokens[1].trim() : "";
                        shrnIscd = (tokens.length > 2) ? tokens[2].trim() : "";
                        stndIscd = (tokens.length > 3) ? tokens[3].trim() : "";
                        korName = (tokens.length > 4) ? tokens[4].trim() : "";
                        atmClsCode = (tokens.length > 5) ? tokens[5].trim() : "";
                        acprStr = (tokens.length > 6) ? tokens[6].trim() : "";
                        mmscClsCode = (tokens.length > 7) ? tokens[7].trim() : "";
                        prodNo = (tokens.length > 8) ? tokens[8].trim() : "";
                        prodName = (tokens.length > 9) ? tokens[9].trim() : "";
                    }
                }
                // 2) 고정 자릿수 (파워빌더 w_ja033c.srw 원본 MidA 로직)
                else {
                    byte[] bytes = line.getBytes("EUC-KR");
                    if (bytes.length >= 23) { // 최소 stndIscd까지 존재
                        comType = subStringBytes(bytes, 0, 1).trim();
                        infoType = subStringBytes(bytes, 1, 1).trim();
                        shrnIscd = subStringBytes(bytes, 2, 9).trim();
                        stndIscd = subStringBytes(bytes, 11, 12).trim();
                        korName = (bytes.length >= 63) ? subStringBytes(bytes, 23, 40).trim() : "";
                        atmClsCode = (bytes.length >= 64) ? subStringBytes(bytes, 63, 1).trim() : "";
                        acprStr = (bytes.length >= 72) ? subStringBytes(bytes, 64, 8).trim() : "";
                        mmscClsCode = (bytes.length >= 73) ? subStringBytes(bytes, 72, 1).trim() : "";
                        prodNo = (bytes.length >= 76) ? subStringBytes(bytes, 73, 3).trim() : "";
                        prodName = (bytes.length > 76) ? subStringBytes(bytes, 76, Math.min(40, bytes.length - 76)).trim() : "";
                    }
                }

                if (comType.isEmpty() || infoType.isEmpty() || stndIscd.isEmpty()) {
                    continue;
                }

                BigDecimal acpr = null;
                if (!acprStr.isEmpty()) {
                    try {
                        acpr = new BigDecimal(acprStr.replaceAll(",", ""));
                    } catch (Exception ignored) {
                    }
                }

                // 파워빌더 원본: IF SQLCA.sqlcode() <> 0 (미존재 시) INSERT
                if (ja033cMapper.existsFoComCode(comType, infoType, stndIscd) == 0) {
                    Ja033cDto dto = Ja033cDto.builder()
                            .comType(comType)
                            .infoType(infoType)
                            .shrnIscd(shrnIscd)
                            .stndIscd(stndIscd)
                            .korName(korName)
                            .atmClsCode(atmClsCode)
                            .acpr(acpr)
                            .mmscClsCode(mmscClsCode)
                            .prodNo(prodNo)
                            .prodName(prodName)
                            .build();

                    ja033cMapper.insertFoComCode(dto);
                    insertCount++;
                }
            }
        }

        result.put("success", true);
        result.put("totalCount", totalCount);
        result.put("insertCount", insertCount);
        result.put("message", String.format("총 %d건 중 %d건의 통화/금리/상품 종목이 신규 등록되었습니다.", totalCount, insertCount));
        return result;
    }

    private String subStringBytes(byte[] bytes, int offset, int length) {
        if (offset >= bytes.length) return "";
        int actualLen = Math.min(length, bytes.length - offset);
        try {
            return new String(bytes, offset, actualLen, "EUC-KR");
        } catch (Exception e) {
            return "";
        }
    }
}
