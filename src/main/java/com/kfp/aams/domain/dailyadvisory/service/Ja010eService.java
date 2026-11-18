package com.kfp.aams.domain.dailyadvisory.service;

import com.kfp.aams.domain.dailyadvisory.dto.Ja010eDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010eImportFundDto;
import com.kfp.aams.domain.dailyadvisory.dto.Ja010eImportSecurityDto;
import com.kfp.aams.domain.dailyadvisory.mapper.Ja010eMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Collections;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Service for w_ja010e (주식체결LOAD(입고))
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class Ja010eService {

    private final Ja010eMapper ja010eMapper;
    private final com.kfp.aams.domain.dailyadvisory.mapper.querydsl.Ja010eQueryDslRepository ja010eQueryDslRepository;

    /**
     * Retrieve Stock Trading Load List (d_ja010e1.srd)
     */
    public List<Ja010eDto> getList(String corpGr, java.time.LocalDate trYmd, String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null) {
            return Collections.emptyList();
        }
        String coCd = (trCoCd != null && !trCoCd.isBlank() && !"%".equals(trCoCd.trim())) ? trCoCd.trim() : null;
        return ja010eMapper.selectJa010eList(corpGr.trim(), trYmd, coCd);
    }

    /**
     * Retrieve Available Dates for Calendar Highlighting (w_ja010e.srw / dw_c::ue_getdate / SJT1JG)
     */
    public List<String> getDates(String corpGr, String trCoCd) {
        if (corpGr == null || corpGr.isBlank()) {
            return Collections.emptyList();
        }
        String coCd = (trCoCd != null && !trCoCd.isBlank() && !"%".equals(trCoCd.trim())) ? trCoCd.trim() : null;
        return ja010eMapper.selectJa010eDates(corpGr.trim(), coCd);
    }

    @Transactional
    public void saveJa010e(com.kfp.aams.domain.dailyadvisory.dto.Ja010eSaveRequestDto req) {
        if (req == null || req.getCorpGr() == null || req.getCorpGr().isBlank()) {
            throw new IllegalArgumentException("회사그룹 정보가 누락되었습니다.");
        }
        String corpGr = req.getCorpGr().trim();
        java.time.LocalDate ymd = req.getYmd();

        // 1. 삭제 대기열(deletedList) 선행 삭제
        if (req.getDeletedList() != null) {
            for (Ja010eDto del : req.getDeletedList()) {
                if (del.getCorpGr() == null || del.getCorpGr().isBlank()) {
                    del.setCorpGr(corpGr);
                }
                if (del.getTrYmd() == null) {
                    del.setTrYmd(ymd);
                }
                ja010eQueryDslRepository.deleteSjt1jg(del);
            }
        }

        // 2. 추가 및 수정 항목 반영
        if (req.getItemList() != null) {
            for (Ja010eDto dto : req.getItemList()) {
                dto.setCorpGr(corpGr);
                if (dto.getTrYmd() == null) {
                    dto.setTrYmd(ymd);
                }
                if (dto.isNew()) {
                    if (dto.getOfferNo() == null || dto.getOfferNo() == 0L) {
                        Long nextNo = ja010eQueryDslRepository.getNextOfferNo(corpGr, dto.getTrYmd());
                        dto.setOfferNo(nextNo);
                    }
                    ja010eQueryDslRepository.insertSjt1jg(dto);
                } else if (dto.isUpdated()) {
                    ja010eQueryDslRepository.updateSjt1jg(dto);
                }
            }
        }
    }

    /** PowerBuilder w_ja010e::cb_del clicked. */
    @Transactional
    public int deleteLoadedRows(String corpGr, java.time.LocalDate trYmd, String trCoCd) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trCoCd == null || trCoCd.isBlank()) {
            throw new IllegalArgumentException("회사그룹, 매매일자 및 매매증권사를 확인해주세요.");
        }
        return ja010eQueryDslRepository.deleteLoadedSjt1jg(corpGr.trim(), trYmd, trCoCd.trim());
    }

    /**
     * Web equivalent of w_import_sjt1jg::btn_load.
     * The response-window step only normalizes and validates rows. Persistence
     * remains in {@link #commitBrokerTrades(String, LocalDate, String, List)},
     * matching the parent w_ja010e::wf_load close-return lifecycle.
     */
    public Map<String, Object> previewBrokerTrades(String corpGr, LocalDate trYmd, String trCoCd,
                                                    List<MultipartFile> files) throws Exception {
        validateImportRequest(corpGr, trYmd, trCoCd, files);

        String normalizedCorpGr = corpGr.trim();
        String normalizedTrCoCd = trCoCd.trim();
        List<String> errors = new ArrayList<>();
        List<Ja010eDto> itemList = new ArrayList<>();
        int sourceCount = 0;

        for (MultipartFile file : files) {
            if (file == null || file.isEmpty()) {
                continue;
            }
            List<List<String>> rows = readRows(file);
            for (RawTrade rawTrade : parseBrokerRows(normalizedCorpGr, normalizedTrCoCd, file.getOriginalFilename(), rows)) {
                sourceCount++;
                String normalizedAccount = normalizeAccount(rawTrade.acctNo());
                Ja010eImportFundDto fund = "2203".equals(normalizedCorpGr) && "00002".equals(normalizedTrCoCd)
                        ? ja010eMapper.selectImportFundByAccountSuffix(normalizedCorpGr, normalizedAccount)
                        : ja010eMapper.selectActiveImportFund(normalizedCorpGr, normalizedTrCoCd, normalizedAccount);
                if (fund == null) {
                    errors.add(errorMessage(file, rawTrade.rowNumber(), "활성 계좌를 찾을 수 없습니다", rawTrade.acctNo()));
                    continue;
                }

                Ja010eImportSecurityDto security = rawTrade.jjNm() != null && !rawTrade.jjNm().isBlank()
                        ? ja010eMapper.selectImportSecurityByName(rawTrade.jjNm().trim())
                        : ja010eMapper.selectImportSecurityByKoscomCd(normalizeKoscomCode(rawTrade.koscomCd()));
                if (security == null) {
                    String reference = rawTrade.jjNm() != null && !rawTrade.jjNm().isBlank()
                            ? rawTrade.jjNm() : rawTrade.koscomCd();
                    errors.add(errorMessage(file, rawTrade.rowNumber(), "등록 종목을 찾을 수 없습니다", reference));
                    continue;
                }

                Ja010eDto dto = Ja010eDto.builder()
                        .corpGr(normalizedCorpGr)
                        .trYmd(trYmd)
                        .trCd(rawTrade.trCd())
                        .trCoCd(normalizedTrCoCd)
                        .offerNo(rawTrade.offerNo())
                        .encAcctNo(fund.getEncAcctNo())
                        .acctNo(fund.getAcctNo() == null || fund.getAcctNo().isBlank()
                                ? rawTrade.acctNo() : fund.getAcctNo())
                        .fundCd(fund.getFundCd())
                        .fundNm(fund.getFundNm())
                        .jmCd(security.getJmCd())
                        .jjNm(security.getJjNm())
                        .koscomCd(security.getKoscomCd())
                        .dancGb(security.getDancGb())
                        .trJusu(rawTrade.quantity())
                        .trAek(rawTrade.amount())
                        .susu(rawTrade.fee())
                        .tax(rawTrade.tax())
                        .build();
                itemList.add(dto);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("sourceCount", sourceCount);
        result.put("previewCount", itemList.size());
        result.put("errorCount", errors.size());
        result.put("errors", errors);
        result.put("itemList", itemList);
        result.put("message", String.format("체결자료 %d건 중 %d건을 검증했습니다.", sourceCount, itemList.size()));
        return result;
    }

    /** Parent w_ja010e::wf_load: returned rows are de-duplicated and saved on close. */
    @Transactional
    public Map<String, Object> commitBrokerTrades(String corpGr, LocalDate trYmd, String trCoCd,
                                                   List<Ja010eDto> itemList) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trCoCd == null || trCoCd.isBlank()) {
            throw new IllegalArgumentException("회사그룹, 매매일자 및 매매증권사를 확인해 주세요.");
        }
        int savedCount = 0;
        int duplicateCount = 0;
        if (itemList != null) {
            for (Ja010eDto dto : itemList) {
                if (dto == null || dto.getTrCd() == null || dto.getFundCd() == null || dto.getJmCd() == null
                        || dto.getOfferNo() == null) {
                    continue;
                }
                dto.setCorpGr(corpGr.trim());
                dto.setTrYmd(trYmd);
                dto.setTrCoCd(trCoCd.trim());
                if (ja010eQueryDslRepository.existsImportedTrade(dto.getCorpGr(), dto.getTrYmd(), dto.getTrCd(),
                        dto.getFundCd(), dto.getJmCd(), dto.getTrCoCd(), dto.getOfferNo())) {
                    duplicateCount++;
                    continue;
                }
                ja010eQueryDslRepository.insertSjt1jg(dto);
                savedCount++;
            }
        }
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("savedCount", savedCount);
        result.put("duplicateCount", duplicateCount);
        result.put("message", String.format("체결자료 %d건을 등록했습니다.", savedCount));
        return result;
    }

    private void validateImportRequest(String corpGr, LocalDate trYmd, String trCoCd, List<MultipartFile> files) {
        if (corpGr == null || corpGr.isBlank() || trYmd == null || trCoCd == null || trCoCd.isBlank()
                || "%".equals(trCoCd.trim())) {
            throw new IllegalArgumentException("회사그룹, 매매일자 및 매매증권사를 선택해 주세요.");
        }
        if (files == null || files.stream().allMatch(file -> file == null || file.isEmpty())) {
            throw new IllegalArgumentException("등록할 체결 Excel 또는 CSV 파일을 선택해 주세요.");
        }
    }

    private List<RawTrade> parseBrokerRows(String corpGr, String trCoCd, String filename, List<List<String>> rows) {
        if ("2201".equals(corpGr) || "2202".equals(corpGr)) {
            return switch (trCoCd) {
                case "00010" -> parseNh(rows);
                case "00020" -> parseMirae(rows);
                case "00030" -> parseShinyoung(rows);
                case "00056" -> parseHana(rows);
                default -> throw new IllegalArgumentException("선택한 증권사는 체결등록 파일 형식이 등록되어 있지 않습니다: " + trCoCd);
            };
        }
        if ("2203".equals(corpGr)) {
            return parse2203Trade(trCoCd, filename, rows);
        }
        throw new IllegalArgumentException("회사그룹 " + corpGr + "의 체결등록 파일 형식이 등록되어 있지 않습니다.");
    }

    /** PB wf_load / 00010 (NH): two column layouts distinguished by row 2's quantity header. */
    private List<RawTrade> parseNh(List<List<String>> rows) {
        boolean firstLayout = "수량".equals(cell(rows, 1, 8).trim());
        List<RawTrade> result = new ArrayList<>();
        for (int row = 2; row < rows.size(); row++) {
            BigDecimal quantity = number(cell(rows, row, firstLayout ? 8 : 9));
            if (quantity.signum() == 0 || cell(rows, row, 4).isBlank()) continue;
            String account = firstLayout ? cell(rows, row, 12) : "AAAAAAAAAAA=";
            result.add(new RawTrade(row + 1, account, null, cell(rows, row, 4),
                    tradeCode(cell(rows, row, 2)), offerNo(cell(rows, row, 0), row), quantity,
                    quantity.multiply(number(cell(rows, row, firstLayout ? 9 : 10))), BigDecimal.ZERO, BigDecimal.ZERO));
        }
        return result;
    }

    /** PB wf_load / 00020 (Mirae): normal and 1619 discretionary layouts. */
    private List<RawTrade> parseMirae(List<List<String>> rows) {
        boolean discretionary = "종목코드".equals(cell(rows, 0, 0).trim());
        List<RawTrade> result = new ArrayList<>();
        for (int row = 1; row < rows.size(); row++) {
            if (discretionary) {
                BigDecimal quantity = number(cell(rows, row, 3));
                if (quantity.signum() == 0) continue;
                result.add(new RawTrade(row + 1, "AAAAAAAAAAA=", null, leftPadCode(cell(rows, row, 0)),
                        tradeCode(cell(rows, row, 2)), (long) row + 1, quantity, number(cell(rows, row, 6)),
                        number(cell(rows, row, 8)), number(cell(rows, row, 7))));
            } else {
                BigDecimal quantity = number(cell(rows, row, 11));
                if (quantity.signum() == 0) continue;
                result.add(new RawTrade(row + 1, cell(rows, row, 3), cell(rows, row, 5), null,
                        tradeCode(cell(rows, row, 6)), offerNo(cell(rows, row, 1), row), quantity,
                        quantity.multiply(number(cell(rows, row, 12))), BigDecimal.ZERO, BigDecimal.ZERO));
            }
        }
        return result;
    }

    private List<RawTrade> parseShinyoung(List<List<String>> rows) {
        List<RawTrade> result = new ArrayList<>();
        for (int row = 1; row < rows.size(); row++) {
            BigDecimal quantity = number(cell(rows, row, 8));
            String tradeText = cell(rows, row, 5);
            if (quantity.signum() == 0 || tradeText.contains("정정")) continue;
            result.add(new RawTrade(row + 1, cell(rows, row, 2), null, cell(rows, row, 0), tradeCode(tradeText),
                    offerNo(cell(rows, row, 4), row), quantity,
                    number(cell(rows, row, 10)).add(number(cell(rows, row, 11))).multiply(quantity), BigDecimal.ZERO, BigDecimal.ZERO));
        }
        return result;
    }

    private List<RawTrade> parseHana(List<List<String>> rows) {
        List<RawTrade> result = new ArrayList<>();
        for (int row = 1; row < rows.size(); row++) {
            BigDecimal quantity = number(cell(rows, row, 6));
            if (quantity.signum() == 0) continue;
            String sourceCode = cell(rows, row, 3).trim();
            String koscomCode = sourceCode.startsWith("J") ? sourceCode : trimLeadingCharacter(sourceCode);
            result.add(new RawTrade(row + 1, cell(rows, row, 0), null, koscomCode,
                    tradeCode(cell(rows, row, 5)), (long) row + 1, quantity, number(cell(rows, row, 8)),
                    number(cell(rows, row, 9)), number(cell(rows, row, 10))));
        }
        return result;
    }

    /** PB wf_2203_meme. The account source is the selected filename or the broker's fixed account. */
    private List<RawTrade> parse2203Trade(String trCoCd, String filename, List<List<String>> rows) {
        return switch (trCoCd) {
            case "00002" -> parse2203Shinhan(filename, rows);
            case "00010" -> parse2203Meritz(rows);
            case "00021" -> parse2203Hanwha(rows);
            case "00030" -> parse2203Samsung(rows);
            default -> throw new IllegalArgumentException("선택한 증권사의 2203 체결등록 파일 형식이 등록되어 있지 않습니다: " + trCoCd);
        };
    }

    private List<RawTrade> parse2203Shinhan(String filename, List<List<String>> rows) {
        String account = filename == null ? "" : filename.replaceFirst("(?i)\\.(xlsx|xls|csv)$", "");
        account = account.length() > 11 ? account.substring(account.length() - 11, account.length() - 5) : account;
        List<RawTrade> result = new ArrayList<>();
        for (int row = 1; row < rows.size(); row++) {
            BigDecimal quantity = number(cell(rows, row, 4));
            if (quantity.signum() == 0) continue;
            result.add(new RawTrade(row + 1, account, null, trimLeadingCharacter(cell(rows, row, 1)),
                    tradeCode(cell(rows, row, 3)), (long) row + 1, quantity, number(cell(rows, row, 6)),
                    number(cell(rows, row, 7)), number(cell(rows, row, 8))));
        }
        return result;
    }

    private List<RawTrade> parse2203Meritz(List<List<String>> rows) {
        return parse2203PairRows(rows, "3017-8738-01", 2, 2,
                1, 4, 2, 0, 5, 1, 6, 1);
    }

    private List<RawTrade> parse2203Hanwha(List<List<String>> rows) {
        return parse2203PairRows(rows, "500-662563-11", 3, 3,
                2, 3, 2, 1, 4, 1, 5, 2);
    }

    private List<RawTrade> parse2203Samsung(List<List<String>> rows) {
        List<RawTrade> result = new ArrayList<>();
        for (int row = 2; row + 1 < rows.size(); row += 2) {
            BigDecimal quantity = number(cell(rows, row, 3));
            if (quantity.signum() == 0) continue;
            result.add(new RawTrade(row + 1, "7132428916-01", null, trimLeadingCharacter(cell(rows, row + 1, 2)),
                    tradeCode(cell(rows, row, 1)), (long) row + 1, quantity, number(cell(rows, row, 7)),
                    number(cell(rows, row + 1, 4)), number(cell(rows, row, 5)).add(number(cell(rows, row + 1, 5)))));
        }
        return result;
    }

    private List<RawTrade> parse2203PairRows(List<List<String>> rows, String account, int startRow, int step,
                                               int codeColumn, int quantityColumn, int tradeColumn,
                                               int tradeRowOffset, int amountColumn, int feeRowOffset,
                                               int taxColumn, int taxRowOffset) {
        List<RawTrade> result = new ArrayList<>();
        for (int row = startRow; row < rows.size(); row += step) {
            BigDecimal quantity = number(cell(rows, row, quantityColumn));
            if (quantity.signum() == 0) continue;
            result.add(new RawTrade(row + 1, account, null, trimLeadingCharacter(cell(rows, row, codeColumn)),
                    tradeCode(cell(rows, row + tradeRowOffset, tradeColumn)), (long) row + 1, quantity,
                    number(cell(rows, row, amountColumn)),
                    number(cell(rows, row + feeRowOffset, amountColumn)), number(cell(rows, row, taxColumn)).add(number(cell(rows, row + taxRowOffset, taxColumn)))));
        }
        return result;
    }

    private List<List<String>> readRows(MultipartFile file) throws Exception {
        String filename = file.getOriginalFilename() == null ? "" : file.getOriginalFilename().toLowerCase(Locale.ROOT);
        if (filename.endsWith(".csv")) {
            return readCsvRows(file);
        }
        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0); // PB imports the first worksheet only.
            DataFormatter formatter = new DataFormatter(Locale.KOREA);
            List<List<String>> rows = new ArrayList<>();
            for (Row row : sheet) {
                List<String> values = new ArrayList<>();
                int lastCell = Math.max(row.getLastCellNum(), 0);
                for (int column = 0; column < lastCell; column++) {
                    values.add(formatter.formatCellValue(row.getCell(column)).trim());
                }
                rows.add(values);
            }
            return rows;
        }
    }

    private List<List<String>> readCsvRows(MultipartFile file) throws Exception {
        List<List<String>> rows = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                rows.add(parseCsvLine(line));
            }
        }
        return rows;
    }

    private List<String> parseCsvLine(String line) {
        List<String> values = new ArrayList<>();
        StringBuilder value = new StringBuilder();
        boolean quoted = false;
        for (int index = 0; index < line.length(); index++) {
            char character = line.charAt(index);
            if (character == '"') {
                if (quoted && index + 1 < line.length() && line.charAt(index + 1) == '"') {
                    value.append(character);
                    index++;
                } else {
                    quoted = !quoted;
                }
            } else if (character == ',' && !quoted) {
                values.add(value.toString().trim());
                value.setLength(0);
            } else {
                value.append(character);
            }
        }
        values.add(value.toString().trim());
        return values;
    }

    private String cell(List<List<String>> rows, int row, int column) {
        if (row < 0 || row >= rows.size() || column < 0 || column >= rows.get(row).size()) return "";
        return rows.get(row).get(column) == null ? "" : rows.get(row).get(column).trim();
    }

    private BigDecimal number(String value) {
        if (value == null || value.isBlank()) return BigDecimal.ZERO;
        String numeric = value.replace(",", "").replaceAll("[^0-9+.-]", "");
        if (numeric.isBlank() || "+".equals(numeric) || "-".equals(numeric) || ".".equals(numeric)) return BigDecimal.ZERO;
        try {
            return new BigDecimal(numeric);
        } catch (NumberFormatException ignored) {
            return BigDecimal.ZERO;
        }
    }

    private Long offerNo(String value, int fallbackRow) {
        BigDecimal number = number(value);
        return number.signum() == 0 ? (long) fallbackRow + 1 : number.longValue();
    }

    private String tradeCode(String tradeText) {
        return tradeText != null && tradeText.contains("매수") ? "J" : "K";
    }

    private String normalizeAccount(String account) {
        return account == null ? "" : account.replace("-", "").trim();
    }

    private String normalizeKoscomCode(String code) {
        return code == null ? "" : code.trim();
    }

    private String leftPadCode(String code) {
        String normalized = code == null ? "" : code.trim();
        return normalized.length() >= 6 ? normalized.substring(normalized.length() - 6) : String.format("%6s", normalized).replace(' ', '0');
    }

    private String trimLeadingCharacter(String value) {
        String normalized = value == null ? "" : value.trim();
        return normalized.length() > 6 ? normalized.substring(1) : normalized;
    }

    private String errorMessage(MultipartFile file, int rowNumber, String message, String reference) {
        String filename = file.getOriginalFilename() == null ? "파일" : file.getOriginalFilename();
        return filename + " " + rowNumber + "행: " + message + " (" + (reference == null ? "" : reference) + ")";
    }

    private record RawTrade(int rowNumber, String acctNo, String jjNm, String koscomCd,
                            String trCd, Long offerNo, BigDecimal quantity, BigDecimal amount,
                            BigDecimal fee, BigDecimal tax) {
    }
}
