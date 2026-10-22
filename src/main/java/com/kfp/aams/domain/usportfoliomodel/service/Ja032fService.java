package com.kfp.aams.domain.usportfoliomodel.service;

import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.Ja032fMasterDto;
import com.kfp.aams.domain.usportfoliomodel.mapper.Ja032fMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class Ja032fService {

    private final Ja032fMapper ja032fMapper;

    /**
     * 해외주식 마스터 및 USPM 등록 종목 목록 조회 (d_ja032f1)
     */
    @Transactional(readOnly = true)
    public List<Ja032fMasterDto> getMasterList(String corpGr) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        return ja032fMapper.selectMasterList(corpGr);
    }

    /**
     * 종목 일별 시세 내역 조회 (d_ja032f2)
     */
    @Transactional(readOnly = true)
    public List<Ja032fDetailDto> getDetailList(String corpGr, String ymd, String jmCd) {
        if (corpGr == null || corpGr.isBlank() || jmCd == null || jmCd.isBlank()) {
            return Collections.emptyList();
        }
        return ja032fMapper.selectDetailList(corpGr, ymd, jmCd);
    }

    /**
     * 해외주식 등록/수정 일괄 저장 (파워빌더 w_ja032f.srw dw_list::itemchanged 'used' & 'opt_1unit' 반영)
     */
    @Transactional
    public Map<String, Object> saveMasterList(List<Ja032fMasterDto> list, String corpGr, String workDate) {
        Map<String, Object> result = new HashMap<>();
        if (list == null || list.isEmpty()) {
            result.put("success", true);
            result.put("message", "저장할 데이터가 없습니다.");
            return result;
        }

        int registeredCount = 0;
        int updatedCount = 0;
        String todayYmd = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));

        for (Ja032fMasterDto dto : list) {
            dto.setCorpGr(corpGr);

            // 1. 미등록(1) -> 등록(2)으로 신규 등록 처리
            if (Integer.valueOf(2).equals(dto.getUsed()) && (dto.getJmCd() == null || dto.getJmCd().isBlank() || Boolean.TRUE.equals(dto.getIsNew()))) {
                String symb = (dto.getSymb() != null) ? dto.getSymb().trim() : "";
                String excd = (dto.getExcd() != null) ? dto.getExcd().trim() : "";
                String stockGb = "AMS".equalsIgnoreCase(excd) ? "ARCX" : ("X" + excd);
                String jmCd = stockGb + ":" + symb;

                dto.setJmCd(jmCd);
                dto.setJmNm(dto.getEnam());
                dto.setSrsCd(symb);
                dto.setJasanGb("1");
                dto.setSeqNo(1);
                dto.setBalhNation(dto.getNcod());
                dto.setBlbgTckr(symb);
                dto.setBlbgTckrText(symb + " " + (dto.getNcod() != null ? dto.getNcod() : ""));
                dto.setStockGb(stockGb);
                dto.setSym0yaExcd(excd);

                if (dto.getOpt1unit() != null) {
                    dto.setOpt2unit(dto.getOpt1unit());
                    dto.setOpt4unit(dto.getOpt1unit());
                    dto.setOpt5unit(dto.getOpt1unit());
                }

                int existCount = ja032fMapper.countSym0ya(corpGr, jmCd, "1");
                if (existCount > 0) {
                    ja032fMapper.updateSym0ya(dto);
                } else {
                    ja032fMapper.insertSym0ya(dto);
                }

                // API_Q 3종 호출 (@prdt '512', '513', '529')
                try {
                    ja032fMapper.insertApiQ(corpGr, symb, jmCd, "512");
                    ja032fMapper.insertApiQ(corpGr, symb, jmCd, "513");
                    ja032fMapper.insertApiQ(corpGr, symb, jmCd, "529");
                } catch (Exception e) {
                    log.warn("API_Q 등록 중 예외 (무시 후 계속): {}", e.getMessage());
                }

                // USPM_DD 등록
                try {
                    String targetYmd = (workDate != null && !workDate.isBlank()) ? workDate : todayYmd;
                    ja032fMapper.insertUspmDd(corpGr, targetYmd, jmCd);
                } catch (Exception e) {
                    log.warn("USPM_DD 등록 중 예외 (무시 후 계속): {}", e.getMessage());
                }

                // SP API_13_02_200 호출
                try {
                    Map<String, Object> spParams = new HashMap<>();
                    spParams.put("corpGr", corpGr);
                    spParams.put("ymd", todayYmd);
                    spParams.put("ref", "ref");
                    ja032fMapper.callApi1302200(spParams);
                } catch (Exception e) {
                    log.warn("API_13_02_200 호출 중 예외: {}", e.getMessage());
                }

                registeredCount++;
            }
            // 2. 기존 등록된 건의 수정 처리 (optUnit, opt1unit 등)
            else if (Boolean.TRUE.equals(dto.getIsUpdated())) {
                if (dto.getOpt1unit() != null) {
                    dto.setOpt2unit(dto.getOpt1unit());
                    dto.setOpt4unit(dto.getOpt1unit());
                    dto.setOpt5unit(dto.getOpt1unit());
                }
                ja032fMapper.updateSym0ya(dto);
                updatedCount++;
            }
        }

        result.put("success", true);
        result.put("message", String.format("정상적으로 저장되었습니다. (신규등록: %d건, 수정: %d건)", registeredCount, updatedCount));
        return result;
    }

    /**
     * 해외종목 파일(*.cod) 업로드 LOAD 처리 (파워빌더 w_ja032f.srw cb_load::clicked 100% 반영)
     */
    @Transactional
    public Map<String, Object> loadCodFile(MultipartFile file) {
        Map<String, Object> result = new HashMap<>();
        if (file == null || file.isEmpty()) {
            result.put("success", false);
            result.put("message", "업로드할 파일이 비어 있습니다.");
            return result;
        }

        int totalRead = 0;
        int insertedCount = 0;

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), Charset.forName("EUC-KR")))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                totalRead++;
                String[] tokens = line.split("\t", -1);
                if (tokens.length < 6) continue;

                String rsym = tokens[5].trim();
                if (rsym.isEmpty()) continue;

                // 이미 등록된 rsym 인지 검사
                int exist = ja032fMapper.selectGlobalMastcodeCount(rsym);
                if (exist == 0) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("ncod", tokens.length > 0 ? tokens[0].trim() : "");
                    row.put("exid", tokens.length > 1 ? tokens[1].trim() : "");
                    row.put("excd", tokens.length > 2 ? tokens[2].trim() : "");
                    row.put("exnm", tokens.length > 3 ? tokens[3].trim() : "");
                    row.put("symb", tokens.length > 4 ? tokens[4].trim() : "");
                    row.put("rsym", rsym);
                    row.put("knam", tokens.length > 6 ? tokens[6].trim() : "");
                    row.put("enam", tokens.length > 7 ? tokens[7].trim() : "");
                    row.put("stis", tokens.length > 8 ? tokens[8].trim() : "");
                    row.put("curr", tokens.length > 9 ? tokens[9].trim() : "");
                    row.put("zdiv", tokens.length > 10 ? tokens[10].trim() : "");
                    row.put("ztyp", tokens.length > 11 ? tokens[11].trim() : "");

                    BigDecimal base = BigDecimal.ZERO;
                    if (tokens.length > 12 && !tokens[12].trim().isEmpty()) {
                        try {
                            base = new BigDecimal(tokens[12].trim().replaceAll(",", ""));
                        } catch (Exception ignored) {}
                    }
                    row.put("base", base);

                    row.put("bnit", tokens.length > 13 ? tokens[13].trim() : "");
                    row.put("anit", tokens.length > 14 ? tokens[14].trim() : "");

                    String mstm = tokens.length > 15 ? tokens[15].trim() : "";
                    if (!mstm.isEmpty()) {
                        mstm = ("0" + mstm);
                        if (mstm.length() > 4) mstm = mstm.substring(mstm.length() - 4);
                    }
                    row.put("mstm", mstm);

                    row.put("metm", tokens.length > 16 ? tokens[16].trim() : "");
                    row.put("isdr", tokens.length > 17 ? tokens[17].trim() : "");
                    row.put("drcd", tokens.length > 18 ? tokens[18].trim() : "");
                    row.put("icod", tokens.length > 19 ? tokens[19].trim() : "");

                    Integer sjong = 0;
                    if (tokens.length > 20 && !tokens[20].trim().isEmpty()) {
                        try {
                            sjong = Integer.parseInt(tokens[20].trim());
                        } catch (Exception ignored) {}
                    }
                    row.put("sjong", sjong);

                    row.put("ttyp", tokens.length > 21 ? tokens[21].trim() : "");

                    String etyp = tokens.length > 22 ? tokens[22].trim() : "";
                    if (!etyp.isEmpty()) {
                        etyp = ("000" + etyp);
                        if (etyp.length() > 3) etyp = etyp.substring(etyp.length() - 3);
                    }
                    row.put("etyp", etyp);

                    row.put("ttypSb", tokens.length > 23 ? tokens[23].trim() : "");

                    ja032fMapper.insertGlobalMastcode(row);
                    insertedCount++;
                }
            }

            result.put("success", true);
            result.put("message", String.format("해외 종목정보 LOAD를 완료했습니다. (전체 읽기: %d건, 신규 등록: %d건)", totalRead, insertedCount));
        } catch (Exception e) {
            log.error("해외 종목 파일 LOAD 오류: ", e);
            result.put("success", false);
            result.put("message", "파일 읽기 중 오류 발생: " + e.getMessage());
        }

        return result;
    }
}
