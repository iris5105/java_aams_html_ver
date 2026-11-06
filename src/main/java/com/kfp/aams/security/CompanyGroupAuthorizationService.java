package com.kfp.aams.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Collection;

/**
 * Server-side company-group authorization policy.
 *
 * <p>Company-group values supplied by a URL, form, JSON body, or browser cookie are
 * untrusted. A regular user may access only the company group embedded in the verified
 * access token. An administrator ({@code adminYn=Y}) may access every company group.</p>
 */
@Slf4j
@Service
public class CompanyGroupAuthorizationService {

    public void assertAuthorized(UserPrincipal principal, Collection<String> requestedCorpGrs) {
        if (principal == null || requestedCorpGrs == null || requestedCorpGrs.isEmpty()) {
            return;
        }

        if (isAdministrator(principal)) {
            return;
        }

        String permittedCorpGr = normalize(principal.getCorpGr());
        if (!StringUtils.hasText(permittedCorpGr)) {
            throw new AccessDeniedException("사용자 회사그룹 권한이 없습니다.");
        }

        for (String requestedCorpGr : requestedCorpGrs) {
            String normalizedRequestedCorpGr = normalize(requestedCorpGr);
            if (StringUtils.hasText(normalizedRequestedCorpGr)
                    && !permittedCorpGr.equals(normalizedRequestedCorpGr)) {
                log.warn("Blocked company-group access. userId={}, tokenCorpGr={}, requestedCorpGr={}",
                        principal.getUserId(), permittedCorpGr, normalizedRequestedCorpGr);
                throw new AccessDeniedException("요청한 회사그룹에 대한 접근 권한이 없습니다.");
            }
        }
    }

    private boolean isAdministrator(UserPrincipal principal) {
        return "Y".equalsIgnoreCase(normalize(principal.getAdminYn()));
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
