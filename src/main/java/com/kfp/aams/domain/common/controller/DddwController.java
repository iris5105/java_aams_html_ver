package com.kfp.aams.domain.common.controller;

import com.kfp.aams.domain.common.dto.DddwDto;
import com.kfp.aams.domain.common.service.DddwService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class DddwController {

    private final DddwService dddwService;

    /**
     * REST Endpoint for DropDownDataWindow options
     * Example: GET /api/common/dddw?dddwNm=corp_gr_1&addWhere=USE_YN='Y'
     */
    @GetMapping("/api/common/dddw")
    public List<DddwDto> getDddwList(@RequestParam(name = "dddwNm", defaultValue = "corp_gr_1") String dddwNm,
                                     @RequestParam(name = "addWhere", required = false) String addWhere,
                                     HttpSession session) {
        return dddwService.getDddwList(dddwNm, addWhere, session);
    }
}
