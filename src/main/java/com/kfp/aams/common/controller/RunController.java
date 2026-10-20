package com.kfp.aams.common.controller;

import com.kfp.aams.common.dto.RunCheckResultDto;
import com.kfp.aams.common.dto.RunExecuteRequestDto;
import com.kfp.aams.common.dto.RunItemDto;
import com.kfp.aams.common.service.RunService;
import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.security.UserPrincipal;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
public class RunController {

    private final RunService runService;
    private final WorkDateService workDateService;

    public RunController(RunService runService, WorkDateService workDateService) {
        this.runService = runService;
        this.workDateService = workDateService;
    }

    @GetMapping({
        "/views/w_run",
        "/views/common/w_run",
        "/views/dailyadvisory/w_run",
        "/views/usportfoliomodel/w_run",
        "/views/foreignassetmanagement/w_run"
    })
    public String runView(@AuthenticationPrincipal Object principalObj,
                          @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                          @RequestParam(name = "ymd", required = false) String paramYmd,
                          @RequestParam(name = "fYmd", required = false) String paramFYmd,
                          @RequestParam(name = "tYmd", required = false) String paramTYmd,
                          @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                          @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                          Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        // 파워빌더 w_run.srw 및 w_winpage.srw idt_workdate (SZX0AA.HYUN_YMD) 기준 주입
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        String initialFrom = (paramFYmd != null && !paramFYmd.isBlank()) ? paramFYmd : workDate;
        String initialTo = (paramTYmd != null && !paramTYmd.isBlank()) ? paramTYmd : workDate;

        String fYmdDot = (initialFrom != null) ? initialFrom.replace("-", ".") : "";
        String tYmdDot = (initialTo != null) ? initialTo.replace("-", ".") : "";

        model.addAttribute("corpGr", corpGr);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("workDate", workDate);
        model.addAttribute("fYmd", fYmdDot);
        model.addAttribute("tYmd", tYmdDot);
        model.addAttribute("fymd", fYmdDot);
        model.addAttribute("tymd", tYmdDot);

        return "views/common/w_run";
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr.trim();
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr.trim();
        }
        if (principalObj instanceof UserPrincipal userPrincipal && userPrincipal.getCorpGr() != null && !userPrincipal.getCorpGr().isBlank()) {
            return userPrincipal.getCorpGr().trim();
        }
        return null;
    }

    @GetMapping({"/api/common/run/programs", "/api/daily/run/programs"})
    @ResponseBody
    public ResponseEntity<List<RunItemDto>> getRunProgramList() {
        List<RunItemDto> list = runService.selectRunProgramList();
        return ResponseEntity.ok(list);
    }

    @PostMapping({"/api/common/run/execute-step", "/api/daily/run/execute-step"})
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

    @PostMapping({"/api/common/run/clear-error", "/api/daily/run/clear-error"})
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

    @GetMapping({"/api/common/run/check-results", "/api/daily/run/check-results"})
    @ResponseBody
    public ResponseEntity<List<RunCheckResultDto>> getCheckResults(@RequestParam("corpGr") String corpGr) {
        List<RunCheckResultDto> list = runService.selectCheckResults(corpGr);
        return ResponseEntity.ok(list);
    }
}
