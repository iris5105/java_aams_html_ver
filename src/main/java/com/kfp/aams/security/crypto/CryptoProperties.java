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

    private final org.springframework.core.env.Environment environment;

    public CryptoProperties(org.springframework.core.env.Environment environment) {
        this.environment = environment;
    }

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

        // 1. Environment 활성 프로파일 확인
        if (environment != null) {
            String[] activeProfiles = environment.getActiveProfiles();
            if (activeProfiles != null) {
                for (String p : activeProfiles) {
                    if ("prod".equalsIgnoreCase(p) || "production".equalsIgnoreCase(p)) {
                        log.info("[CryptoProperties] Payload encryption ENABLED by active profile: {}", p);
                        return true;
                    }
                }
            }
            String propActive = environment.getProperty("spring.profiles.active");
            if (propActive != null && propActive.toLowerCase().contains("prod")) {
                log.info("[CryptoProperties] Payload encryption ENABLED by spring.profiles.active property: {}", propActive);
                return true;
            }
        }

        // 2. System property 확인
        String sysProfile = System.getProperty("spring.profiles.active");
        if (sysProfile != null && sysProfile.toLowerCase().contains("prod")) {
            log.info("[CryptoProperties] Payload encryption ENABLED by System property spring.profiles.active: {}", sysProfile);
            return true;
        }

        // 3. 운영 OS (Linux / Unix / SunOS) 자동 감지
        String os = System.getProperty("os.name", "").toLowerCase();
        if (os.contains("linux") || os.contains("unix") || os.contains("sunos") || os.contains("solaris")) {
            log.info("[CryptoProperties] Payload encryption ENABLED by OS: {}", os);
            return true;
        }

        // 로컬 환경 (Windows 등)은 기본 false (평문 디버깅 유지)
        return false;
    }

    public String getDetectionReason() {
        if ("true".equalsIgnoreCase(enabledMode)) return "FORCED_TRUE";
        if ("false".equalsIgnoreCase(enabledMode)) return "FORCED_FALSE";
        if (environment != null) {
            for (String p : environment.getActiveProfiles()) {
                if ("prod".equalsIgnoreCase(p) || "production".equalsIgnoreCase(p)) return "PROFILE_" + p;
            }
            String prop = environment.getProperty("spring.profiles.active");
            if (prop != null && prop.toLowerCase().contains("prod")) return "PROPERTY_PROD";
        }
        String sys = System.getProperty("spring.profiles.active");
        if (sys != null && sys.toLowerCase().contains("prod")) return "SYSPROP_PROD";
        String os = System.getProperty("os.name", "").toLowerCase();
        if (os.contains("linux") || os.contains("unix")) return "OS_LINUX";
        return "DEV_LOCAL";
    }
}
