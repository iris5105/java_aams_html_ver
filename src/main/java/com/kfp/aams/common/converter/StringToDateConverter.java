package com.kfp.aams.common.converter;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * JPA 엔티티의 String 날짜 필드와 오라클 DB의 DATE 컬럼 간 자동 변환기
 * - ORA-01861 (리터럴이 형식 문자열과 일치하지 않음) 방지
 * - YYYY-MM-DD, YYYY.MM.DD, YYYYMMDD 등 다양한 입력 형식을 안전하게 java.sql.Date로 바인딩
 */
@Converter
public class StringToDateConverter implements AttributeConverter<String, Date> {

    private static final DateTimeFormatter YMD_NO_SEP = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Override
    public Date convertToDatabaseColumn(String attribute) {
        if (attribute == null || attribute.isBlank()) {
            return null;
        }

        String str = attribute.trim();
        // 타임스탬프 형식 (YYYY-MM-DD HH:mm:ss) 대응
        if (str.length() >= 10 && str.charAt(4) == '-' && str.charAt(7) == '-') {
            try {
                return Date.valueOf(str.substring(0, 10));
            } catch (Exception ignored) {}
        }

        // 구분자 정규화 (점, 슬래시 -> 하이픈)
        String clean = str.replace(".", "-").replace("/", "-");
        if (clean.length() >= 10 && clean.contains("-")) {
            try {
                return Date.valueOf(clean.substring(0, 10));
            } catch (Exception ignored) {}
        }

        // 8자리 순수 숫자 (YYYYMMDD)
        String digits = str.replaceAll("[^0-9]", "");
        if (digits.length() == 8) {
            try {
                LocalDate ld = LocalDate.parse(digits, YMD_NO_SEP);
                return Date.valueOf(ld);
            } catch (Exception ignored) {}
        }

        return null;
    }

    @Override
    public String convertToEntityAttribute(Date dbData) {
        if (dbData == null) {
            return null;
        }
        return dbData.toLocalDate().toString(); // "YYYY-MM-DD"
    }
}
