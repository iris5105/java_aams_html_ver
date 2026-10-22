package com.kfp.aams.security.crypto;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * CryptoProperties
 * Payload 및 URL 파라미터 암호화 설정
 * - enabled: "auto" (기본값) -> prod 프로파일이거나 OS가 Linux인 경우 자동 활성화
 * - enabled: "true" -> 강제 활성화 (테스트용)
 * - enabled: "false" -> 강제 비활성화
 */
@Slf4j
@Getter
@Setter
@Component
public class CryptoProperties {

    @Value("${app.security.encryption.enabled:auto}")
    private String enabledMode;

    @Value("${app.security.encryption.secret-key:AAMS_2026_SECURE_PAYLOAD_KEY_32!}")
    private String secretKey;

    @Value("${spring.profiles.active:default}")
    private String activeProfile;

    /**
     * 암호화 활성화 여부 판별 (Dual Fallback: prod 프로파일 또는 Linux OS 자동 감지)
     */
    public boolean isEncryptionEnabled() {
        if ("true".equalsIgnoreCase(enabledMode)) {
            return true;
        }
        if ("false".equalsIgnoreCase(enabledMode)) {
            return false;
        }

        // 1. prod 프로파일 확인
        if ("prod".equalsIgnoreCase(activeProfile)) {
            return true;
        }

        // 2. 운영 OS (Linux / Unix) 자동 감지
        String os = System.getProperty("os.name", "").toLowerCase();
        if (os.contains("linux") || os.contains("unix")) {
            return true;
        }

        // 로컬 환경 (Windows 등)은 기본 false (평문 디버깅 유지)
        return false;
    }
}
