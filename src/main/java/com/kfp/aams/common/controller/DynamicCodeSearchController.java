package com.kfp.aams.common.controller;

import com.kfp.aams.common.service.DynamicCodeSearchService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/common/code-search")
public class DynamicCodeSearchController {

    private final DynamicCodeSearchService dynamicCodeSearchService;

    public DynamicCodeSearchController(DynamicCodeSearchService dynamicCodeSearchService) {
        this.dynamicCodeSearchService = dynamicCodeSearchService;
    }

    /**
     * 메타데이터 설정 조회 (모달 창 타이틀, 컬럼 헤더 등)
     */
    @GetMapping("/config")
    public Map<String, Object> getConfig(@RequestParam(name = "columnNm") String columnNm,
                                         @RequestParam(name = "seq", defaultValue = "1") Integer seq) {
        return dynamicCodeSearchService.getConfig(columnNm, seq);
    }

    /**
     * 모달 팝업 검색 목록 조회 (CODE_SELECT)
     */
    @GetMapping("/list")
    public List<Map<String, Object>> getList(@RequestParam(name = "columnNm") String columnNm,
                                             @RequestParam(name = "seq", defaultValue = "1") Integer seq,
                                             @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                             @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                             @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                             @RequestParam(name = "keyword", required = false) String keyword,
                                             @RequestParam(name = "addWhere", required = false) String addWhere,
                                             @AuthenticationPrincipal UserPrincipal principal) {
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr1, cookieCorpGr2, principal);
        return dynamicCodeSearchService.getCodeList(columnNm, seq, corpGr, keyword, addWhere);
    }

    /**
     * 단일 코드 검증 및 코드명 조회 (EDIT_SELECT)
     */
    @GetMapping("/get")
    public Map<String, Object> getItem(@RequestParam(name = "columnNm") String columnNm,
                                       @RequestParam(name = "seq", defaultValue = "1") Integer seq,
                                       @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                                       @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                                       @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                                       @RequestParam(name = "code") String code,
                                       @RequestParam(name = "addWhere", required = false) String addWhere,
                                       @AuthenticationPrincipal UserPrincipal principal) {
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr1, cookieCorpGr2, principal);
        Map<String, Object> item = dynamicCodeSearchService.getCodeItem(columnNm, seq, corpGr, code, addWhere);
        return item != null ? item : Collections.emptyMap();
    }

    private String resolveCorpGr(String paramCorpGr, String cookie1, String cookie2, UserPrincipal principal) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) return paramCorpGr.trim();
        if (cookie1 != null && !cookie1.isBlank()) return cookie1.trim();
        if (cookie2 != null && !cookie2.isBlank()) return cookie2.trim();
        if (principal != null && principal.getCorpGr() != null) return principal.getCorpGr().trim();
        return "";
    }
}
