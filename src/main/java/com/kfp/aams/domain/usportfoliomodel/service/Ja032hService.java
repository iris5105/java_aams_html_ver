package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032hDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032hMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 해외 업종/지수/환율 코드 관리 서비스 (W_JA032H)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032hService {

    private final Ja032hMapper mapper;

    /**
     * 해외 코드 목록 조회
     */
    @Transactional(readOnly = true)
    public List<Ja032hDto> searchList(String frid, String keyword) {
        return mapper.selectList(frid, keyword);
    }

    /**
     * 해외 코드 CUD 일괄 저장
     */
    @Transactional
    public Map<String, Object> save(List<Ja032hDto> list) {
        Map<String, Object> result = new HashMap<>();
        int insertCount = 0;
        int updateCount = 0;
        int deleteCount = 0;

        if (list == null || list.isEmpty()) {
            result.put("success", true);
            result.put("message", "저장할 데이터가 없습니다.");
            return result;
        }

        for (Ja032hDto dto : list) {
            if (dto.getFrid() == null || dto.getFrid().trim().isEmpty() ||
                dto.getFrgn() == null || dto.getFrgn().trim().isEmpty()) {
                continue;
            }

            String frid = dto.getFrid().trim();
            String frgn = dto.getFrgn().trim();
            dto.setFrid(frid);
            dto.setFrgn(frgn);

            // 삭제 처리
            if (Boolean.TRUE.equals(dto.getIsDeleted()) || "D".equalsIgnoreCase(dto.getRowStatus())) {
                mapper.delete(frid, frgn);
                deleteCount++;
            }
            // 신규 등록 처리
            else if (Boolean.TRUE.equals(dto.getIsNew()) || "C".equalsIgnoreCase(dto.getRowStatus())) {
                int count = mapper.selectCountById(frid, frgn);
                if (count > 0) {
                    mapper.update(dto);
                    updateCount++;
                } else {
                    mapper.insert(dto);
                    insertCount++;
                }
            }
            // 수정 처리
            else if (Boolean.TRUE.equals(dto.getIsUpdated()) || "U".equalsIgnoreCase(dto.getRowStatus())) {
                mapper.update(dto);
                updateCount++;
            }
        }

        result.put("success", true);
        result.put("message", String.format("정상적으로 처리되었습니다. (등록: %d건, 수정: %d건, 삭제: %d건)", insertCount, updateCount, deleteCount));
        result.put("insertCount", insertCount);
        result.put("updateCount", updateCount);
        result.put("deleteCount", deleteCount);
        return result;
    }

    /**
     * 해외 업종/지수/환율 MST 파일 업로드 및 일괄 등록 (파워빌더 cb_load 로직 완전 이식)
     */
    @Transactional
    public Map<String, Object> loadMstFile(MultipartFile file) {
        Map<String, Object> result = new HashMap<>();
        if (file == null || file.isEmpty()) {
            result.put("success", false);
            result.put("message", "업로드할 파일이 없습니다.");
            return result;
        }

        int totalCount = 0;
        int insertCount = 0;
        int skipCount = 0;

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), Charset.forName("EUC-KR")))) {
            String line;
            while ((line = reader.readLine()) != null) {
                totalCount++;
                byte[] bytes = line.getBytes("EUC-KR");
                if (bytes.length < 2) {
                    continue;
                }

                String frid = getSubStringByBytes(bytes, 0, 1).trim();
                if ("H".equalsIgnoreCase(frid)) {
                    // 헤더 라인 스킵
                    continue;
                }

                String frgn = getSubStringByBytes(bytes, 1, 10).trim();
                if (frgn.isEmpty()) {
                    continue;
                }

                // 기등록 여부 확인
                int count = mapper.selectCountById(frid, frgn);
                if (count > 0) {
                    skipCount++;
                    continue;
                }

                String enam = getSubStringByBytes(bytes, 11, 39).trim();
                String knam = getSubStringByBytes(bytes, 50, 40).trim();
                String symb = getSubStringByBytes(bytes, 90, 4).trim();
                String exid = getSubStringByBytes(bytes, 94, 3).trim();
                String mkcd = getSubStringByBytes(bytes, 97, 4).trim();
                String mkid = getSubStringByBytes(bytes, 101, 3).trim();

                Ja032hDto dto = Ja032hDto.builder()
                        .frid(frid)
                        .frgn(frgn)
                        .enam(enam)
                        .knam(knam)
                        .symb(symb)
                        .exid(exid)
                        .mkcd(mkcd)
                        .mkid(mkid)
                        .build();

                mapper.insert(dto);
                insertCount++;
            }

            result.put("success", true);
            result.put("message", String.format("해외업종정보 LOAD를 완료했습니다. (전체: %d건, 신규등록: %d건, 기존존재: %d건)", totalCount, insertCount, skipCount));
            result.put("totalCount", totalCount);
            result.put("insertCount", insertCount);
            result.put("skipCount", skipCount);

        } catch (Exception e) {
            log.error("MST 파일 처리 실패", e);
            result.put("success", false);
            result.put("message", "파일 처리 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }

    private String getSubStringByBytes(byte[] bytes, int startIndex, int length) {
        if (startIndex >= bytes.length) return "";
        int actualLen = Math.min(length, bytes.length - startIndex);
        return new String(bytes, startIndex, actualLen, Charset.forName("EUC-KR"));
    }
}
