package com.kfp.aams.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.http.MediaType;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Web MVC & Jackson Configuration
 * Defines ObjectMapper Bean with JavaTimeModule (JSR-310) support for LocalDateTime/LocalDate,
 * and ensures ByteArrayHttpMessageConverter has the highest precedence to prevent byte[] responses
 * (such as HTML reports, PDF, Excel) from being serialized as Base64 JSON strings.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return mapper;
    }

    @Override
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        // 1. ByteArrayHttpMessageConverter를 최상단(0순위)에 배치:
        // byte[] 응답(HTML 리포트, PDF, 엑셀 등)이 Jackson에 의해 Base64 인코딩 문자열로 변환되는 현상 원천 차단
        ByteArrayHttpMessageConverter byteArrayConverter = new ByteArrayHttpMessageConverter();
        List<MediaType> byteTypes = new ArrayList<>();
        byteTypes.add(MediaType.APPLICATION_OCTET_STREAM);
        byteTypes.add(MediaType.APPLICATION_PDF);
        byteTypes.add(MediaType.TEXT_HTML);
        byteTypes.add(new MediaType("text", "html", StandardCharsets.UTF_8));
        byteTypes.add(MediaType.ALL);
        byteArrayConverter.setSupportedMediaTypes(byteTypes);
        converters.add(0, byteArrayConverter);

        // 2. StringHttpMessageConverter (UTF-8 기본 적용)
        StringHttpMessageConverter stringConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        converters.add(1, stringConverter);

        // 3. MappingJackson2HttpMessageConverter 설정
        ObjectMapper mapper = objectMapper();
        MediaType textHtmlUtf8 = new MediaType("text", "html", StandardCharsets.UTF_8);
        MediaType appJsonUtf8 = new MediaType("application", "json", StandardCharsets.UTF_8);

        for (HttpMessageConverter<?> converter : converters) {
            if (converter instanceof MappingJackson2HttpMessageConverter jacksonConverter) {
                jacksonConverter.setObjectMapper(mapper);
                List<MediaType> mediaTypes = new ArrayList<>(jacksonConverter.getSupportedMediaTypes());
                if (!mediaTypes.contains(MediaType.APPLICATION_JSON)) {
                    mediaTypes.add(MediaType.APPLICATION_JSON);
                }
                if (!mediaTypes.contains(appJsonUtf8)) {
                    mediaTypes.add(appJsonUtf8);
                }
                // DTO 객체 직렬화 호환을 위해 text/html 도 지원하되, byte[]는 앞선 ByteArrayHttpMessageConverter가 우선 처리
                if (!mediaTypes.contains(MediaType.TEXT_HTML)) {
                    mediaTypes.add(MediaType.TEXT_HTML);
                }
                if (!mediaTypes.contains(textHtmlUtf8)) {
                    mediaTypes.add(textHtmlUtf8);
                }
                jacksonConverter.setSupportedMediaTypes(mediaTypes);
            }
        }
    }
}
