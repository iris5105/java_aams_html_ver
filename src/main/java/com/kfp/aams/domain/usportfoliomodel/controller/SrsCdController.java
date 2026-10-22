package com.kfp.aams.domain.usportfoliomodel.controller;

import com.kfp.aams.common.service.WorkDateService;
import com.kfp.aams.domain.usportfoliomodel.dto.SrsCdDetailDto;
import com.kfp.aams.domain.usportfoliomodel.dto.SrsCdMasterDto;
import com.kfp.aams.domain.usportfoliomodel.service.SrsCdService;
import com.kfp.aams.menu.service.MenuService;
import com.kfp.aams.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 해외파생 생성종목 현황 (W_SRS_CD) 컨트롤러
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class SrsCdController {

    private final SrsCdService srsCdService;
    private final MenuService menuService;
    private final WorkDateService workDateService;

    /**
     * 화면 뷰 렌더링
     */
    @GetMapping({"/views/w_srs_cd", "/views/usportfoliomodel/w_srs_cd"})
    public String viewSrsCd(@AuthenticationPrincipal Object principalObj,
                            @RequestParam(name = "corpGr", required = false) String paramCorpGr,
                            @RequestParam(name = "ymd", required = false) String paramYmd,
                            @CookieValue(name = "savedCorpGr", required = false) String cookieCorpGr1,
                            @CookieValue(name = "corpGr", required = false) String cookieCorpGr2,
                            Model model) {
        String cookieCorpGr = (cookieCorpGr1 != null && !cookieCorpGr1.isBlank()) ? cookieCorpGr1 : cookieCorpGr2;
        String corpGr = resolveCorpGr(paramCorpGr, cookieCorpGr, principalObj);

        var menuDto = menuService.getMenuByPgmId("W_SRS_CD");
        if (menuDto == null) {
            menuDto = menuService.getMenuByPgmId("w_srs_cd");
        }
        String fullpgm2 = (menuDto != null && menuDto.getFullpgm2() != null)
                ? menuDto.getFullpgm2()
                : "사무관리 > US Portfolio Model > 주식/지수/통화 정보관리 > 해외파생 생성종목 현황";

        // DB 영업일자 (SZX0AA.HYUN_YMD) 연동 (규정 01-3 Zero-LocalDate-Now 원칙)
        String workDate = (paramYmd != null && !paramYmd.isBlank())
                ? paramYmd
                : workDateService.getWorkDateOrDefault(corpGr);

        model.addAttribute("fullpgm2", fullpgm2);
        model.addAttribute("corpGr", corpGr);
        model.addAttribute("workDate", workDate);
        model.addAttribute("initialYmd", workDate);
        model.addAttribute("ymd", workDate);

        return "views/usportfoliomodel/w_srs_cd";
    }

    /**
     * 마스터 목록 조회 (SRS_CD)
     */
    @GetMapping("/api/usportfoliomodel/srs-cd/master")
    @ResponseBody
    public List<SrsCdMasterDto> getMasterList(@RequestParam(name = "isinCd", required = false) String isinCd) {
        try {
            return srsCdService.getMasterList(isinCd);
        } catch (Exception e) {
            log.error("해외파생 생성종목 마스터 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 디테일 시세 내역 조회 (SYT0LP)
     */
    @GetMapping("/api/usportfoliomodel/srs-cd/detail")
    @ResponseBody
    public List<SrsCdDetailDto> getDetailList(@RequestParam(name = "corpGr") String corpGr,
                                              @RequestParam(name = "jmCd") String jmCd,
                                              @RequestParam(name = "ymd") String ymd) {
        try {
            return srsCdService.getDetailList(corpGr, jmCd, ymd);
        } catch (Exception e) {
            log.error("해외옵션 시세 내역 조회 실패: {}", e.getMessage(), e);
            return Collections.emptyList();
        }
    }

    /**
     * 파생코드 자동 계산
     */
    @GetMapping("/api/usportfoliomodel/srs-cd/calc-code")
    @ResponseBody
    public Map<String, Object> calcCode(@RequestParam(name = "exprDate") String exprDate,
                                        @RequestParam(name = "blbgTckr") String blbgTckr,
                                        @RequestParam(name = "stkprc") BigDecimal stkprc,
                                        @RequestParam(name = "isCallPut", required = false) String isCallPut) {
        Map<String, Object> result = new HashMap<>();
        String derivedCode = srsCdService.calcDerivedCode(exprDate, blbgTckr, stkprc, isCallPut);
        result.put("derivedCode", derivedCode);
        return result;
    }

    /**
     * 마스터 목록 CUD 일괄 저장
     */
    @PostMapping("/api/usportfoliomodel/srs-cd/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveMasterList(@RequestBody List<SrsCdMasterDto> list) {
        Map<String, Object> result = new HashMap<>();
        try {
            int count = srsCdService.saveMasterList(list);
            result.put("success", true);
            result.put("message", "정상적으로 저장되었습니다. (반영: " + count + "건)");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("해외파생 생성종목 저장 실패: {}", e.getMessage(), e);
            result.put("success", false);
            result.put("message", "저장 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.internalServerError().body(result);
        }
    }

    private String resolveCorpGr(String paramCorpGr, String cookieCorpGr, Object principalObj) {
        if (paramCorpGr != null && !paramCorpGr.isBlank()) {
            return paramCorpGr;
        }
        if (cookieCorpGr != null && !cookieCorpGr.isBlank()) {
            return cookieCorpGr;
        }
        if (principalObj instanceof UserPrincipal userPrincipal && userPrincipal.getCorpGr() != null && !userPrincipal.getCorpGr().isBlank()) {
            return userPrincipal.getCorpGr();
        }
        return "";
    }
}
