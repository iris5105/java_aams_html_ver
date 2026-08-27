package com.kfp.aams.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Web MVC & Jackson Configuration
 * Defines ObjectMapper Bean with JavaTimeModule (JSR-310) support for LocalDateTime/LocalDate,
 * and allows text/html content-type serialization for maps and objects.
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
    @SuppressWarnings("deprecation")
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        ObjectMapper mapper = objectMapper();

        MediaType textHtmlUtf8 = new MediaType("text", "html", StandardCharsets.UTF_8);
        MediaType appJsonUtf8 = new MediaType("application", "json", StandardCharsets.UTF_8);

        for (HttpMessageConverter<?> converter : converters) {
            if (converter instanceof MappingJackson2HttpMessageConverter jacksonConverter) {
                jacksonConverter.setObjectMapper(mapper);
                List<MediaType> mediaTypes = new ArrayList<>(jacksonConverter.getSupportedMediaTypes());
                if (!mediaTypes.contains(MediaType.TEXT_HTML)) {
                    mediaTypes.add(MediaType.TEXT_HTML);
                }
                if (!mediaTypes.contains(textHtmlUtf8)) {
                    mediaTypes.add(textHtmlUtf8);
                }
                if (!mediaTypes.contains(appJsonUtf8)) {
                    mediaTypes.add(appJsonUtf8);
                }
                jacksonConverter.setSupportedMediaTypes(mediaTypes);
            }
        }
    }
}
