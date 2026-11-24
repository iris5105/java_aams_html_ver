package com.kfp.aams.security;

import com.fasterxml.jackson.databind.JsonNode;
import com.kfp.aams.common.dto.ButtonAuthDto;
import com.kfp.aams.common.service.ButtonAuthService;
import com.kfp.aams.menu.dto.MenuDto;
import com.kfp.aams.menu.service.MenuService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;

import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Enforces server-side action permissions for AAMS program mutation APIs.
 * Authentication is performed before this service is invoked. Administrators
 * bypass authorization only; validation and business rules still apply.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ProgramActionAuthorizationService {

    private static final Pattern PROGRAM_ID_PATTERN = Pattern.compile(
            "/(?:w_)?(ja\\d{3}[a-z0-9]*)/", Pattern.CASE_INSENSITIVE);

    private final MenuService menuService;
    private final ButtonAuthService buttonAuthService;

    public boolean supportsProgramUri(String requestUri) {
        return requestUri != null && PROGRAM_ID_PATTERN.matcher(requestUri).find();
    }

    public void assertMutationAuthorized(UserPrincipal principal, String requestUri) {
        if (isAdministrator(principal)) {
            return;
        }

        AuthorizationContext context = resolveContext(principal, requestUri);
        Action action = actionFromUri(requestUri);
        if (!isAllowed(context.buttonAuth(), action)) {
            deny(principal, context.programId(), action);
        }
    }

    public void assertPayloadAuthorized(UserPrincipal principal, String requestUri, JsonNode payload) {
        if (isAdministrator(principal) || !containsDeletion(payload)) {
            return;
        }

        AuthorizationContext context = resolveContext(principal, requestUri);
        if (!isAllowed(context.buttonAuth(), Action.DELETE)) {
            deny(principal, context.programId(), Action.DELETE);
        }
    }

    private AuthorizationContext resolveContext(UserPrincipal principal, String requestUri) {
        if (principal == null || principal.getUserId() == null || principal.getUserId().isBlank()) {
            throw new AccessDeniedException("인증된 사용자가 필요합니다.");
        }

        String programId = resolveProgramId(requestUri);
        if (programId == null) {
            throw new AccessDeniedException("변경 요청의 프로그램 정보를 확인할 수 없습니다.");
        }

        MenuDto menu = menuService.getMenuByPgmId(programId);
        if (menu == null || menu.getPgmNo() == null || menu.getPgmNo().isBlank()) {
            log.warn("No menu program was found for mutation API. userId={}, uri={}, pgmId={}",
                    principal.getUserId(), requestUri, programId);
            throw new AccessDeniedException("변경 요청에 대한 프로그램 권한 정보를 찾을 수 없습니다.");
        }

        ButtonAuthDto buttonAuth = buttonAuthService.getButtonAuth(
                principal.getUserId(),
                principal.getCorpGr(),
                principal.getAdminYn(),
                principal.getUserNm(),
                menu.getPgmNo());
        return new AuthorizationContext(programId, buttonAuth);
    }

    private String resolveProgramId(String requestUri) {
        if (requestUri == null) {
            return null;
        }
        Matcher matcher = PROGRAM_ID_PATTERN.matcher(requestUri);
        if (!matcher.find()) {
            return null;
        }
        return "W_" + matcher.group(1).toUpperCase(Locale.ROOT);
    }

    private Action actionFromUri(String requestUri) {
        String uri = requestUri == null ? "" : requestUri.toLowerCase(Locale.ROOT);
        if (uri.contains("/delete")) {
            return Action.DELETE;
        }
        if (uri.contains("/input") || uri.contains("/insert") || uri.contains("/create") || uri.contains("/add")) {
            return Action.INPUT;
        }
        if (uri.contains("/execute") || uri.contains("/run") || uri.contains("/generate")) {
            return Action.EXECUTE;
        }
        return Action.UPDATE;
    }

    private boolean containsDeletion(JsonNode node) {
        if (node == null || node.isNull()) {
            return false;
        }
        if (node.isArray()) {
            for (JsonNode element : node) {
                if (containsDeletion(element)) {
                    return true;
                }
            }
            return false;
        }
        if (!node.isObject()) {
            return false;
        }

        java.util.Iterator<java.util.Map.Entry<String, JsonNode>> fields = node.fields();
        while (fields.hasNext()) {
            java.util.Map.Entry<String, JsonNode> field = fields.next();
            String name = field.getKey().replace("_", "").toLowerCase(Locale.ROOT);
            JsonNode value = field.getValue();
            if (("isdeleted".equals(name) && value.asBoolean(false))
                    || ("rowstatus".equals(name) && "D".equalsIgnoreCase(value.asText()))
                    || (("deletedrows".equals(name) || "deletedlist".equals(name) || "deletelist".equals(name))
                    && value.isArray() && !value.isEmpty())) {
                return true;
            }
            if (containsDeletion(value)) {
                return true;
            }
        }
        return false;
    }

    private boolean isAdministrator(UserPrincipal principal) {
        return principal != null && "Y".equalsIgnoreCase(principal.getAdminYn());
    }

    private boolean isAllowed(ButtonAuthDto buttonAuth, Action action) {
        if (buttonAuth == null || !buttonAuth.isCommBtnAuthYn()) {
            return false;
        }
        return switch (action) {
            case INPUT -> buttonAuth.isInputAuthYn();
            case UPDATE -> buttonAuth.isUpdateAuthYn();
            case DELETE -> buttonAuth.isDeleteAuthYn();
            case EXECUTE -> buttonAuth.isExecuteAuthYn();
        };
    }

    private void deny(UserPrincipal principal, String programId, Action action) {
        log.warn("Blocked program action. userId={}, programId={}, action={}",
                principal.getUserId(), programId, action);
        throw new AccessDeniedException("해당 화면의 " + action.label + " 권한이 없습니다.");
    }

    private record AuthorizationContext(String programId, ButtonAuthDto buttonAuth) {
    }

    private enum Action {
        INPUT("등록"),
        UPDATE("수정"),
        DELETE("삭제"),
        EXECUTE("실행");

        private final String label;

        Action(String label) {
            this.label = label;
        }
    }
}
