package com.kfp.aams.util;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * AAMS 쿠키 보안 암호화 유틸리티 (AES-128-CBC / PKCS5Padding)
 * savedEmail, userId 등의 민감 쿠키 정보를 브라우저에 안전하게 암호화하여 저장
 */
public class CookieCryptoUtil {

    private static final Logger log = Logger.getLogger(CookieCryptoUtil.class.getName());

    private static final String ALGORITHM = "AES/CBC/PKCS5Padding";
    // 16바이트 AES-128 대칭키
    private static final byte[] SECRET_KEY = "AamsCookieKey16!".getBytes(StandardCharsets.UTF_8);
    // 16바이트 고정 초기화 벡터 (IV)
    private static final byte[] IV_BYTES = "AamsCookieIv16!!".getBytes(StandardCharsets.UTF_8);
    // 암호화된 쿠키 식별 접두사
    public static final String PREFIX = "ENC_";

    /**
     * 평문 문자열을 AES-128-CBC 암호화 후 URL-Safe Base64 문자열로 반환
     */
    public static String encrypt(String plainText) {
        if (plainText == null || plainText.isBlank()) {
            return plainText;
        }
        try {
            SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY, "AES");
            IvParameterSpec ivSpec = new IvParameterSpec(IV_BYTES);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);

            byte[] encrypted = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
            String base64 = Base64.getUrlEncoder().withoutPadding().encodeToString(encrypted);
            return PREFIX + base64;
        } catch (Exception e) {
            log.log(Level.SEVERE, "[CookieCryptoUtil] 암호화 실패: " + e.getMessage(), e);
            return plainText;
        }
    }

    /**
     * 암호화된 쿠키 값을 복호화하여 원래의 평문으로 반환
     * 만약 "ENC_" 접두사가 없으면 (구버전 평문 쿠키) 그대로 반환하여 하위 호환성 유지
     */
    public static String decrypt(String cipherText) {
        if (cipherText == null || cipherText.isBlank()) {
            return cipherText;
        }
        if (!cipherText.startsWith(PREFIX)) {
            // 과거 평문 쿠키 호환
            return cipherText;
        }
        try {
            String base64 = cipherText.substring(PREFIX.length());
            byte[] decoded = Base64.getUrlDecoder().decode(base64);

            SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY, "AES");
            IvParameterSpec ivSpec = new IvParameterSpec(IV_BYTES);
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);

            byte[] decrypted = cipher.doFinal(decoded);
            return new String(decrypted, StandardCharsets.UTF_8);
        } catch (Exception e) {
            log.log(Level.WARNING, "[CookieCryptoUtil] 복호화 실패 for input [" + cipherText + "]: " + e.getMessage());
            return cipherText;
        }
    }
}
