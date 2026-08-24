package com.kfp.aams.security;

import com.kfp.aams.domain.auth.dto.UserDto;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Slf4j
@Component
public class JwtProvider {

    private final SecretKey key;

    // Access token validity: 30 minutes
    public static final long ACCESS_TOKEN_EXPIRE_TIME = 30 * 60 * 1000L;

    // Refresh token validity: 1 week (7 days)
    public static final long REFRESH_TOKEN_EXPIRE_TIME = 7 * 24 * 60 * 60 * 1000L;

    public JwtProvider(@Value("${jwt.secret:AAMS_SECRET_KEY_FOR_JWT_TOKEN_AUTHENTICATION_32BYTES_LONG}") String secret) {
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            secret = String.format("%-32s", secret).replace(' ', '0');
            keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        }
        this.key = Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * Create Access Token with all UserDto claims and custom expiration duration
     */
    public String createAccessToken(UserDto userDto, long expireTimeMs) {
        if (userDto == null) {
            userDto = new UserDto();
        }
        Date now = new Date();
        Date validity = new Date(now.getTime() + expireTimeMs);

        return Jwts.builder()
                .subject(userDto.getUserId())
                .claim("userId", userDto.getUserId())
                .claim("userNm", userDto.getUserNm())
                .claim("outYmd", userDto.getOutYmd() != null ? userDto.getOutYmd() : "99991231")
                .claim("deptCd", userDto.getDeptCd() != null ? userDto.getDeptCd() : "A420")
                .claim("deptNm", userDto.getDeptNm())
                .claim("inYmd", userDto.getInYmd())
                .claim("corpGr", userDto.getCorpGr())
                .claim("adminYn", userDto.getAdminYn())
                .claim("managerYn", userDto.getManagerYn())
                .claim("watchmanYn", userDto.getWatchmanYn())
                .claim("bookmarkStart", userDto.getBookmarkStart())
                .claim("lastConnect", userDto.getLastConnect())
                .claim("encEMail", userDto.getEncEMail())
                .claim("companyName", userDto.getCompanyName())
                .claim("hyunYmd", userDto.getHyunYmd())
                .claim("customerGr", userDto.getCustomerGr())
                .issuedAt(now)
                .expiration(validity)
                .signWith(key)
                .compact();
    }

    /**
     * Create Access Token with default 30 minutes expiration
     */
    public String createAccessToken(UserDto userDto) {
        return createAccessToken(userDto, ACCESS_TOKEN_EXPIRE_TIME);
    }

    /**
     * Create Access Token with userId and corpGr (fallback)
     */
    public String createAccessToken(String userId, String corpGr) {
        UserDto userDto = UserDto.builder()
                .userId(userId)
                .corpGr(corpGr)
                .outYmd("99991231")
                .deptCd("A420")
                .build();
        return createAccessToken(userDto);
    }

    /**
     * Create Refresh Token (1 week expiration) containing userId and corpGr
     */
    public String createRefreshToken(String userId, String corpGr) {
        Date now = new Date();
        Date validity = new Date(now.getTime() + REFRESH_TOKEN_EXPIRE_TIME);

        return Jwts.builder()
                .subject(userId)
                .claim("userId", userId)
                .claim("corpGr", corpGr)
                .claim("type", "REFRESH")
                .issuedAt(now)
                .expiration(validity)
                .signWith(key)
                .compact();
    }

    /**
     * Validate JWT Token
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token);
            return true;
        } catch (SecurityException | MalformedJwtException e) {
            log.warn("Invalid JWT Signature: {}", e.getMessage());
        } catch (ExpiredJwtException e) {
            log.warn("Expired JWT Token: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            log.warn("Unsupported JWT Token: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            log.warn("JWT Claims string is empty: {}", e.getMessage());
        }
        return false;
    }

    /**
     * Parse Claims from token
     */
    public Claims getClaims(String token) {
        return Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Get remaining expiration time in milliseconds for the token
     */
    public long getRemainingExpirationMillis(String token) {
        try {
            Claims claims = getClaims(token);
            Date expiration = claims.getExpiration();
            long remaining = expiration.getTime() - System.currentTimeMillis();
            return Math.max(0L, remaining);
        } catch (Exception e) {
            return 0L;
        }
    }

    public String getUserId(String token) {
        Claims claims = getClaims(token);
        String userId = claims.get("userId", String.class);
        return userId != null ? userId : claims.getSubject();
    }

    public String getCorpGr(String token) {
        Claims claims = getClaims(token);
        return claims.get("corpGr", String.class);
    }

    /**
     * Build UserPrincipal from JWT claims
     */
    public UserPrincipal getUserPrincipal(String token) {
        Claims claims = getClaims(token);
        String userId = claims.get("userId", String.class);
        if (userId == null) {
            userId = claims.getSubject();
        }
        UserDto userDto = UserDto.builder()
                .userId(userId)
                .userNm(claims.get("userNm", String.class))
                .outYmd(claims.get("outYmd", String.class))
                .deptCd(claims.get("deptCd", String.class))
                .deptNm(claims.get("deptNm", String.class))
                .inYmd(claims.get("inYmd", String.class))
                .corpGr(claims.get("corpGr", String.class))
                .adminYn(claims.get("adminYn", String.class))
                .managerYn(claims.get("managerYn", String.class))
                .watchmanYn(claims.get("watchmanYn", String.class))
                .bookmarkStart(claims.get("bookmarkStart", String.class))
                .lastConnect(claims.get("lastConnect", String.class))
                .encEMail(claims.get("encEMail", String.class))
                .companyName(claims.get("companyName", String.class))
                .hyunYmd(claims.get("hyunYmd", String.class))
                .customerGr(claims.get("customerGr", String.class))
                .build();

        return new UserPrincipal(userDto);
    }
}
