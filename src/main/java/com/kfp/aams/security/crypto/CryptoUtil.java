package com.kfp.aams.security.crypto;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * CryptoUtil
 * AES-256-CBC URL-Safe 암/복호화 유틸리티
 * - IV (16 bytes)를 무작위 생성하여 암호문 앞에 결합
 * - Base64 URL-Safe (RFC 4648) 포맷으로 변환하여 URL 쿼리 파라미터 및 JSON Payload 안전 전송
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class CryptoUtil {

    private final CryptoProperties cryptoProperties;
    private static final String ALGORITHM = "AES/CBC/PKCS5Padding";
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    /**
     * 기본 설정된 키로 암호화
     */
    public String encrypt(String plainText) {
        if (plainText == null) return null;
        return encrypt(plainText, cryptoProperties.getSecretKey());
    }

    /**
     * 기본 설정된 키로 복호화
     */
    public String decrypt(String cipherText) {
        if (cipherText == null || cipherText.isBlank()) return cipherText;
        return decrypt(cipherText, cryptoProperties.getSecretKey());
    }

    /**
     * 지정 키로 AES-256-CBC 암호화
     */
    public static String encrypt(String plainText, String secretKey) {
        if (plainText == null) return null;
        try {
            byte[] keyBytes = normalizeKey(secretKey);
            SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");

            // 16바이트 무작위 IV 생성
            byte[] iv = new byte[16];
            SECURE_RANDOM.nextBytes(iv);
            IvParameterSpec ivSpec = new IvParameterSpec(iv);

            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);
            byte[] encrypted = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

            // [IV (16 bytes)] + [Encrypted Data] 결합
            byte[] combined = new byte[iv.length + encrypted.length];
            System.arraycopy(iv, 0, combined, 0, iv.length);
            System.arraycopy(encrypted, 0, combined, iv.length, encrypted.length);

            // URL-Safe Base64 인코딩 (패딩 생략)
            return Base64.getUrlEncoder().withoutPadding().encodeToString(combined);
        } catch (Exception e) {
            log.error("[CryptoUtil] Encryption failed: {}", e.getMessage(), e);
            throw new RuntimeException("암호화 처리 중 오류가 발생했습니다.", e);
        }
    }

    /**
     * 지정 키로 AES-256-CBC 복호화
     */
    public static String decrypt(String cipherText, String secretKey) {
        if (cipherText == null || cipherText.isBlank()) return cipherText;
        try {
            byte[] keyBytes = normalizeKey(secretKey);
            SecretKeySpec keySpec = new SecretKeySpec(keyBytes, "AES");

            // Base64Url 디코딩
            byte[] combined = Base64.getUrlDecoder().decode(cipherText.trim());
            if (combined.length <= 16) {
                log.warn("[CryptoUtil] Ciphertext too short: length {}", combined.length);
                return cipherText;
            }

            // 앞 16바이트 IV 분리
            byte[] iv = new byte[16];
            System.arraycopy(combined, 0, iv, 0, 16);
            IvParameterSpec ivSpec = new IvParameterSpec(iv);

            // 나머지 바이트 복호화
            int encryptedLength = combined.length - 16;
            byte[] encrypted = new byte[encryptedLength];
            System.arraycopy(combined, 16, encrypted, 0, encryptedLength);

            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
            byte[] decrypted = cipher.doFinal(encrypted);

            return new String(decrypted, StandardCharsets.UTF_8);
        } catch (Exception e) {
            log.error("[CryptoUtil] Decryption failed for text [{}]: {}", cipherText, e.getMessage());
            // 복호화 실패 시 원본 반환 (하위 호환성)
            return cipherText;
        }
    }

    /**
     * 32바이트(256비트) 키 정규화
     */
    private static byte[] normalizeKey(String key) {
        byte[] raw = (key != null ? key : "AAMS_DEFAULT_KEY_32_BYTES_SAFE!").getBytes(StandardCharsets.UTF_8);
        byte[] key32 = new byte[32];
        System.arraycopy(raw, 0, key32, 0, Math.min(raw.length, 32));
        // 32바이트 미만인 경우 패딩
        for (int i = raw.length; i < 32; i++) {
            key32[i] = (byte) '#';
        }
        return key32;
    }
}
