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
    public List<DddwDto> getDddwList(@RequestParam(name = "dddwId", required = false) String dddwId,
                                     @RequestParam(name = "dddwNm", required = false) String dddwNm,
                                     @RequestParam(name = "seq", defaultValue = "1") Integer seq,
                                     @RequestParam(name = "addWhere", required = false) String addWhere,
                                     @RequestParam(name = "addOrderBy", required = false) String addOrderBy,
                                     HttpSession session) {
        String targetId = (dddwId != null && !dddwId.isBlank()) ? dddwId : dddwNm;
        return dddwService.getDddwList(targetId, seq, addWhere, addOrderBy, session);
    }
}
