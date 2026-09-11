package com.kfp.aams.domain.common.controller;

import com.kfp.aams.domain.common.service.WorkDateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequiredArgsConstructor
public class WorkDateController {

    private final WorkDateService workDateService;

    /**
     * 회사그룹별 기준 작업일자 공통 조회 API
     * GET /api/common/workdate?corpGr=2402
     */
    @GetMapping("/api/common/workdate")
    public ResponseEntity<Map<String, String>> getWorkDate(@RequestParam(name = "corpGr", required = false) String corpGr) {
        String workDate = workDateService.getWorkDateOrDefault(corpGr);
        return ResponseEntity.ok(Map.of("workDate", workDate));
    }
}
