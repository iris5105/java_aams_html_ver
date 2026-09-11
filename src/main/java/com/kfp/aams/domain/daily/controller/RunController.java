package com.kfp.aams.domain.daily.controller;

import com.kfp.aams.domain.daily.dto.RunCheckResultDto;
import com.kfp.aams.domain.daily.dto.RunExecuteRequestDto;
import com.kfp.aams.domain.daily.dto.RunItemDto;
import com.kfp.aams.domain.daily.service.RunService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class RunController {

    private final RunService runService;

    @GetMapping({"/views/w_run", "/views/daily/w_run"})
    public String runView(Model model) {
        return "views/daily/w_run";
    }

    @GetMapping("/api/daily/run/programs")
    @ResponseBody
    public ResponseEntity<List<RunItemDto>> getRunProgramList() {
        List<RunItemDto> list = runService.selectRunProgramList();
        return ResponseEntity.ok(list);
    }

    @PostMapping("/api/daily/run/execute-step")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> executeStep(
            @RequestBody RunExecuteRequestDto req,
            HttpSession session) {
        String userId = (String) session.getAttribute("userId");
        if (userId == null || userId.isBlank()) {
            userId = "ADMIN";
        }
        Map<String, Object> result = runService.executeSingleProgram(
                req.getCorpGr(), req.getYmd(), req.getPgmId(), userId);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/api/daily/run/clear-error")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> clearError() {
        Map<String, Object> result = new HashMap<>();
        try {
            int deleted = runService.deleteWfrmerr();
            result.put("success", true);
            result.put("deletedCount", deleted);
            result.put("message", "오류 메세지가 삭제되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("WFRMERR 삭제 에러: ", e);
            result.put("success", false);
            result.put("message", e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    @GetMapping("/api/daily/run/check-results")
    @ResponseBody
    public ResponseEntity<List<RunCheckResultDto>> getCheckResults(@RequestParam("corpGr") String corpGr) {
        List<RunCheckResultDto> list = runService.selectCheckResults(corpGr);
        return ResponseEntity.ok(list);
    }
}
