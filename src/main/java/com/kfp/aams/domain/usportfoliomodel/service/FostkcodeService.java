package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.FostkcodeDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.FostkcodeMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;

/**
 * 해외파생 종목코드 서비스 (W_FOSTKCODE)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class FostkcodeService {

    private final FostkcodeMapper fostkcodeMapper;

    /**
     * 해외파생 종목코드 목록 조회
     */
    @Transactional(readOnly = true)
    public List<FostkcodeDto> getFostkcodeList(String corpGr, String ym, String symbol) {
        if (corpGr == null || corpGr.isBlank() || ym == null || ym.isBlank()) {
            return Collections.emptyList();
        }

        // ym 정규화 (YYYYMM 또는 YYYY-MM -> YYYYMM)
        String cleanYm = ym.trim().replace("-", "");
        String cleanSymbol = (symbol != null && !symbol.isBlank()) ? symbol.trim() : null;

        return fostkcodeMapper.selectFostkcodeList(corpGr.trim(), cleanYm, cleanSymbol);
    }

    /**
     * 종목코드 데이터 일괄 저장 (CUD)
     */
    @Transactional
    public void saveFostkcodeList(String corpGr, List<FostkcodeDto> list) {
        if (corpGr == null || corpGr.isBlank() || list == null || list.isEmpty()) {
            return;
        }

        for (FostkcodeDto dto : list) {
            if (dto.getSrscd() == null || dto.getSrscd().isBlank()) {
                continue;
            }
            if (Boolean.TRUE.equals(dto.getIsNew()) || Boolean.TRUE.equals(dto.getIsUpdated())
                    || "C".equalsIgnoreCase(dto.getRowStatus()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                fostkcodeMapper.mergeFostkcode(dto);
            }
        }
    }

    /**
     * 종목LOAD (.mst 파생종목파일 업로드 파싱 및 DB 적재)
     * 파워빌더 w_fostkcode.srw::cb_load 로직 100% 반영
     */
    @Transactional
    public int loadMstFile(MultipartFile file) throws Exception {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("업로드할 파일이 비어 있습니다.");
        }

        int insertCount = 0;
        // 한글 윈도우 파일(EUC-KR/MS949) 또는 UTF-8 호환 처리
        Charset charset = Charset.forName("EUC-KR");

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), charset))) {
            String line;
            int lineCount = 0;

            while ((line = reader.readLine()) != null) {
                lineCount++;
                if (line.trim().isEmpty()) {
                    continue;
                }

                String srscd = safeSubstring(line, 1, 32);
                if (srscd.isEmpty()) {
                    continue;
                }

                // 중복 체크 및 신규 적재
                if (fostkcodeMapper.existsBySrscd(srscd) == 0) {
                    FostkcodeDto dto = FostkcodeDto.builder()
                            .srscd(srscd)
                            .autoordgnrlyn(safeSubstring(line, 33, 1))
                            .autoordtwapyn(safeSubstring(line, 34, 1))
                            .autoordecnmyn(safeSubstring(line, 35, 1))
                            .exchsubcd(safeSubstring(line, 36, 2))
                            .serieskrnm(safeSubstring(line, 38, 45))
                            .exchcd(safeSubstring(line, 133, 10))
                            .mrktcd(safeSubstring(line, 143, 10))
                            .clascd(safeSubstring(line, 153, 3))
                            .dispdesz(parseInteger(safeSubstring(line, 156, 5)))
                            .calcdesz(parseInteger(safeSubstring(line, 161, 5)))
                            .ticksz(parseBigDecimal(safeSubstring(line, 166, 14)))
                            .tickval(parseBigDecimal(safeSubstring(line, 180, 14)))
                            .ctrtsz(parseBigDecimal(safeSubstring(line, 194, 10)))
                            .dispdigit(parseInteger(safeSubstring(line, 204, 4)))
                            .multiplier(parseBigDecimal(safeSubstring(line, 208, 10)))
                            .symbol(safeSubstring(line, 218, 1))
                            .stkprc(parseBigDecimal(safeSubstring(line, 219, 20)))
                            .undrinstr(safeSubstring(line, 239, 10))
                            .undrasset(safeSubstring(line, 249, 32))
                            .refrasset(safeSubstring(line, 281, 32))
                            .inctickprc(parseBigDecimal(safeSubstring(line, 313, 19)))
                            .incticksz(parseBigDecimal(safeSubstring(line, 332, 5)))
                            .mangi(safeSubstring(line, 337, 6))
                            .atmflg(safeSubstring(line, 343, 1))
                            .nearflg(safeSubstring(line, 344, 1))
                            .yearmon(safeSubstring(line, 337, 6))
                            .build();

                    fostkcodeMapper.mergeFostkcode(dto);
                    insertCount++;
                }
            }
        }

        log.info("해외파생 종목파일 LOAD 완료: 총 {}건 신규 등록", insertCount);
        return insertCount;
    }

    /**
     * 1-based 시작 위치 및 길이에 따른 안전한 Substring 헬퍼 (PowerBuilder MID 호환)
     */
    private String safeSubstring(String text, int startPos, int length) {
        if (text == null) return "";
        int start = startPos - 1;
        if (start >= text.length()) return "";
        int end = Math.min(start + length, text.length());
        return text.substring(start, end).trim();
    }

    private Integer parseInteger(String str) {
        if (str == null || str.isBlank()) return null;
        try {
            return Integer.parseInt(str.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal parseBigDecimal(String str) {
        if (str == null || str.isBlank()) return null;
        try {
            return new BigDecimal(str.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
