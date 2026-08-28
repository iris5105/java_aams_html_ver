package com.kfp.aams.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Web MVC & Jackson Configuration
 * Defines ObjectMapper Bean with JavaTimeModule (JSR-310) support for LocalDateTime/LocalDate,
 * and allows text/html content-type serialization for maps and objects via HttpMessageConverter Bean.
 */
@Configuration
public class WebConfig {

    @Bean
    @Primary
    public ObjectMapper objectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        return mapper;
    }

    @Bean
    @SuppressWarnings("removal")
    public MappingJackson2HttpMessageConverter mappingJackson2HttpMessageConverter(ObjectMapper objectMapper) {
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter(objectMapper);
        
        List<MediaType> mediaTypes = new ArrayList<>(converter.getSupportedMediaTypes());
        MediaType textHtmlUtf8 = new MediaType("text", "html", StandardCharsets.UTF_8);
        MediaType appJsonUtf8 = new MediaType("application", "json", StandardCharsets.UTF_8);

        if (!mediaTypes.contains(MediaType.TEXT_HTML)) {
            mediaTypes.add(MediaType.TEXT_HTML);
        }
        if (!mediaTypes.contains(textHtmlUtf8)) {
            mediaTypes.add(textHtmlUtf8);
        }
        if (!mediaTypes.contains(appJsonUtf8)) {
            mediaTypes.add(appJsonUtf8);
        }
        converter.setSupportedMediaTypes(mediaTypes);

        return converter;
    }
}
