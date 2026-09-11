package com.kfp.aams.domain.daily.service;

import com.kfp.aams.domain.daily.dto.RunCheckResultDto;
import com.kfp.aams.domain.daily.dto.RunItemDto;
import com.kfp.aams.domain.daily.mapper.RunMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class RunService {

    private final RunMapper runMapper;

    @Transactional(readOnly = true)
    public List<RunItemDto> selectRunProgramList() {
        return runMapper.selectRunProgramList();
    }

    @Transactional
    public Map<String, Object> executeSingleProgram(String corpGr, String ymd, String pgmId, String userId) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("corpGr", corpGr);
        // ymd format: yyyy.mm.dd
        String formattedYmd = ymd.replace("-", ".");
        paramMap.put("ymd", formattedYmd);
        paramMap.put("pgmId", pgmId);
        paramMap.put("userId", (userId != null && !userId.isBlank()) ? userId : "ADMIN");
        paramMap.put("outMsg", "");

        Map<String, Object> result = new HashMap<>();
        try {
            runMapper.callSrExec(paramMap);
            String outMsg = (String) paramMap.get("outMsg");
            if (outMsg == null) outMsg = "N";

            boolean success = "Y".equalsIgnoreCase(outMsg.trim());
            result.put("success", success);
            result.put("outMsg", outMsg);
            result.put("message", success ? formattedYmd + "일 작업을 완료했습니다." : "실행에러 메세지 = [" + outMsg + "]");
        } catch (Exception e) {
            log.error("SR_EXEC 호출 에러 [pgmId: {}]: ", pgmId, e);
            result.put("success", false);
            result.put("outMsg", e.getMessage());
            result.put("message", e.getMessage());
        }
        return result;
    }

    @Transactional
    public int deleteWfrmerr() {
        return runMapper.deleteWfrmerr();
    }

    @Transactional(readOnly = true)
    public List<RunCheckResultDto> selectCheckResults(String corpGr) {
        return runMapper.selectCheckResults(corpGr);
    }
}
